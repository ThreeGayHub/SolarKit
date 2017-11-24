//
//  SLResponse.h
//  Example
//
//  Created by wyh on 2017/11/20.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SLTarget;
@class SLRequest;

@interface SLResponse : NSObject

+ (nullable instancetype)responseWithSessionDataTask:(nullable NSURLSessionDataTask *)dataTask
                                              target:(nullable SLTarget *)target
                                             request:(nullable SLRequest *)request
                                            response:(nullable NSURLResponse *)response
                                      responseObject:(nullable id)responseObject
                                               error:(nullable NSError *)error;

@property (nonatomic, weak, readonly, nullable) SLTarget *target;

@property (nonatomic, strong, readonly, nullable) SLRequest *request;



- (nullable instancetype)init UNAVAILABLE_ATTRIBUTE;
- (nullable instancetype)new UNAVAILABLE_ATTRIBUTE;

@end
