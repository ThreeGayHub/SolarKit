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

@property (class, nonatomic, strong, readonly) NSString *name;

@property (class, nonatomic, strong, readonly) NSString *model;

@property (class, nonatomic, strong, readonly) NSString *localizedModel;

@property (class, nonatomic, strong, readonly) NSString *systemName;

@property (class, nonatomic, assign, readonly) float systemVersion;

@property (class, nonatomic, assign, readonly) UIDeviceOrientation orientation;

// Whether the device is iPad/iPad mini.
@property (nonatomic, readonly) BOOL isPad;

// Whether the device is a simulator.
@property (nonatomic, readonly) BOOL isSimulator;

@end
