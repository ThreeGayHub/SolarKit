//
//  UIAlertView+SLBlock.h
//  Pods
//
//  Created by wyh on 2017/7/12.
//
//

#import <UIKit/UIKit.h>

typedef void(^SLUIAlertViewBlock)(void);

@interface UIAlertView (SLBlock) <UIAlertViewDelegate>

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message;

- (void)addButton:(NSString *)title;

- (void)addButton:(NSString *)title action:(SLUIAlertViewBlock)action;

@end
