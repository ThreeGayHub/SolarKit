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
 @return [UIApplication sharedApplication].keyWindow;
 */
@property (class, nonatomic, strong, readonly) UIWindow *sl_keyWindow;

/**
 @return [UIApplication sharedApplication].delegate.window.rootViewController;
 */
@property (class, nonatomic, strong, readonly) UIViewController *sl_rootVC;

/**
 @return the top viewcontroller of screen
 */
@property (class, nonatomic, strong, readonly) UIViewController *sl_topVC;

/**
 @return [UIApplication sharedApplication].delegate.window;
 */
@property (class, nonatomic, strong, readonly) UIWindow *sl_window;




/**
    make a phone call.
 */
+ (void)sl_call:(NSString *)phoneNumber;

/**
 @return [[UIApplication sharedApplication] canOpenURL:url];
 */
+ (BOOL)sl_canOpenURL:(NSURL *)url;

/**
    @return [[UIApplication sharedApplication] openURL:url];
 */
+ (BOOL)sl_openURL:(NSURL*)url;





//+ (void)changeRootViewControllerFade:(UIViewController *)viewController;

@end
