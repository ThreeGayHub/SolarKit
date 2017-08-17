//
//  UIViewController+SLNavigationItem.h
//  Example
//
//  Created by wyh on 2017/8/17.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SLNavigationItemDelegate <NSObject>

@optional

- (void)leftItemAction;

- (void)rightItemAction;

@end

@interface UIViewController (SLNavigationItem) <SLNavigationItemDelegate>

- (void)setLeftItemWithImage:(NSString *)leftItemImageName;

- (void)setLeftItemWithTitle:(NSString *)leftItemTitle;

- (void)setLeftItemWithImage:(NSString *)leftItemImageName title:(NSString *)leftItemTitle;

- (void)setLeftItemWithBarButtonSystemItem:(UIBarButtonSystemItem)barButtonSystemItem;

- (void)setLeftItemWithView:(UIView *)leftView;


- (void)setRightItemWithImage:(NSString *)rightItemImageName;

- (void)setRightItemWithTitle:(NSString *)rightItemTitle;

- (void)setRightItemWithImage:(NSString *)rightItemImageName title:(NSString *)rightItemTitle;

- (void)setRightItemWithBarButtonSystemItem:(UIBarButtonSystemItem)barButtonSystemItem;

- (void)setRightItemWithView:(UIView *)rightView;

@end
