//
//  SLResponse.m
//  Example
//
//  Created by wyh on 2017/11/20.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "SLResponse.h"

@interface SLResponse ()


@end

@implementation SLResponse

+ (nullable instancetype)responseWithSessionDataTask:(nullable NSURLSessionDataTask *)dataTask
                                              target:(nullable SLTarget *)target
                                             request:(nullable SLRequest *)request
                                            response:(nullable NSURLResponse *)response
                                      responseObject:(nullable id)responseObject
                                               error:(nullable NSError *)error {
    return [[self alloc] initWithSessionDataTask:dataTask
                                          target:target
                                         request:request
                                        response:response
                                  responseObject:responseObject
                                           error:error];
}

- (instancetype)initWithSessionDataTask:(nullable NSURLSessionDataTask *)dataTask
                                 target:(nullable SLTarget *)target
                                request:(nullable SLRequest *)request
                               response:(nullable NSURLResponse *)response
                         responseObject:(nullable id)responseObject
                                  error:(nullable NSError *)error {
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end
