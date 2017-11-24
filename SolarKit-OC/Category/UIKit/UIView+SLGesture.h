//
//  UIView+SLGesture.h
//  Pods
//
//  Created by wyh on 2017/7/12.
//
//

#import <UIKit/UIKit.h>

typedef void (^SLGestureBlock)(void);

@interface UIView (SLGesture)

- (void)touchUp:(SLGestureBlock)block;

- (void)addTarget:(id)target action:(SEL)action;

@end
