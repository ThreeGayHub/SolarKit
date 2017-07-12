//
//  UIDevice+SLKit.m
//  Pods
//
//  Created by wyh on 2017/7/7.
//
//

#import "UIDevice+SLKit.h"

@implementation UIDevice (SLKit)

+ (NSString *)sl_name {
    return [UIDevice currentDevice].name;
}

+ (NSString *)sl_model {
    return [UIDevice currentDevice].model;
}

+ (NSString *)sl_localizedModel {
    return [UIDevice currentDevice].localizedModel;
}

+ (NSString *)sl_systemName {
    return [UIDevice currentDevice].systemName;
}

+ (float)sl_systemVersion {
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (UIDeviceOrientation)sl_orientation {
    return [UIDevice currentDevice].orientation;
}

@end
