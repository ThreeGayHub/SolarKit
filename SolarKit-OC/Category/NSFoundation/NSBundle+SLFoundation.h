//
//  NSBundle+SLFoundation.h
//  Pods
//
//  Created by wyh on 2017/8/2.
//
//

#import <Foundation/Foundation.h>

@interface NSBundle (SLFoundation)

+ (NSString *)mainBundlePath;

+ (instancetype)bundleWithName:(NSString *)bundleName;

@end
