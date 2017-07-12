//
//  UIView+SLGesture.m
//  Pods
//
//  Created by wyh on 2017/7/12.
//
//

#import "UIView+SLGesture.h"
#import <objc/runtime.h>

@interface UIView (SLGesture_Private)

@property (nonatomic, copy) SLUIViewGestureBlock sl_block;

@end

@implementation UIView (SLGesture)

static char kSLTouchUpBlockKey;

- (void)sl_touchUp:(SLUIViewGestureBlock)block {
    self.sl_block = block;
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTap:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)setSl_block:(SLUIViewGestureBlock)sl_block {
    objc_setAssociatedObject(self, @selector(sl_block), sl_block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (SLUIViewGestureBlock)sl_block {
    return objc_getAssociatedObject(self, @selector(sl_block));
}

- (void)selfTap:(UITapGestureRecognizer *)tapGesture {
    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        if (self.sl_block) self.sl_block();
    }
}

@end
