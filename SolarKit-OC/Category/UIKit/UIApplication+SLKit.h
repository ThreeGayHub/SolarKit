//
//  UIApplication+SLKit.h
//  Example
//
//  Created by wyh on 2017/7/6.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (SLKit)


+ (UIWindow *)keyWindow;

+ (UIViewController *)rootVC;

/**
 @return the top viewcontroller of screen
 */
+ (UIViewController *)topVC;

+ (UIWindow *)window;




/**
    make a phone call.
 */
+ (void)call:(NSString *)phoneNumber;

+ (BOOL)canOpenURL:(NSURL *)url;

+ (BOOL)openURL:(NSURL*)url;

+ (void)startRemoteNotification;

+ (void)stopRemoteNotification;

+ (void)changeRootViewControllerWithFadeAnimation:(UIViewController *)vc;

@end
