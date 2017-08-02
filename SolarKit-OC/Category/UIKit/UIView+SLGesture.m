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

@property (nonatomic, copy) SLGestureEmptyBlock emptyBlock;

@end

@implementation UIView (SLGesture)

- (void)touchUp:(SLGestureEmptyBlock)block {
    self.emptyBlock = block;
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTap:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)setEmptyBlock:(SLGestureEmptyBlock)emptyBlock {
    objc_setAssociatedObject(self, @selector(emptyBlock), emptyBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (SLGestureEmptyBlock)emptyBlock {
    return objc_getAssociatedObject(self, @selector(emptyBlock));
}

- (void)selfTap:(UITapGestureRecognizer *)tapGesture {
    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        if (self.emptyBlock) self.emptyBlock();
    }
}

@end
