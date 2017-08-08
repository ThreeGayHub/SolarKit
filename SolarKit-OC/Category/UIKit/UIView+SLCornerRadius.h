//
//  UIView+SLCornerRadius.h
//  Example
//
//  Created by wyh on 2017/8/8.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <UIKit/UIKit.h>

struct SLRadius {
    CGFloat topLeft;
    CGFloat topRight;
    CGFloat bottomLeft;
    CGFloat bottomRight;
};
typedef struct SLRadius SLRadius;

static inline SLRadius SLRadiusMake(CGFloat topLeft, CGFloat topRight, CGFloat bottomLeft, CGFloat bottomRight) {
    SLRadius radius;
    radius.topLeft = topLeft;
    radius.topRight = topRight;
    radius.bottomLeft = bottomLeft;
    radius.bottomRight = bottomRight;
    return radius;
}

@interface UIView (SLCornerRadius)

@property (nonatomic, assign) SLRadius multiCornerRadius;

@end
