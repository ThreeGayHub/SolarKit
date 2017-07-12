//
//  UIView+SLGesture.h
//  Pods
//
//  Created by wyh on 2017/7/12.
//
//

#import <UIKit/UIKit.h>

typedef void (^SLUIViewGestureBlock)();

@interface UIView (SLGesture)

- (void)sl_touchUp:(SLUIViewGestureBlock)block;

@end
