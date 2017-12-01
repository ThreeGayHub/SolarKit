//
//  NSBundle+SLWeb.m
//  Example
//
//  Created by wyh on 2017/11/30.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "NSBundle+SLWeb.h"

@implementation NSBundle (SLWeb)

+ (NSString *)bundlePathWithName:(NSString *)name {
    return [[NSBundle bundleForClass:NSClassFromString(name)] pathForResource:name ofType:@"bundle"];
}

+ (instancetype)bundleWithName:(NSString *)name {
    NSString *bundlePath = [self bundlePathWithName:name];
    return [NSBundle bundleWithPath:bundlePath];
}

- (NSString *)pathForImage:(NSString *)imageName inDirectory:(NSString *)directory {
    return [self pathForResource:[NSString stringWithFormat:@"%@@%ldx", imageName, (long)[UIScreen mainScreen].scale] ofType:@"png" inDirectory:directory];
}

@end
