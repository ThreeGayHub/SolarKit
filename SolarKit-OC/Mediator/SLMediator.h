//
//  SLMediator.h
//  Example
//
//  Created by wyh on 2017/9/25.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLMediator : NSObject

+ (instancetype)shared;

/**
 Remote Call Method

 @param url scheme://[target]/[action]?[parameters]
 @param completion completion
 */

/**
 Remote Call Method
 
 @param url scheme://[target]/[action]?[parameters]
 @param completion completion
 @return obj
 */
- (id)call:(NSURL *)url completion:(void (^)(NSDictionary *response))completion;

/**
 Native Call Method

 @param path [target]/[action]
 @param parameters parameters
 @param completion completion
 @return obj
 */
- (id)call:(NSString *)path parameters:(NSDictionary *)parameters completion:(void (^)(NSDictionary *response))completion;

- (void)removeCacheWithUrl:(NSURL *)url;

- (void)removeCacheWithPath:(NSString *)path;

@end
