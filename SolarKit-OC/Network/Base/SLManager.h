//
//  SLManager.h
//  Example
//
//  Created by wyh on 2017/10/18.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "SLNetworkConstant.h"
#import "SLPlugin.h"

@class SLTarget;
@class SLRequest;

@interface SLManager : AFHTTPSessionManager

+ (void)setDefaultManager:(nullable SLTarget *)target;

+ (nullable instancetype)defaultManager;

+ (nullable instancetype)customManager:(nullable SLTarget *)target;

- (void)addPlugin:(nullable id <SLPlugin>)plugin, ... NS_REQUIRES_NIL_TERMINATION;

/**
 *  send
 */
- (nullable NSURLSessionDataTask *)send:(nullable SLRequest *)request;
- (nullable NSURLSessionDataTask *)send:(nullable SLRequest *)request complete:(nullable SLManagerComplete)complete;
- (nullable NSURLSessionDataTask *)send:(nullable SLRequest *)request complete:(nullable SLManagerComplete)complete fail:(nullable SLManagerFail)fail;
//original response
- (nullable NSURLSessionDataTask *)send:(nullable SLRequest *)request success:(nullable SLManagerSuccess)success;
- (nullable NSURLSessionDataTask *)send:(nullable SLRequest *)request success:(nullable SLManagerSuccess)success failure:(nullable SLManagerFailure)failure;

/**
 Reachability
 
 Please Observe it
 */
@property (nonatomic, assign) AFNetworkReachabilityStatus reachabilityStatus;

/**
 Reachability
 
 or use change block
 */
- (void)reachabilityChange:(nullable SLManagerReachability)change;


- (nullable instancetype)init UNAVAILABLE_ATTRIBUTE;
- (nullable instancetype)new UNAVAILABLE_ATTRIBUTE;

@end
