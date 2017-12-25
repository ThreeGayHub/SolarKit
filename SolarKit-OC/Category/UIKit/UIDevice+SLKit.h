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

@property (class, nonatomic, readonly) float systemVersion;

// Whether the device is iPad/iPad mini.
@property (class, nonatomic, readonly) BOOL isPad;

// Whether the device is a simulator.
@property (class, nonatomic, readonly) BOOL isSimulator;

@property (class, nonatomic, readonly) NSString *deviceName;

@end
