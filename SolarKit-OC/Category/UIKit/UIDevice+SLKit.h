//
//  UIDevice+SLKit.h
//  Pods
//
//  Created by wyh on 2017/7/7.
//
//

#import <UIKit/UIKit.h>

#ifndef iOSX
#define iOSX    UIDevice.sl_systemVersion
#endif

@interface UIDevice (SLKit)

@property (class, nonatomic, strong, readonly) NSString *sl_name;

@property (class, nonatomic, strong, readonly) NSString *sl_model;

@property (class, nonatomic, strong, readonly) NSString *sl_localizedModel;

@property (class, nonatomic, strong, readonly) NSString *sl_systemName;

@property (class, nonatomic, assign, readonly) float sl_systemVersion;

@property (class, nonatomic, assign, readonly) UIDeviceOrientation sl_orientation;

@end
