//
//  UIAlertView+SLBlock.m
//  Pods
//
//  Created by wyh on 2017/7/12.
//
//

#import "UIAlertView+SLBlock.h"
#import <objc/runtime.h>

@interface UIAlertView (SLAlertView_Privete)

@property (nonatomic, strong) NSMutableDictionary *blockDict;

@end

@implementation UIAlertView (SLBlock)

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    alertView.delegate = alertView;
    return alertView;
}

- (void)addButton:(NSString *)title {
    [self addButtonWithTitle:title];
}

- (void)addButton:(NSString *)title action:(SLAlertViewAction)action {
    NSInteger index = [self addButtonWithTitle:title];
    if (action) {
        [self.blockDict setObject:action forKey:@(index)];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([self.blockDict.allKeys containsObject:@(buttonIndex)]) {
        SLAlertViewAction block = self.blockDict[@(buttonIndex)];
        block();
    }
}

- (NSMutableDictionary *)blockDict {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, _cmd);
    if (dict) return dict;
    
    dict = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, @selector(blockDict), dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return dict;
}

@end
