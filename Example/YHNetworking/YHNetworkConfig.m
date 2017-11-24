//
//  YHNetworkConfig.m
//  YHNetworking
//
//  Created by wyh on 2017/2/24.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import "YHNetworkConfig.h"

NSString * const YHNetworkingKey = @"YHNetworking";

@interface YHNetworkConfig ()

@property (nonatomic, copy) NSString *responseStatusKey;
@property (nonatomic, assign) NSInteger responseStatusSuccess;
@property (nonatomic, copy) NSString *responseMessageKey;
@property (nonatomic, copy) NSString *responseBodyKey;

@property (nonatomic, copy) YHModelToPatameters modelToPatameters;
@property (nonatomic, copy) YHParametersEncryption parametersEncryption;
@property (nonatomic, copy) YHJSONSerialization jsonSerialization;
@property (nonatomic, copy) YHResponseDecryption responseDecryption;
@property (nonatomic, copy) YHHTTPURLResponseHandle httpURLResponseHandle;
@property (nonatomic, copy) YHGlobalLoading globalLoading;
@property (nonatomic, copy) YHGlobalEndLoad globalEndLoad;
@property (nonatomic, copy) YHGlobalSuccess globalSuccess;
@property (nonatomic, copy) YHGlobalFail globalFail;

@end

@implementation YHNetworkConfig

+ (instancetype)shared {
    static YHNetworkConfig *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (void)responseStatusKey:(NSString *)statusKey statusSuccess:(NSInteger)statusSuccess messageKey:(NSString *)messageKey bodyKey:(NSString *)bodyKey {
    _responseStatusKey = statusKey;
    _responseStatusSuccess = statusSuccess;
    _responseMessageKey = messageKey;
    _responseBodyKey = bodyKey;
}

- (void)modelToPatameters:(YHModelToPatameters)modelToPatameters {
    _modelToPatameters = modelToPatameters;
}

- (void)parametersEncryption:(YHParametersEncryption)parametersEncryption {
    _parametersEncryption = parametersEncryption;
}

- (void)jsonSerialization:(YHJSONSerialization)jsonSerialization {
    _jsonSerialization = jsonSerialization;
}

- (void)responseDecryption:(YHResponseDecryption)responseDecryption {
    _responseDecryption = responseDecryption;
}

- (void)httpURLResponseHandle:(YHHTTPURLResponseHandle)httpURLResponseHandle {
    _httpURLResponseHandle = httpURLResponseHandle;
}

- (void)globalLoading:(YHGlobalLoading)globalLoading {
    _globalLoading = globalLoading;
}

- (void)globalEndLoad:(YHGlobalEndLoad)globalEndLoad {
    _globalEndLoad = globalEndLoad;
}

- (void)globalSuccess:(YHGlobalSuccess)globalSuccess {
    _globalSuccess = globalSuccess;
}

- (void)globalFail:(YHGlobalFail)globalFail {
    _globalFail = globalFail;
}

@end
