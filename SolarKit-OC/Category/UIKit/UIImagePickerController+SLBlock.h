//
//  UIImagePickerController+SLBlock.h
//  Example
//
//  Created by wyh on 2017/8/9.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SLImagePickerType) {
    SLImagePickerTypeTakePhoto,     //allowsEditing
    SLImagePickerTypeVideo,         //cameraDevice, videoQuality
    SLImagePickerTypeAlbumList,     //allowsEditing
    SLImagePickerTypeAlbumTimeline, //allowsEditing
};

typedef void(^SLImagePickerControllerBlock)(NSData * _Nullable mediaData, NSError * _Nullable error);

typedef void(^SLImagePickerControllerVideoBlock)(NSData * _Nullable mediaData, NSUInteger seconds, NSError * _Nullable error);

@interface UIImagePickerController (SLBlock)

@property (nonatomic, assign) BOOL saveToAlbum;

+ (instancetype)pickerWithType:(SLImagePickerType)type;

- (void)selected:(nullable SLImagePickerControllerBlock)block;

- (void)selectedVideo:(nullable SLImagePickerControllerVideoBlock)block;

- (void)showInVC:(nullable UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END

