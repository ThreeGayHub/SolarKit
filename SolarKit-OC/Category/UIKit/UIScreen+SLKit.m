//
//  UIScreen+SLKit.m
//  Example
//
//  Created by wyh on 2017/8/8.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "UIScreen+SLKit.h"

@implementation UIScreen (SLKit)

+ (CGFloat)width {
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)height {
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGSize)size {
    return [UIScreen mainScreen].bounds.size;
}

@end
