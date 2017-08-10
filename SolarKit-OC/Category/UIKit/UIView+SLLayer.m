//
//  UIView+SLLayer.m
//  Example
//
//  Created by wyh on 2017/8/9.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "UIView+SLLayer.h"
#import <objc/runtime.h>

@interface UIView (SLLayer_Private)

@property (nonatomic, strong) NSMutableDictionary *borderWidthDict;

@property (nonatomic, strong) NSMutableDictionary *cornerRadiusDict;

@end

@implementation UIView (SLLayer)
@dynamic borderColor, multiBorderWidth, multiCornerRadius, cornerRadius;

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

- (void)sl_layoutSubviews {
    [self sl_layoutSubviews];
    
    if (self.borderWidthDict.count > 0) {
        
        CGFloat Width = self.bounds.size.width;
        CGFloat Height = self.bounds.size.height;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        CGFloat top = [self.borderWidthDict[@"top"] floatValue];
        CGFloat left = [self.borderWidthDict[@"left"] floatValue];
        CGFloat bottom = [self.borderWidthDict[@"bottom"] floatValue];
        CGFloat right = [self.borderWidthDict[@"right"] floatValue];
        
        if (top > 0) {
            [path appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, Width, top)]];
        }
        if (left > 0) {
            [path appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, left, Height)]];
        }
        if (bottom > 0) {
            [path appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(0, Height - bottom, Width, bottom)]];
        }
        if (right > 0) {
            [path appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(Width - right, 0, right, Height)]];
        }
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = path.CGPath;
        layer.fillColor = self.layer.borderColor;
        [self.layer addSublayer:layer];        
    }
    
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

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setMultiBorderWidth:(SLBorderWidth)multiBorderWidth {
    [self.borderWidthDict setObject:@(multiBorderWidth.top) forKey:@"top"];
    [self.borderWidthDict setObject:@(multiBorderWidth.left) forKey:@"left"];
    [self.borderWidthDict setObject:@(multiBorderWidth.bottom) forKey:@"bottom"];
    [self.borderWidthDict setObject:@(multiBorderWidth.right) forKey:@"right"];
}

- (void)setMultiCornerRadius:(SLRectCorner)multiCornerRadius {
    [self.cornerRadiusDict setObject:@(multiCornerRadius.topLeft) forKey:@"topLeft"];
    [self.cornerRadiusDict setObject:@(multiCornerRadius.topRight) forKey:@"topRight"];
    [self.cornerRadiusDict setObject:@(multiCornerRadius.bottomLeft) forKey:@"bottomLeft"];
    [self.cornerRadiusDict setObject:@(multiCornerRadius.bottomRight) forKey:@"bottomRight"];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

- (NSMutableDictionary *)borderWidthDict {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, _cmd);
    if (dict) return dict;
    
    dict = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, _cmd, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return dict;
}

- (NSMutableDictionary *)cornerRadiusDict {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, _cmd);
    if (dict) return dict;
    
    dict = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, _cmd, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return dict;
}

@end
