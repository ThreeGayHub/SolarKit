//
//  UINavigationItem+SLNilTitleBackItem.m
//  Pods
//
//  Created by wyh on 2017/7/7.
//
//

#import "UINavigationItem+SLNilTitleBackItem.h"
#import <objc/runtime.h>

@implementation UINavigationItem (SLNilTitleBackItem)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(backBarButtonItem);
        SEL swizzledSelector = @selector(sl_backBarButtonItem);
        
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

- (UIBarButtonItem *)sl_backBarButtonItem {
    return [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

@end
