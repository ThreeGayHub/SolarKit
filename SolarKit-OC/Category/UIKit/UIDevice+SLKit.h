//
//  UIDevice+SLKit.h
//  Pods
//
//  Created by wyh on 2017/7/7.
//
//

#import <UIKit/UIKit.h>

#ifndef iOSX
#define iOSX    UIDevice.systemVersion
#endif

@interface UIDevice (SLKit)

+ (float)systemVersion;

// Whether the device is iPad/iPad mini.
+ (BOOL)isPad;

// Whether the device is a simulator.
+ (BOOL)isSimulator;

+ (NSString *)deviceName;

@end
