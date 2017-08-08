//
//  UINavigationController+SLRemoveVC.m
//  Example
//
//  Created by wyh on 2017/8/8.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "UINavigationController+SLRemoveVC.h"

@implementation UINavigationController (SLRemoveVC)

- (void)removeVC:(UIViewController *)vc {
    NSMutableArray *viewControllers = self.viewControllers.mutableCopy;
    [viewControllers removeObject:vc];
    self.viewControllers = viewControllers.copy;
}

- (void)removeAllMiddleVC {
    NSMutableArray *viewControllers = self.viewControllers.mutableCopy;
    if (viewControllers.count >= 3) {
        [viewControllers removeObjectsInRange:NSMakeRange(1, viewControllers.count - 2)];
        self.viewControllers = viewControllers.copy;
    }
}

- (void)removeVCWithClasses:(NSArray<Class> *)classes {
    NSMutableArray<UIViewController *> *viewControllers = self.viewControllers.mutableCopy;
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([classes containsObject:[obj class]]) {
            [viewControllers removeObject:obj];
        }
    }];
    self.viewControllers = viewControllers.copy;
}

@end
