//
//  UIView+SLCornerRadius.m
//  Example
//
//  Created by wyh on 2017/8/8.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "UIView+SLCornerRadius.h"

@implementation UIView (SLCornerRadius)
@dynamic multiCornerRadius;

- (void)setMultiCornerRadius:(SLRadius)multiCornerRadius {
    CGFloat Width = self.bounds.size.width;
    CGFloat Height = self.bounds.size.height;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(0, multiCornerRadius.topLeft)];
    [path addArcWithCenter:CGPointMake(multiCornerRadius.topLeft, multiCornerRadius.topLeft) radius:multiCornerRadius.topLeft startAngle:M_PI endAngle:M_PI + M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(Width - multiCornerRadius.topRight, 0)];
    [path addArcWithCenter:CGPointMake(Width - multiCornerRadius.topRight, multiCornerRadius.topRight) radius:multiCornerRadius.topRight startAngle:M_PI + M_PI_2 endAngle:0 clockwise:YES];
    [path addLineToPoint:CGPointMake(Width, Height - multiCornerRadius.bottomRight)];
    [path addArcWithCenter:CGPointMake(Width - multiCornerRadius.bottomRight, Height - multiCornerRadius.bottomRight) radius:multiCornerRadius.bottomRight startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(multiCornerRadius.bottomLeft, Height)];
    [path addArcWithCenter:CGPointMake(multiCornerRadius.bottomLeft, Height - multiCornerRadius.bottomLeft) radius:multiCornerRadius.bottomLeft startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path closePath];
    
    CAShapeLayer* layer = [[CAShapeLayer alloc] init];
    layer.frame = self.bounds;
    layer.path= path.CGPath;
    self.layer.mask = layer;
}

@end
