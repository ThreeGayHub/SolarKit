//
//  UINavigationController+SLRemoveVC.h
//  Example
//
//  Created by wyh on 2017/8/8.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (SLRemoveVC)

- (void)removeVC:(UIViewController *)vc;

- (void)removeAllMiddleVC;

- (void)removeVCWithClasses:(NSArray <Class>*)classes;

@end
