//
//  YHResponse.h
//  Neptune
//
//  Created by wyh on 2016/11/8.
//  Copyright © 2016年 NEO Capital. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHNetworkConfig.h"

@class YHRequest;

@interface YHResponse : NSObject

+ (BOOL)responseSerializationError:(nullable NSError *)serializationError failure:(nullable YHManagerFailure)failure;

+ (void)responseWithTask:(nullable NSURLSessionDataTask *)dataTask request:(nullable YHRequest *)request complete:(nullable YHManagerComplete)complete fail:(nullable YHManagerFail)fail success:(nullable YHManagerSuccess)success failure:(nullable YHManagerFailure)failure response:(nullable NSURLResponse *)response responseObject:(nullable id)responseObject error:(nullable NSError *)error;

@end
