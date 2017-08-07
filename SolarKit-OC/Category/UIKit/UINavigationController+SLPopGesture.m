//
//  UINavigationController+SLPopGesture.m
//  Example
//
//  Created by wyh on 2017/8/7.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "UINavigationController+SLPopGesture.h"
#import <objc/runtime.h>

@implementation UINavigationController (SLPopGesture)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewDidLoad);
        SEL swizzledSelector = @selector(sl_navigationControllerPopGestureViewDidLoad);
        
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

- (void)sl_navigationControllerPopGestureViewDidLoad {
    [self sl_navigationControllerPopGestureViewDidLoad];
    
    self.popGestureEnable = YES;
    self.interactivePopGestureRecognizer.delegate = self;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    BOOL result = self.popGestureEnable && self.viewControllers.count > 1;
    return result;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

- (void)setPopGestureEnable:(BOOL)popGestureEnable {
    objc_setAssociatedObject(self, @selector(popGestureEnable), @(popGestureEnable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)popGestureEnable {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end
