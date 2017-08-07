//
//  UIActionSheet+SLBlock.h
//  Example
//
//  Created by wyh on 2017/8/7.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SLActionSheetBlock)(void);

@interface UIActionSheet (SLBlock) <UIActionSheetDelegate>

+ (instancetype)actionSheetWithTitle:(NSString *)title;

- (void)addCancelButton:(NSString *)title;

- (void)addCancelButton:(NSString *)title action:(SLActionSheetBlock)action;

- (void)addDestructiveButton:(NSString *)title;

- (void)addDestructiveButton:(NSString *)title action:(SLActionSheetBlock)action;

- (void)addButton:(NSString *)title;

- (void)addButton:(NSString *)title action:(SLActionSheetBlock)action;

@end
