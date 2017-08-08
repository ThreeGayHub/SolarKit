//
//  UIScreen+SLKit.h
//  Example
//
//  Created by wyh on 2017/8/8.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef ScreenWidth
#define ScreenWidth   [UIScreen mainScreen].bounds.size.width
#endif

#ifndef ScreenHeight
#define ScreenHeight   [UIScreen mainScreen].bounds.size.height
#endif

#ifndef ScreenSize
#define ScreenSize   [UIScreen mainScreen].bounds.size
#endif

@interface UIScreen (SLKit)

+ (CGFloat)width;

+ (CGFloat)height;

+ (CGSize)size;

@end
