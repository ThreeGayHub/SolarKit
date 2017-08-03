//
//  UIDevice+SLKit.m
//  Pods
//
//  Created by wyh on 2017/7/7.
//
//

#import "UIDevice+SLKit.h"

@implementation UIDevice (SLKit)

+ (NSString *)name {
    return [UIDevice currentDevice].name;
}

+ (NSString *)model {
    return [UIDevice currentDevice].model;
}

+ (NSString *)localizedModel {
    return [UIDevice currentDevice].localizedModel;
}

+ (NSString *)systemName {
    return [UIDevice currentDevice].systemName;
}

+ (float)systemVersion {
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (UIDeviceOrientation)orientation {
    return [UIDevice currentDevice].orientation;
}

+ (BOOL)isPad {
    static dispatch_once_t one;
    static BOOL pad;
    dispatch_once(&one, ^{
        pad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    });
    return pad;
}

+ (BOOL)isSimulator {
    return TARGET_OS_SIMULATOR;
}

@end
