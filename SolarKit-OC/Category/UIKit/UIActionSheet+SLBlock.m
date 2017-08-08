//
//  UIActionSheet+SLBlock.m
//  Example
//
//  Created by wyh on 2017/8/7.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "UIActionSheet+SLBlock.h"
#import <objc/runtime.h>

@interface UIActionSheet (SLActionSheet_Private)

@property (nonatomic, strong) NSMutableDictionary *blockDict;

@end

@implementation UIActionSheet (SLBlock)

+ (instancetype)actionSheetWithTitle:(NSString *)title {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    actionSheet.delegate = actionSheet;
    return actionSheet;
}

- (void)addCancelButton:(NSString *)title {
    [self addCancelButton:title action:nil];
}

- (void)addCancelButton:(NSString *)title action:(SLActionSheetAction)action {
    NSInteger index = [self addButtonWithTitle:title];
    if (action) {
        [self.blockDict setObject:action forKey:@(index)];
    }
    self.cancelButtonIndex = index;
}

- (void)addDestructiveButton:(NSString *)title {
    [self addDestructiveButton:title action:nil];
}

- (void)addDestructiveButton:(NSString *)title action:(SLActionSheetAction)action {
    NSInteger index = [self addButtonWithTitle:title];
    if (action) {
        [self.blockDict setObject:action forKey:@(index)];
    }
    self.destructiveButtonIndex = index;
}

- (void)addButton:(NSString *)title {
    [self addButton:title action:nil];
}

- (void)addButton:(NSString *)title action:(SLActionSheetAction)action {
    NSInteger index = [self addButtonWithTitle:title];
    if (action) {
        [self.blockDict setObject:action forKey:@(index)];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([self.blockDict.allKeys containsObject:@(buttonIndex)]) {
        SLActionSheetAction block = self.blockDict[@(buttonIndex)];
        block();
    }
}

- (NSMutableDictionary *)blockDict {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, _cmd);
    if (dict) return dict;
    
    dict = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, @selector(blockDict), dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return dict;
}

@end
