//
//  UIViewController+SLKit.m
//  Pods
//
//  Created by wyh on 2017/7/6.
//
//

#import "UIViewController+SLKit.h"
#import <objc/runtime.h>

@implementation UIViewController (SLKit)

- (void)setParameters:(NSDictionary *)parameters {
    objc_setAssociatedObject(self, @selector(parameters), parameters, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSDictionary *)parameters {
    return objc_getAssociatedObject(self, _cmd);
}

@end
