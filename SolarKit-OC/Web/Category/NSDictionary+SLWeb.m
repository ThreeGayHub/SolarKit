//
//  NSDictionary+SLWeb.m
//  Example
//
//  Created by wyh on 2017/11/29.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "NSDictionary+SLWeb.h"

@implementation NSDictionary (SLWeb)

- (NSData *)data {
    return [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
}

@end
