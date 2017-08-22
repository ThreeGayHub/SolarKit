//
//  UIApplication+SLKit.h
//  Example
//
//  Created by wyh on 2017/7/6.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (SLKit)


/**
 @return the top viewcontroller of screen
 */
+ (UIViewController *)topVC;

/**
    make a phone call.
 */
+ (void)call:(NSString *)phoneNumber;

+ (void)changeRootViewControllerWithFadeAnimation:(UIViewController *)vc;

+ (void)startWebThread;

@end
