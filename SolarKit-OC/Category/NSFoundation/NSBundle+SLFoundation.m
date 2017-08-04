//
//  NSBundle+SLFoundation.m
//  Pods
//
//  Created by wyh on 2017/8/2.
//
//

#import "NSBundle+SLFoundation.h"

@implementation NSBundle (SLFoundation)

+ (NSString *)mainBundlePath {
    return [NSBundle mainBundle].bundlePath;
}

+ (instancetype)bundleWithName:(NSString *)bundleName {
    NSString *bundlePath = [[NSBundle bundleForClass:NSClassFromString(bundleName)] pathForResource:bundleName ofType:@"bundle"];
    return [NSBundle bundleWithPath:bundlePath];
}

+ (NSDictionary *)infoPlist {
    return [[NSBundle mainBundle] infoDictionary];
}

@end
