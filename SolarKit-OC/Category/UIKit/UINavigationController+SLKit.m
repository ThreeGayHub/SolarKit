//
//  UINavigationController+SLKit.m
//  Example
//
//  Created by wyh on 2017/8/17.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "UINavigationController+SLKit.h"

@implementation UINavigationController (SLKit)
@dynamic barBackgroundColor, barTintColor, titleColor;

- (void)setBarBackgroundColor:(UIColor *)barBackgroundColor {
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = barBackgroundColor;
}

- (void)setBarTintColor:(UIColor *)barTintColor {
    self.navigationBar.tintColor = barTintColor;
}

- (void)setTitleColor:(UIColor *)titleColor {
    NSMutableDictionary *titleTextAttributes = [NSMutableDictionary dictionary];
    [titleTextAttributes setObject:titleColor forKey:NSForegroundColorAttributeName];
    self.navigationBar.titleTextAttributes = titleTextAttributes;
}

@end
