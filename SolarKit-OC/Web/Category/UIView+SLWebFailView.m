//
//  UIView+SLWebFailView.m
//  Example
//
//  Created by wyh on 2017/12/5.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "UIView+SLWebFailView.h"
#import <objc/runtime.h>
#import "NSBundle+SLWeb.h"

@interface SLWebFailView ()

@property (nonatomic, copy) SLWebFailViewClick click;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation SLWebFailView

- (void)setImageName:(NSString *)imageName {
    if (![self.subviews containsObject:self.imageView]) {
        [self addSubview:self.imageView];

        CGFloat Width = UIScreen.mainScreen.bounds.size.width;
        
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:Width / 3];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
        [self addConstraints:@[top, left, right, width, height]];
    }
    
    NSBundle *bundle = [NSBundle bundleWithName:@"SLWeb"];
    NSString *imagePath = [bundle pathForResource:imageName ofType:@"png" inDirectory:@"images"];
    UIImage *failImage = [UIImage imageWithContentsOfFile:imagePath];
    self.imageView.image = failImage;
}

- (void)setText:(NSString *)text {
    if (![self.subviews containsObject:self.textLabel]) {
        [self addSubview:self.textLabel];
        
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeBottom multiplier:1 constant:12];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        [self addConstraints:@[top, left, bottom, right]];
    }
    
    self.textLabel.text = text;
}

- (void)clickAction:(SLWebFailViewClick)click {
    _click = click;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tapGesture {
    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        self.text = @"请稍候...";
        if (self.click) self.click();
    }
}

- (UIImageView *)imageView {
    if (_imageView) return _imageView;
    
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    return _imageView;
}

- (UILabel *)textLabel {
    if (_textLabel) return _textLabel;
    
    _textLabel = [[UILabel alloc] init];
    _textLabel.font = [UIFont systemFontOfSize:16];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
    _textLabel.numberOfLines = 0;
    _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    return _textLabel;
}

@end

@implementation UIView (SLWebFailView)

- (void)addFailViewWithImageName:(NSString *)imageName text:(NSString *)text click:(SLWebFailViewClick)click {
    if (!self.failView) {
        self.failView = [[SLWebFailView alloc] init];
        self.failView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.failView];
        self.failView.imageName = imageName;
        [self.failView clickAction:click];
        
        NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.failView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.failView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:-44];
        [self addConstraints:@[centerX, centerY]];
    }
    else {
        if (![self.subviews containsObject:self.failView]) {
            [self addSubview:self.failView];
        }
    }
    self.failView.text = text;
}

- (void)removeFailView {
    if (self.failView && [self.subviews containsObject:self.failView]) {
        [self.failView removeFromSuperview];
    }
}

- (void)setFailView:(SLWebFailView *)failView {
    objc_setAssociatedObject(self, @selector(failView), failView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SLWebFailView *)failView {
    return objc_getAssociatedObject(self, _cmd);
}

@end
