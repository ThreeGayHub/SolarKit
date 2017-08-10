//
//  UICollectionViewCell+SLHighlighted.m
//  Example
//
//  Created by wyh on 2017/8/10.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "UICollectionViewCell+SLHighlighted.h"
#import <objc/runtime.h>

@interface UICollectionViewCell (SLCollectionViewCell_Private)

@property (nonatomic, strong) UIColor *originalBackgroundColor;

@end

@implementation UICollectionViewCell (SLHighlighted)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(setHighlighted:);
        SEL swizzledSelector = @selector(sl_setHighlighted:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }
        else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)sl_setHighlighted:(BOOL)highlighted {
    [self sl_setHighlighted:highlighted];
    if (!self.originalBackgroundColor) {
        self.originalBackgroundColor = self.contentView.backgroundColor;
    }
    self.contentView.backgroundColor = highlighted ? [UIColor colorWithRed:0.92 green:0.92 blue:0.94 alpha:1] : self.originalBackgroundColor;
}

- (void)setOriginalBackgroundColor:(UIColor *)originalBackgroundColor {
    objc_setAssociatedObject(self, @selector(originalBackgroundColor), originalBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)originalBackgroundColor {
    return objc_getAssociatedObject(self, _cmd);
}

@end
