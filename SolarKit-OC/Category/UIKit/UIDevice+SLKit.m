//
//  UIDevice+SLKit.m
//  Pods
//
//  Created by wyh on 2017/7/7.
//
//

#import "UIDevice+SLKit.h"
#include <sys/sysctl.h>

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

- (BOOL)isPad {
    static dispatch_once_t one;
    static BOOL pad;
    dispatch_once(&one, ^{
        pad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    });
    return pad;
}

- (BOOL)isSimulator {
    static dispatch_once_t one;
    static BOOL simu = NO;
    dispatch_once(&one, ^{
        NSString *model = [self machineModel];
        if ([model isEqualToString:@"x86_64"] || [model isEqualToString:@"i386"]) {
            simu = YES;
        }
    });
    return simu;
}

- (NSString *)machineModel {
    static dispatch_once_t one;
    static NSString *model;
    dispatch_once(&one, ^{
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        model = [NSString stringWithUTF8String:machine];
        free(machine);
    });
    return model;
}

@end
