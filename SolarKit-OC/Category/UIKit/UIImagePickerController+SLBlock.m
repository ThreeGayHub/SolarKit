//
//  UIImagePickerController+SLBlock.m
//  Example
//
//  Created by wyh on 2017/8/9.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "UIImagePickerController+SLBlock.h"
#import <objc/runtime.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

typedef NS_ENUM(NSUInteger, SLMediaAuthorizationType) {
    SLMediaAuthorizationTypeCamera,
    SLMediaAuthorizationTypeAlbum,
    SLMediaAuthorizationTypeMicrophone,
};

typedef void(^SLImagePickerControllerEmptyBlock)(void);

@interface NSError (SLImagePickerController_Private)

+ (instancetype)errorWithCode:(NSInteger)code message:(NSString *)message;

@end

@interface UIImagePickerController (SLImagePickerController_Private) <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, assign) SLImagePickerType imagePickerType;

@property (nonatomic, copy) SLImagePickerControllerBlock selectedBlock;

@property (nonatomic, copy) SLImagePickerControllerVideoBlock selectedVideoBlock;

@end

@implementation UIImagePickerController (SLBlock)

+ (instancetype)pickerWithType:(SLImagePickerType)type {
    if ([UIImagePickerController isSourceTypeAvailable:[UIImagePickerController getSourceTypeWithType:type]]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.imagePickerType = type;
        picker.saveToAlbum = YES;
        return picker;
    }
    return nil;
}

- (instancetype)initWithPickerType:(SLImagePickerType)type
{
    self = [super init];
    if (self) {
        self.sourceType = [UIImagePickerController getSourceTypeWithType:type];
        self.imagePickerType = type;
        self.delegate = self;
    }
    return self;
}

- (void)selected:(SLImagePickerControllerBlock)block {
    self.selectedBlock = block;
}

- (void)selectedVideo:(SLImagePickerControllerVideoBlock)block {
    self.selectedVideoBlock = block;
}

- (void)showInVC:(UIViewController *)vc {
    if (vc) {
        switch (self.imagePickerType) {
            case SLImagePickerTypeVideo: {
                [self canUseCamera:^{
                    [self canUseMicrophone:^{
                        [vc presentViewController:self animated:YES completion:nil];
                    }];
                }];
            }
                break;
                
            case SLImagePickerTypeTakePhoto: {
                [self canUseCamera:^{
                    [vc presentViewController:self animated:YES completion:nil];
                }];
            }
                break;
                
            case SLImagePickerTypeAlbumList:
            case SLImagePickerTypeAlbumTimeline: {
                [self canUseAlbum:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [vc presentViewController:self animated:YES completion:nil];
                    });
                }];
            }
                break;
        }
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"相机或相册不可用" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSData *data;
    NSUInteger seconds = 0;
    if (self.imagePickerType == SLImagePickerTypeVideo) {
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
        data = [NSData dataWithContentsOfURL:url];
        
        AVURLAsset *avUrl = [AVURLAsset assetWithURL:url];
        CMTime time = [avUrl duration];
        seconds = time.value / time.timescale;
        
        if (self.saveToAlbum) {
            UISaveVideoAtPathToSavedPhotosAlbum(url.absoluteString, self, @selector(video:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
        }
    }
    else {
        UIImage *image;
        if (picker.allowsEditing) {
            image = info[UIImagePickerControllerEditedImage];
        }
        else {
            image = info[UIImagePickerControllerOriginalImage];
        }
        data = UIImagePNGRepresentation(image);
        
        if (self.imagePickerType == SLImagePickerTypeTakePhoto && self.saveToAlbum) {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
        }
    }
    
    if (self.selectedBlock) {
        NSLog(@"Length:%lu byte", [data length]);
        self.selectedBlock(data, nil);
    }
    if (self.selectedVideoBlock) {
        NSLog(@"Length:%lu byte\nSeconds:%lu", [data length], seconds);
        self.selectedVideoBlock(data, seconds, nil);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        NSLog(@"videoPath:%@ \ncode:%ld \nmessage:%@ \ncontextInfo:%@", videoPath, error.code, error.localizedDescription, contextInfo);
        if (self.selectedVideoBlock) {
            self.selectedVideoBlock(nil, 0, error);
        }
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"image:%@ \ncode:%ld \nmessage:%@ \ncontextInfo:%@", image, error.code, error.localizedDescription, contextInfo);
        if (self.selectedBlock) {
            self.selectedBlock(nil, error);
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSError *error = [NSError errorWithCode:-1 message:@"Cancel"];
    if (self.selectedBlock) {
        self.selectedBlock(nil, error);
    }
    if (self.selectedVideoBlock) {
        self.selectedVideoBlock(nil, 0, error);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Authorization

- (void)canUseCamera:(SLImagePickerControllerEmptyBlock)block {
    [self canUserMediaType:SLMediaAuthorizationTypeCamera block:block];
}

- (void)canUseAlbum:(SLImagePickerControllerEmptyBlock)block {
    [self canUserMediaType:SLMediaAuthorizationTypeAlbum block:block];
}

- (void)canUseMicrophone:(SLImagePickerControllerEmptyBlock)block {
    [self canUserMediaType:SLMediaAuthorizationTypeMicrophone block:block];
}

- (void)canUserMediaType:(SLMediaAuthorizationType)type block:(SLImagePickerControllerEmptyBlock)block {
    
    NSInteger status = 0;
    
    switch (type) {
        case SLMediaAuthorizationTypeCamera: {
            status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        }
            break;
            
        case SLMediaAuthorizationTypeAlbum: {
            status = [PHPhotoLibrary authorizationStatus];
        }
            break;
            
        case SLMediaAuthorizationTypeMicrophone: {
            status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        }
            break;
    }
    
    switch (status) {
        case 0: case 1: case 2: {
            [self requestAuthorizationWithType:type block:block];
        }
            break;
            
        case 3: {
            if (block) block();
        }
            break;
            
        default:
            break;
    }
    
}

- (void)requestAuthorizationWithType:(SLMediaAuthorizationType)type block:(SLImagePickerControllerEmptyBlock)block {
    switch (type) {
        case SLMediaAuthorizationTypeCamera: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted) {
                        if (block) block();
                    }
                    else {
                        [self showErrorWithType:type];
                    }
                });
            }];
            
        }
            break;
            
        case SLMediaAuthorizationTypeAlbum: {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    if (block) block();
                }
                else {
                    [self showErrorWithType:type];
                }
            }];
        }
            break;
            
        case SLMediaAuthorizationTypeMicrophone: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted) {
                        if (block) block();
                    }
                    else {
                        [self showErrorWithType:type];
                    }
                });
            }];
        }
            break;
    }
}

- (void)showErrorWithType:(SLMediaAuthorizationType)type {
    NSString *title = [self.authorizationNameDictionary[@(type)] stringByAppendingString:@"被禁用"];
    NSString *message = [NSString stringWithFormat:@"请到[设置]-[隐私]-[%@]中允许[%@]使用%@", self.authorizationNameDictionary[@(type)], [self appName], self.authorizationNameDictionary[@(type)]];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

- (NSDictionary *)authorizationNameDictionary {
    return @{
             @(SLMediaAuthorizationTypeCamera) : @"相机",
             @(SLMediaAuthorizationTypeAlbum) : @"相册",
             @(SLMediaAuthorizationTypeMicrophone) : @"麦克风",
             };
}

- (NSString *)appName {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"] ?: @"应用";
}


#pragma mark - Get & Set

+ (UIImagePickerControllerSourceType)getSourceTypeWithType:(SLImagePickerType)type {
    NSDictionary *dict = @{
                           @(SLImagePickerTypeTakePhoto) : @(UIImagePickerControllerSourceTypeCamera),
                           @(SLImagePickerTypeVideo) : @(UIImagePickerControllerSourceTypeCamera),
                           @(SLImagePickerTypeAlbumList) : @(UIImagePickerControllerSourceTypePhotoLibrary),
                           @(SLImagePickerTypeAlbumTimeline) : @(UIImagePickerControllerSourceTypeSavedPhotosAlbum),
                           };
    return [dict[@(type)] integerValue];
}

- (void)setImagePickerType:(SLImagePickerType)imagePickerType {
    objc_setAssociatedObject(self, @selector(imagePickerType), @(imagePickerType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    self.sourceType = [UIImagePickerController getSourceTypeWithType:imagePickerType];
    self.delegate = self;
    switch (imagePickerType) {
        case SLImagePickerTypeTakePhoto: {
            self.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        }
            break;
            
        case SLImagePickerTypeVideo: {
            NSString *requiredMediaType = ( NSString *)kUTTypeMovie;
            self.mediaTypes = @[requiredMediaType];
            self.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
        }
            break;
            
        default:
            break;
    }
}

- (SLImagePickerType)imagePickerType {
    return [objc_getAssociatedObject(self, _cmd) unsignedIntegerValue];
}

- (void)setSelectedBlock:(SLImagePickerControllerBlock)selectedBlock {
    objc_setAssociatedObject(self, @selector(selectedBlock), selectedBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (SLImagePickerControllerBlock)selectedBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSelectedVideoBlock:(SLImagePickerControllerVideoBlock)selectedVideoBlock {
    objc_setAssociatedObject(self, @selector(selectedVideoBlock), selectedVideoBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (SLImagePickerControllerVideoBlock)selectedVideoBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSaveToAlbum:(BOOL)saveToAlbum {
    objc_setAssociatedObject(self, @selector(saveToAlbum), @(saveToAlbum), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)saveToAlbum {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end

@implementation NSError (SLImagePickerController_Private)

+ (instancetype)errorWithCode:(NSInteger)code message:(NSString *)message {
    return [NSError errorWithDomain:[self bundleID] code:code userInfo:@{NSLocalizedDescriptionKey : message ?:@""}];
}

+ (NSString *)bundleID {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

@end

