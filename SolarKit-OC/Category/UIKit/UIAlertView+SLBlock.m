//
//  UIAlertView+SLBlock.m
//  Pods
//
//  Created by wyh on 2017/7/12.
//
//

#import "UIAlertView+SLBlock.h"
#import <objc/runtime.h>

@interface UIAlertView (SLBlock_Privete)

@property (nonatomic, strong) NSMutableDictionary *sl_blockDict;

@end

@implementation UIAlertView (SLBlock)

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message {
    return [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
}

- (void)addButton:(NSString *)title {
    [self addButtonWithTitle:title];
}

- (void)addButton:(NSString *)title action:(SLUIAlertViewBlock)action {
    self.delegate = self;
    NSInteger index = [self addButtonWithTitle:title];
    if (action) {
        [self.sl_blockDict setObject:action forKey:@(index)];
    }
}

- (NSMutableDictionary *)sl_blockDict {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, @selector(sl_blockDict));
    if (dict) return dict;
    
    dict = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, @selector(sl_blockDict), dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return dict;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([self.sl_blockDict.allKeys containsObject:@(buttonIndex)]) {
        SLUIAlertViewBlock block = self.sl_blockDict[@(buttonIndex)];
        block();
    }
}

@end
