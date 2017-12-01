//
//  SLResponse.h
//  Example
//
//  Created by wyh on 2017/11/20.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLNetworkConstant.h"
#import "SLPlugin.h"
@class SLTarget;
@class SLRequest;

@interface SLResponse : NSObject


+ (nullable instancetype)responseWithSessionDataTask:(nullable NSURLSessionDataTask *)dataTask
                                              target:(nullable SLTarget *)target
                                             plugins:(nullable NSMutableArray<id<SLPlugin>> *)plugins
                                             request:(nullable SLRequest *)request
                                            response:(nullable NSURLResponse *)response
                                      responseObject:(nullable id)responseObject
                                               error:(nullable NSError *)error;

@property (nonatomic, strong, readonly, nullable) NSURLSessionDataTask *dataTask;

@property (nonatomic, weak, readonly, nullable) SLTarget *target;

@property (nonatomic, weak, readonly, nullable) NSMutableArray<id<SLPlugin>> * plugins;

@property (nonatomic, strong, readonly, nullable) SLRequest *request;

@property (nonatomic, strong, nullable) NSURLResponse *response;

@property (nonatomic, strong, nullable) id responseObject;

@property (nonatomic, strong, nullable) NSError *error;

- (void)dealResponseSuccess:(nullable SLManagerSuccess)success failure:(nullable SLManagerFailure)failure;
- (void)dealResponseComplete:(nullable SLManagerComplete)complete fail:(nullable SLManagerFail)fail;


- (nullable instancetype)init UNAVAILABLE_ATTRIBUTE;
- (nullable instancetype)new UNAVAILABLE_ATTRIBUTE;

@end
