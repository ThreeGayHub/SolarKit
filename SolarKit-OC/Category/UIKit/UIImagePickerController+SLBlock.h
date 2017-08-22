//
//  UIImagePickerController+SLBlock.h
//  Example
//
//  Created by wyh on 2017/8/9.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SLImagePickerType) {
    SLImagePickerTypeTakePhoto,     //allowsEditing
    SLImagePickerTypeVideo,         //cameraDevice, videoQuality
    SLImagePickerTypeAlbumList,     //allowsEditing
    SLImagePickerTypeAlbumTimeline, //allowsEditing
};

typedef void(^SLImagePickerControllerBlock)(NSData *mediaData);

typedef void(^SLImagePickerControllerVideoBlock)(NSData *mediaData, NSUInteger seconds);

@interface UIImagePickerController (SLBlock)

@property (nonatomic, assign) BOOL saveToAlbum;

+ (instancetype)pickerWithType:(SLImagePickerType)type;

- (void)selected:(SLImagePickerControllerBlock)block;

- (void)selectedVideo:(SLImagePickerControllerVideoBlock)block;

- (void)showInVC:(UIViewController *)vc;

@end
