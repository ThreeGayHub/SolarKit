//
//  UIApplication+SLKit.h
//  Example
//
//  Created by wyh on 2017/7/6.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (SLKit)


@property (class, nonatomic, strong, readonly) UIWindow *keyWindow;

@property (class, nonatomic, strong, readonly) UIViewController *rootVC;

/**
 @return the top viewcontroller of screen
 */
@property (class, nonatomic, strong, readonly) UIViewController *topVC;

@property (class, nonatomic, strong, readonly) UIWindow *window;




/**
    make a phone call.
 */
+ (void)call:(NSString *)phoneNumber;

+ (BOOL)canOpenURL:(NSURL *)url;

+ (BOOL)openURL:(NSURL*)url;

//TODO-开启和关闭推送


//+ (void)changeRootViewControllerFade:(UIViewController *)viewController;

@end
