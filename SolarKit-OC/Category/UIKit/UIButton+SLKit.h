//
//  UIButton+SLKit.h
//  Example
//
//  Created by wyh on 2017/8/10.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (SLKit)

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) CGFloat fontSize;

@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSAttributedString *attributedTitle;

@end
