//
//  UIImage+SLLuban.h
//  Example
//
//  Created by wyh on 2017/8/9.
//  Copyright © 2017年 SolarKit. All rights reserved.
//
//鲁班算法：https://github.com/Curzibn/Luban/blob/master/DESCRIPTION.md

#import <UIKit/UIKit.h>

@interface UIImage (SLLuban)

@property (nonatomic, readonly) UIImage *compressImage;

- (UIImage *)compressImageWithWatermark:(UIImage *)watermarkImage;

- (UIImage *)compressToScale:(float)scale;

- (UIImage *)compressToSize:(CGSize)newSize;

@end
