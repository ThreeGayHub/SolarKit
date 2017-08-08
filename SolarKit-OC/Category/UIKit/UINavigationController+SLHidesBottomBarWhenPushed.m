//
//  UINavigationController+SLHidesBottomBarWhenPushed.m
//  Example
//
//  Created by wyh on 2017/8/8.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "UINavigationController+SLHidesBottomBarWhenPushed.h"
#import <objc/runtime.h>

@implementation UINavigationController (SLHidesBottomBarWhenPushed)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(pushViewController:animated:);
        SEL swizzledSelector = @selector(sl_pushViewController:animated:);
        
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

- (void)sl_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [self sl_pushViewController:viewController animated:animated];
}

@end
