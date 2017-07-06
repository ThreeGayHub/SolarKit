//
//  UIApplication+SLKit.m
//  Example
//
//  Created by wyh on 2017/7/6.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "UIApplication+SLKit.h"

@implementation UIApplication (SLKit)

+ (UIWindow *)sl_keyWindow {
    return [UIApplication sharedApplication].keyWindow;
}

+ (UIViewController *)sl_rootVC {
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}

+ (UIViewController *)sl_topVC {
    return [self _sl_visibleViewControllerFrom:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIWindow *)sl_window {
    return [UIApplication sharedApplication].delegate.window;
}





+ (void)sl_call:(NSString *)phoneNumber {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel:" stringByAppendingString:phoneNumber]]];
}

+ (BOOL)sl_canOpenURL:(NSURL *)url {
    return [[UIApplication sharedApplication] canOpenURL:url];
}

+ (BOOL)sl_openURL:(NSURL *)url {
    return [[UIApplication sharedApplication] openURL:url];
}






#pragma mark - privete

+ (UIViewController *)_sl_visibleViewControllerFrom:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _sl_visibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    }
    
    if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _sl_visibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    }
    
    if (vc.presentedViewController) {
        return [self _sl_visibleViewControllerFrom:vc.presentedViewController];
    }
    return vc;
}



//+ (void)changeRootViewControllerFade:(UIViewController *)viewController {
//    CATransition *fadeTransition = [CATransition fadeTransation];
//    [UIApplication.yh_window.layer addAnimation:fadeTransition forKey:kCATransition];
//    UIApplication.yh_window.rootViewController = viewController;
//}

@end
