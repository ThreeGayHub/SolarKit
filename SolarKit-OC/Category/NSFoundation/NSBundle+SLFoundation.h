//
//  NSBundle+SLFoundation.h
//  Pods
//
//  Created by wyh on 2017/8/2.
//
//

#import <Foundation/Foundation.h>

#ifndef InfoPlist
#define InfoPlist   [NSBundle infoPlist]
#endif

#ifndef MainBundle
#define MainBundle  [NSBundle mainBundle]
#endif

@interface NSBundle (SLFoundation)

+ (NSString *)mainBundlePath;

+ (instancetype)bundleWithName:(NSString *)bundleName;

+ (NSDictionary *)infoPlist;

@end
