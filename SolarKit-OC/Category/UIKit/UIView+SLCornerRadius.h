//
//  UIView+SLCornerRadius.h
//  Example
//
//  Created by wyh on 2017/8/8.
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

@interface UIView (SLCornerRadius)

@property (nonatomic, assign) SLRectCorner multiCornerRadius;

@end
