//
//  SLTarget.h
//  Example
//
//  Created by wyh on 2017/11/23.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SLNetworkConstant.h"

@interface SLTarget : NSObject

+ (nullable instancetype)targetWithBaseURLString:(nullable NSString *)baseURLString;

@property (nonatomic, readonly, nullable) NSString *baseURLString;

@property (nonatomic, strong, nullable) NSURLSessionConfiguration *configuration;

@property (nonatomic, copy, nullable) NSDictionary *headerField;

@property (nonatomic, assign) SLHTTPMethod httpMethod;

@property (nonatomic, readonly, nullable) NSString *statusCodeKey;

@property (nonatomic, readonly) NSInteger successStatusCode;

@property (nonatomic, readonly, nullable) NSString *messageKey;

@property (nonatomic, readonly, nullable) NSString *responseDataKey;

/**
 Set the format of response
 
 e.g.:
 {
 "code" : 200,
 "message" : "login Success",
 "data" : {
 "userId" : "0001",
 "userName" : "Simon"
 }
 }
 
 {
 "code" : -1,
 "message" : "Wrong password",
 "data" : null
 }

 As above, we can set
 [statusCodeKey: code]
 [successStatusCode: 200]
 [messageKey: message]
 [responseDataKey: data]
 */
- (void)setStatusCodeKey:(nullable NSString *)statusCodeKey
       successStatusCode:(NSInteger)successStatusCode
              messageKey:(nullable NSString *)messageKey
         responseDataKey:(nullable NSString *)responseDataKey;

- (nullable instancetype)init UNAVAILABLE_ATTRIBUTE;
- (nullable instancetype)new UNAVAILABLE_ATTRIBUTE;

@end
