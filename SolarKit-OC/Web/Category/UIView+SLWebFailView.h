//
//  UIView+SLWebFailView.h
//  Example
//
//  Created by wyh on 2017/12/5.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SLWebFailViewClick)(void);

@interface SLWebFailView : UIView

@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, copy) NSString *text;

- (void)clickAction:(SLWebFailViewClick)click;

@end

@interface UIView (SLWebFailView)

@property (nonatomic, strong) SLWebFailView *failView;

- (void)addFailViewWithImageName:(NSString *)imageName text:(NSString *)text click:(SLWebFailViewClick)click;

- (void)removeFailView;

@end
