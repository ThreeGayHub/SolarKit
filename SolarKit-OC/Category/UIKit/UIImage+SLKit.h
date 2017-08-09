//
//  UIImage+SLKit.h
//  Example
//
//  Created by wyh on 2017/8/9.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SLKit)

@property (nonatomic, readonly) NSData *data;

@property (nonatomic, readonly) NSData *jpegData;

- (NSData *)jpegDataWithQuality:(float)quality;

@end
