//
//  UIApplication+SLKit.h
//  Example
//
//  Created by wyh on 2017/7/6.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (SLKit)


@property (class, nonatomic, strong, readonly) UIWindow *sl_keyWindow;

@property (class, nonatomic, strong, readonly) UIViewController *sl_rootVC;

/**
 @return the top viewcontroller of screen
 */
@property (class, nonatomic, strong, readonly) UIViewController *sl_topVC;

@property (class, nonatomic, strong, readonly) UIWindow *sl_window;




/**
    make a phone call.
 */
+ (void)sl_call:(NSString *)phoneNumber;

+ (BOOL)sl_canOpenURL:(NSURL *)url;

+ (BOOL)sl_openURL:(NSURL*)url;





//+ (void)changeRootViewControllerFade:(UIViewController *)viewController;

@end
