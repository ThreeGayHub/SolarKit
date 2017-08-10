//
//  UIButton+SLKit.m
//  Example
//
//  Created by wyh on 2017/8/10.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "UIButton+SLKit.h"

@implementation UIButton (SLKit)
@dynamic image, imageName, font, fontSize, titleColor, title, attributedTitle;

- (void)setImage:(UIImage *)image {
    [self setImage:image forState:UIControlStateNormal];
}

- (void)setImageName:(NSString *)imageName {
    self.image = [UIImage imageNamed:imageName];
}

- (void)setFont:(UIFont *)font {
    self.titleLabel.font = font;
}

- (void)setFontSize:(CGFloat)fontSize {
    self.font = [UIFont systemFontOfSize:fontSize];
}

- (void)setTitleColor:(UIColor *)titleColor {
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)setAttributedTitle:(NSAttributedString *)attributedTitle {
    [self setAttributedTitle:attributedTitle forState:UIControlStateNormal];
}

@end
