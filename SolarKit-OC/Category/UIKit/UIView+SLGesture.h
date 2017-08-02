//
//  UIView+SLGesture.h
//  Pods
//
//  Created by wyh on 2017/7/12.
//
//

#import <UIKit/UIKit.h>

typedef void (^SLGestureEmptyBlock)(void);

@interface UIView (SLGesture)

- (void)touchUp:(SLGestureEmptyBlock)block;

@end
