//
//  UIButton+SLBlock.m
//  Example
//
//  Created by wyh on 2017/8/8.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "UIButton+SLBlock.h"
#import <objc/runtime.h>

@interface UIButton (SLButton_Private)

@property (nonatomic, strong) NSMutableDictionary *blockDict;

@end

@implementation UIButton (SLBlock)

- (void)touchUpInside:(SLButtonAction)action {
    [self.blockDict setObject:action forKey:@(UIControlEventTouchUpInside)];
    [self addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)touchUpInsideAction:(UIButton *)button {
    SLButtonAction block = self.blockDict[@(UIControlEventTouchUpInside)];
    if (block) block(button);
}


- (NSMutableDictionary *)blockDict {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, _cmd);
    if (dict) return dict;
    
    dict = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, @selector(blockDict), dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return dict;
}

@end
