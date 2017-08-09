//
//  UIView+SLLayer.h
//  Example
//
//  Created by wyh on 2017/8/9.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <UIKit/UIKit.h>

struct SLRectCorner {
    CGFloat topLeft;
    CGFloat topRight;
    CGFloat bottomLeft;
    CGFloat bottomRight;
};
typedef struct SLRectCorner SLRectCorner;

static inline SLRectCorner SLRectCornerMake(CGFloat topLeft, CGFloat topRight, CGFloat bottomLeft, CGFloat bottomRight) {
    SLRectCorner radius;
    radius.topLeft = topLeft;
    radius.topRight = topRight;
    radius.bottomLeft = bottomLeft;
    radius.bottomRight = bottomRight;
    return radius;
}

struct SLBorderWidth {
    CGFloat top;
    CGFloat left;
    CGFloat bottom;
    CGFloat right;
};
typedef struct SLBorderWidth SLBorderWidth;

static inline SLBorderWidth SLBorderWidthMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right) {
    SLBorderWidth borderWidth;
    borderWidth.top = top;
    borderWidth.left = left;
    borderWidth.bottom = bottom;
    borderWidth.right = right;
    return borderWidth;
}

@interface UIView (SLLayer)

@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic, assign) SLBorderWidth multiBorderWidth;

@property (nonatomic, assign) SLRectCorner multiCornerRadius;

@property (nonatomic, assign) CGFloat cornerRadius;

@end
