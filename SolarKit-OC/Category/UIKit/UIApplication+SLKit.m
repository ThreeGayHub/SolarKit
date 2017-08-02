//
//  UIApplication+SLKit.m
//  Example
//
//  Created by wyh on 2017/7/6.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "UIApplication+SLKit.h"

@implementation UIApplication (SLKit)

+ (UIWindow *)keyWindow {
    return [UIApplication sharedApplication].keyWindow;
}

+ (UIViewController *)rootVC {
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}

+ (UIViewController *)topVC {
    return [self _visibleViewControllerFrom:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIWindow *)window {
    return [UIApplication sharedApplication].delegate.window;
}





+ (void)call:(NSString *)phoneNumber {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel:" stringByAppendingString:phoneNumber]]];
}

+ (BOOL)canOpenURL:(NSURL *)url {
    return [[UIApplication sharedApplication] canOpenURL:url];
}

+ (BOOL)openURL:(NSURL *)url {
    return [[UIApplication sharedApplication] openURL:url];
}






#pragma mark - privete

+ (UIViewController *)_visibleViewControllerFrom:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _visibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    }
    
    if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _visibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    }
    
    if (vc.presentedViewController) {
        return [self _visibleViewControllerFrom:vc.presentedViewController];
    }
    return vc;
}



//+ (void)changeRootViewControllerFade:(UIViewController *)viewController {
//    CATransition *fadeTransition = [CATransition fadeTransation];
//    [UIApplication.yh_window.layer addAnimation:fadeTransition forKey:kCATransition];
//    UIApplication.yh_window.rootViewController = viewController;
//}

@end
