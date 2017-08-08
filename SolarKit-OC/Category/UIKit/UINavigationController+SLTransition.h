//
//  UINavigationController+SLTransition.h
//  Example
//
//  Created by wyh on 2017/8/8.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (SLTransition)

- (void)pushVCWithFadeAnimation:(UIViewController *)vc;

- (void)popVCWithFadeAnimation;

@end
