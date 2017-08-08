//
//  UINavigationController+SLTransition.m
//  Example
//
//  Created by wyh on 2017/8/8.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "UINavigationController+SLTransition.h"

@implementation UINavigationController (SLTransition)

- (void)pushVCWithFadeAnimation:(UIViewController *)vc {
    CATransition *fadeTransition = [self _fadeTransation];
    [self.view.layer addAnimation:fadeTransition forKey:kCATransition];
    [self pushViewController:vc animated:NO];
}

- (void)popVCWithFadeAnimation {
    CATransition *fadeTransition = [self _fadeTransation];
    [self.view.layer addAnimation:fadeTransition forKey:kCATransition];
    [self popViewControllerAnimated:NO];
}

- (CATransition *)_fadeTransation {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromTop;
    return transition;
}

@end
