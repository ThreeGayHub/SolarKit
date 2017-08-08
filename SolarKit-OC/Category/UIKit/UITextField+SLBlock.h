//
//  UITextField+SLBlock.h
//  Example
//
//  Created by wyh on 2017/8/8.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SLTextFieldAction)(UITextField *textField);

@interface UITextField (SLBlock)

- (void)editingDidBegin:(SLTextFieldAction)action;

- (void)editingChanged:(SLTextFieldAction)action;

- (void)editingDidEnd:(SLTextFieldAction)action;

@end
