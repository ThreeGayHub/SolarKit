//
//  NSString+SLWeb.m
//  Example
//
//  Created by wyh on 2017/11/29.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "NSString+SLWeb.h"

@implementation NSString (SLWeb)

- (BOOL)isHTTP {
    return [self hasPrefix:@"https"] || [self hasPrefix:@"http"] || [self isEqualToString:@"https"] || [self isEqualToString:@"http"];
}

@end
