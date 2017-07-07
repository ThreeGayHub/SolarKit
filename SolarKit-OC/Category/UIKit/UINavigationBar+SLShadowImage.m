//
//  UINavigationBar+SLShadowImage.m
//  Pods
//
//  Created by wyh on 2017/7/7.
//
//

#import "UINavigationBar+SLShadowImage.h"

@implementation UINavigationBar (SLShadowImage)

- (void)setShadowImageHidden:(BOOL)shadowImageHidden {
    [self shadowImageView:self].hidden = shadowImageHidden;
}

- (UIImageView *)shadowImageView:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self shadowImageView:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (BOOL)shadowImageHidden {
    return [self shadowImageView:self].hidden;
}

@end
