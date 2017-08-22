//
//  UIDevice+SLKit.m
//  Pods
//
//  Created by wyh on 2017/7/7.
//
//

#import "UIDevice+SLKit.h"
#import <sys/utsname.h>

@implementation UIDevice (SLKit)

+ (float)systemVersion {
    return [[[UIDevice currentDevice] systemVersion] floatValue];
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

// 获取设备名
+ (NSString *)deviceName {
    NSString *deviceName = self._modelId;
    
    if ([deviceName isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([deviceName isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceName isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceName isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceName isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceName isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceName isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceName isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceName isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceName isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceName isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceName isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceName isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceName isEqualToString:@"iPhone7,1"])    return @"iphone 6 Plus";
    if ([deviceName isEqualToString:@"iPhone7,2"])    return @"iphone 6";
    if ([deviceName isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceName isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceName isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceName isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceName isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    
    
    if ([deviceName isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceName isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceName isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceName isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceName isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([deviceName isEqualToString:@"iPod7,1"])      return @"iPod Touch 6G";
    
    
    if ([deviceName isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([deviceName isEqualToString:@"iPad2,1"])   return @"iPad 2";
    if ([deviceName isEqualToString:@"iPad2,2"])   return @"iPad 2";
    if ([deviceName isEqualToString:@"iPad2,3"])   return @"iPad 2";
    if ([deviceName isEqualToString:@"iPad2,4"])   return @"iPad 2";
    if ([deviceName isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    if ([deviceName isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    if ([deviceName isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([deviceName isEqualToString:@"iPad3,1"])   return @"iPad 3";
    if ([deviceName isEqualToString:@"iPad3,2"])   return @"iPad 3";
    if ([deviceName isEqualToString:@"iPad3,3"])   return @"iPad 3";
    if ([deviceName isEqualToString:@"iPad3,4"])   return @"iPad 4";
    if ([deviceName isEqualToString:@"iPad3,5"])   return @"iPad 4";
    if ([deviceName isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([deviceName isEqualToString:@"iPad4,1"])   return @"iPad Air";
    if ([deviceName isEqualToString:@"iPad4,2"])   return @"iPad Air";
    if ([deviceName isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([deviceName isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    if ([deviceName isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    if ([deviceName isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    if ([deviceName isEqualToString:@"iPad4,7"])   return @"iPad Mini 3G";
    if ([deviceName isEqualToString:@"iPad4,8"])   return @"iPad Mini 3G";
    if ([deviceName isEqualToString:@"iPad4,9"])   return @"iPad Mini 3G";
    if ([deviceName isEqualToString:@"iPad5,1"])   return @"iPad Mini 4G";
    if ([deviceName isEqualToString:@"iPad5,2"])   return @"iPad Mini 4G";
    if ([deviceName isEqualToString:@"iPad5,3"])   return @"iPad Air 2";
    if ([deviceName isEqualToString:@"iPad5,4"])   return @"iPad Air 2";
    if ([deviceName isEqualToString:@"iPad6,3"])   return @"iPad Pro (9.7 inch)";
    if ([deviceName isEqualToString:@"iPad6,4"])   return @"iPad Pro (9.7 inch)";
    if ([deviceName isEqualToString:@"iPad6,7"])   return @"iPad Pro (12.9 inch)";
    if ([deviceName isEqualToString:@"iPad6,8"])   return @"iPad Pro (12.9 inch)";
    
    if ([deviceName isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceName isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceName;
}

// 获取modelid
+ (NSString *)_modelId {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}


@end
