//
//  SLHUDWidget.m
//  Example
//
//  Created by wyh on 2017/12/6.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "SLHUDWidget.h"

typedef NS_ENUM(NSUInteger, SLHUDShowType) {
    SLHUDShowTypeWait = 0,
    SLHUDShowTypeDismiss,
    SLHUDShowTypeInfo,
    SLHUDShowTypeSuccess,
    SLHUDShowTypeError,
    SLHUDShowTypeFatal,
};

@implementation SLHUDWidget

- (void)performWithURL:(NSURL *)URL inController:(SLWebViewController *)controller {
    [super performWithURL:URL inController:controller];
    
    NSString *level = URL.queryDictionary[@"level"];
    NSString *message = URL.queryDictionary[@"message"];
    
    
}

- (SLHUDShowType)hudShowTypeWithLevel:(NSString *)level {
    
    NSDictionary *hudShowTypeDict = @{
                                      @"wait"       : @(SLHUDShowTypeWait),
                                      @"dismiss"    : @(SLHUDShowTypeDismiss),
                                      @"info"       : @(SLHUDShowTypeInfo),
                                      @"success"    : @(SLHUDShowTypeSuccess),
                                      @"error"      : @(SLHUDShowTypeError),
                                      @"fatal"      : @(SLHUDShowTypeFatal),
                                      };
    return [hudShowTypeDict[level] unsignedIntegerValue];
}

@end
