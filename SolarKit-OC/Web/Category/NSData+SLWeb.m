//
//  NSData+SLWeb.m
//  Example
//
//  Created by wyh on 2017/12/4.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "NSData+SLWeb.h"

@implementation NSData (SLWeb)

- (NSString *)string {
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

- (NSDictionary *)dictionary {
    return [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:nil];
}

@end
