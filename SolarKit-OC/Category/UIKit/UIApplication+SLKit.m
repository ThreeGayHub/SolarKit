//
//  UIApplication+SLKit.m
//  Example
//
//  Created by wyh on 2017/7/6.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "UIApplication+SLKit.h"

@implementation UIApplication (SLKit)

+ (UIViewController *)topVC {
    return [self _visibleViewControllerFrom:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (void)call:(NSString *)phoneNumber {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel:" stringByAppendingString:phoneNumber]]];
}

+ (void)changeRootViewControllerWithFadeAnimation:(UIViewController *)vc {
    CATransition *fadeTransition = [self _fadeTransation];
    [[UIApplication sharedApplication].delegate.window.layer addAnimation:fadeTransition forKey:kCATransition];
    [UIApplication sharedApplication].delegate.window.rootViewController = vc;
}

+ (void)startWebThread {
    UIWebView *webPool = [[UIWebView alloc]initWithFrame:CGRectZero];
    [webPool loadHTMLString:@"" baseURL:nil];
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

+ (CATransition *)_fadeTransation {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromTop;
    return transition;
}



@end
