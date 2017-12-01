//
//  NSBundle+SLWeb.h
//  Example
//
//  Created by wyh on 2017/11/30.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSBundle (SLWeb)

+ (NSString *)bundlePathWithName:(NSString *)name;

+ (instancetype)bundleWithName:(NSString *)name;

- (NSString *)pathForImage:(NSString *)imageName inDirectory:(NSString *)directory;

@end
