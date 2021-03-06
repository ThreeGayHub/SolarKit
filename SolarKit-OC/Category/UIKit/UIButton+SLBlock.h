//
//  UIButton+SLBlock.h
//  Example
//
//  Created by wyh on 2017/8/8.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SLButtonAction)(UIButton *button);

@interface UIButton (SLBlock)

- (void)touchUpInside:(SLButtonAction)action;

@end
