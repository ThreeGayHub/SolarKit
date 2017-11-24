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

@property (nonatomic, strong) NSMutableDictionary *blockDict;

@end

@implementation UIView (SLGesture)

- (void)touchUp:(SLGestureBlock)block {
    [self.blockDict setObject:block forKey:@(UIGestureRecognizerStateEnded)];
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)touch:(UITapGestureRecognizer *)tapGesture {
    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        SLGestureBlock block = self.blockDict[@(UIGestureRecognizerStateEnded)];
        if (block) block();
    }
}

- (NSMutableDictionary *)blockDict {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, _cmd);
    if (dict) return dict;
    
    dict = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, _cmd, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return dict;
}

- (void)addTarget:(id)target action:(SEL)action {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tapGesture];
}

@end
