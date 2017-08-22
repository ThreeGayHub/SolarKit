//
//  UINavigationBar+SLKit.m
//  Example
//
//  Created by wyh on 2017/8/17.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "UINavigationBar+SLKit.h"

@implementation UINavigationBar (SLKit)


- (void)setShadowImageHidden:(BOOL)shadowImageHidden {
    [self _shadowImageView:self].hidden = shadowImageHidden;
}

- (BOOL)shadowImageHidden {
    return [self _shadowImageView:self].hidden;
}

#pragma mark - Private

- (UIImageView *)_shadowImageView:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self _shadowImageView:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

@end
