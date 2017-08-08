//
//  UITextField+SLBlock.m
//  Example
//
//  Created by wyh on 2017/8/8.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "UITextField+SLBlock.h"
#import <objc/runtime.h>

@interface UITextField (SLTextField_Private)

@property (nonatomic, strong) NSMutableDictionary *blockDict;

@end

@implementation UITextField (SLBlock)

- (void)editingDidBegin:(SLTextFieldAction)action {
    [self.blockDict setObject:action forKey:@(UIControlEventEditingDidBegin)];
    [self addTarget:self action:@selector(editingDidBeginAction:) forControlEvents:UIControlEventEditingDidBegin];
}

- (void)editingDidBeginAction:(UITextField *)textField {
    SLTextFieldAction block = self.blockDict[@(UIControlEventEditingDidBegin)];
    if (block) block(textField);
}

- (void)editingChanged:(SLTextFieldAction)action {
    [self.blockDict setObject:action forKey:@(UIControlEventEditingChanged)];
    [self addTarget:self action:@selector(editingChangedAction:) forControlEvents:UIControlEventEditingChanged];
}

- (void)editingChangedAction:(UITextField *)textField {
    SLTextFieldAction block = self.blockDict[@(UIControlEventEditingChanged)];
    if (block) block(textField);
}

- (void)editingDidEnd:(SLTextFieldAction)action {
    [self.blockDict setObject:action forKey:@(UIControlEventEditingDidEnd)];
    [self addTarget:self action:@selector(editingDidEndAction:) forControlEvents:UIControlEventEditingDidEnd];
}

- (void)editingDidEndAction:(UITextField *)textField {
    SLTextFieldAction block = self.blockDict[@(UIControlEventEditingDidEnd)];
    if (block) block(textField);
}

- (NSMutableDictionary *)blockDict {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, _cmd);
    if (dict) return dict;
    
    dict = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, @selector(blockDict), dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return dict;
}

@end
