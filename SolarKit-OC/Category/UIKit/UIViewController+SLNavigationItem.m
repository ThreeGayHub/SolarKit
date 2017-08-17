//
//  UIViewController+SLNavigationItem.m
//  Example
//
//  Created by wyh on 2017/8/17.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "UIViewController+SLNavigationItem.h"

@implementation UIViewController (SLNavigationItem)

- (void)setLeftItemWithImage:(NSString *)leftItemImageName {
    [self setLeftItemWithImage:leftItemImageName title:nil];
}

- (void)setLeftItemWithTitle:(NSString *)leftItemTitle {
    [self setLeftItemWithImage:nil title:leftItemTitle];
}

- (void)setLeftItemWithImage:(NSString *)leftItemImageName title:(NSString *)leftItemTitle {
    if (leftItemImageName && leftItemTitle) {
        UIButton *button = [self leftBarButton];
        [button setImage:[UIImage imageNamed:leftItemImageName] forState:UIControlStateNormal];
        [button setTitle:leftItemTitle forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = [self barButtonItem:button];
    }
    else {
        if (leftItemImageName) {
            self.navigationItem.leftBarButtonItem = [self leftBarButtonItemWithImage:leftItemImageName];
        }
        else if (leftItemTitle) {
            self.navigationItem.leftBarButtonItem = [self leftBarButtonItemWithTitle:leftItemTitle];
        }
    }
}

- (void)setLeftItemWithBarButtonSystemItem:(UIBarButtonSystemItem)barButtonSystemItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:barButtonSystemItem target:self action:@selector(leftAction)];
}

- (void)setLeftItemWithView:(UIView *)leftView {
    if ([leftView isKindOfClass:[UIControl class]]) {
        UIControl *control = (UIControl *)leftView;
        [control addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        leftView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftViewTapGesture:)];
        [leftView addGestureRecognizer:tapGesture];
    }
    self.navigationItem.leftBarButtonItem = [self barButtonItem:leftView];
}

- (void)setRightItemWithImage:(NSString *)rightItemImageName {
    [self setRightItemWithImage:rightItemImageName title:nil];
}

- (void)setRightItemWithTitle:(NSString *)rightItemTitle {
    [self setRightItemWithImage:nil title:rightItemTitle];
}

- (void)setRightItemWithImage:(NSString *)rightItemImageName title:(NSString *)rightItemTitle  {
    if (rightItemImageName && rightItemTitle) {
        UIButton *button = [self rightBarButton];
        [button setImage:[UIImage imageNamed:rightItemImageName] forState:UIControlStateNormal];
        [button setTitle:rightItemTitle forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [self barButtonItem:button];
    }
    else {
        if (rightItemImageName) {
            self.navigationItem.rightBarButtonItem = [self rightBarButtonItemWithImage:rightItemImageName];
        }
        else if (rightItemTitle) {
            self.navigationItem.rightBarButtonItem = [self rightBarButtonItemWithTitle:rightItemTitle];
        }
    }
}

- (void)setRightItemWithBarButtonSystemItem:(UIBarButtonSystemItem)barButtonSystemItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:barButtonSystemItem target:self action:@selector(rightAction)];
}

- (void)setRightItemWithView:(UIView *)rightView {
    if ([rightView isKindOfClass:[UIControl class]]) {
        UIControl *control = (UIControl *)rightView;
        [control addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        rightView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightViewTapGesture:)];
        [rightView addGestureRecognizer:tapGesture];
    }
    self.navigationItem.rightBarButtonItem = [self barButtonItem:rightView];
}

#pragma mark - Action

- (void)leftViewTapGesture:(UITapGestureRecognizer *)tapGesture {
    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        [self leftAction];
    }
}

- (void)rightViewTapGesture:(UITapGestureRecognizer *)tapGesture {
    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        [self rightAction];
    }
}

- (void)leftAction {
    if ([self respondsToSelector:@selector(leftItemAction)]) {
        [self leftItemAction];
    }
    else {
        if (self.navigationController) {
            if (self.navigationController.viewControllers.count > 1) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        }
        else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)rightAction {
    if ([self respondsToSelector:@selector(rightItemAction)]) {
        [self rightItemAction];
    }
}

#pragma mark - Get

- (UIBarButtonItem *)barButtonItem:(UIView *)view {
    return [[UIBarButtonItem alloc] initWithCustomView:view];
}

- (UIBarButtonItem *)leftBarButtonItemWithTitle:(NSString *)leftItemTitle {
    return [[UIBarButtonItem alloc] initWithTitle:leftItemTitle style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
}

- (UIBarButtonItem *)leftBarButtonItemWithImage:(NSString *)leftItemImageName {
    return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:leftItemImageName] style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
}

- (UIBarButtonItem *)rightBarButtonItemWithTitle:(NSString *)rightItemTitle {
    return [[UIBarButtonItem alloc] initWithTitle:rightItemTitle style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
}

- (UIBarButtonItem *)rightBarButtonItemWithImage:(NSString *)rightItemImageName {
    return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:rightItemImageName] style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
}

- (UIButton *)leftBarButton {
    UIButton *button = [self barButton];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIButton *)rightBarButton {
    UIButton *button = [self barButton];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIButton *)barButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 88, 44);
    button.tintColor = self.navigationController.navigationBar.tintColor;
    button.titleLabel.font = [UIFont systemFontOfSize:18.f];
    return button;
}

@end
