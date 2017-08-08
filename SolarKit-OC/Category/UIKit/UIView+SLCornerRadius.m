//
//  UIView+SLCornerRadius.m
//  Example
//
//  Created by wyh on 2017/8/8.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "UIView+SLCornerRadius.h"
#import <objc/runtime.h>

@interface UIView (SLViewCornerRadius_Private)

@property (nonatomic, strong) NSMutableDictionary *cornerRadiusDict;

@end

@implementation UIView (SLCornerRadius)
@dynamic multiCornerRadius;

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(layoutSubviews);
        SEL swizzledSelector = @selector(sl_layoutSubviews);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)setMultiCornerRadius:(SLRectCorner)multiCornerRadius {
    
    [self.cornerRadiusDict setObject:@(multiCornerRadius.topLeft) forKey:@"topLeft"];
    [self.cornerRadiusDict setObject:@(multiCornerRadius.topRight) forKey:@"topRight"];
    [self.cornerRadiusDict setObject:@(multiCornerRadius.bottomLeft) forKey:@"bottomLeft"];
    [self.cornerRadiusDict setObject:@(multiCornerRadius.bottomRight) forKey:@"bottomRight"];
    
}

- (void)sl_layoutSubviews {
    [self sl_layoutSubviews];
    
    if (self.cornerRadiusDict.count > 0) {
        CGFloat Width = self.bounds.size.width;
        CGFloat Height = self.bounds.size.height;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        CGFloat topLeft = [self.cornerRadiusDict[@"topLeft"] floatValue];
        CGFloat topRight = [self.cornerRadiusDict[@"topRight"] floatValue];
        CGFloat bottomLeft = [self.cornerRadiusDict[@"bottomLeft"] floatValue];
        CGFloat bottomRight = [self.cornerRadiusDict[@"bottomRight"] floatValue];

        [path moveToPoint:CGPointMake(0, topLeft)];
        [path addArcWithCenter:CGPointMake(topLeft, topLeft) radius:topLeft startAngle:M_PI endAngle:M_PI + M_PI_2 clockwise:YES];
        [path addLineToPoint:CGPointMake(Width - topRight, 0)];
        [path addArcWithCenter:CGPointMake(Width - topRight, topRight) radius:topRight startAngle:M_PI + M_PI_2 endAngle:0 clockwise:YES];
        [path addLineToPoint:CGPointMake(Width, Height - bottomRight)];
        [path addArcWithCenter:CGPointMake(Width - bottomRight, Height - bottomRight) radius:bottomRight startAngle:0 endAngle:M_PI_2 clockwise:YES];
        [path addLineToPoint:CGPointMake(bottomLeft, Height)];
        [path addArcWithCenter:CGPointMake(bottomLeft, Height - bottomLeft) radius:bottomLeft startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
        [path closePath];
        
        CAShapeLayer* layer = [[CAShapeLayer alloc] init];
        layer.frame = self.bounds;
        layer.path= path.CGPath;
        self.layer.mask = layer;

    }
}

- (NSMutableDictionary *)cornerRadiusDict {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, _cmd);
    if (dict) return dict;
    
    dict = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, _cmd, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return dict;
}

@end
