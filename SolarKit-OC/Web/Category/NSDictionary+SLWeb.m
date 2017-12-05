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

- (NSString *)jsonString {
    return [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
}

- (id)itemForKey:(id)key {
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSArray class]]) {
        return [obj count] > 0 ? [obj objectAtIndex:0] : nil;
    } else {
        return obj;
    }
}

- (NSArray *)allItemsForKey:(id)key {
    id obj = [self objectForKey:key];
    return [obj isKindOfClass:[NSArray class]] ? obj : (obj ? [NSArray arrayWithObject:obj] : nil);
}

@end

@implementation NSMutableDictionary (SLWeb)

- (void)addItem:(id)item forKey:(id<NSCopying>)aKey {
    if (item == nil) {
        return;
    }
    id obj = [self objectForKey:aKey];
    NSMutableArray *array = nil;
    if ([obj isKindOfClass:[NSArray class]]) {
        array = [NSMutableArray arrayWithArray:obj];
    } else {
        array = obj ? [NSMutableArray arrayWithObject:obj] : [NSMutableArray array];
    }
    [array addObject:item];
    [self setObject:[array copy] forKey:aKey];
}

@end
