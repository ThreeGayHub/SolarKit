//
//  YHNetworkConfig.h
//  YHNetworking
//
//  Created by wyh on 2017/2/24.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//macro
#if DEBUG
#define YHLog(format, ...) printf("\n[%s]\n--------------------- YHLog -------------------- \n%s\n------------------------------------------------\n", __TIME__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define YHLog(format, ...)
#endif

//block
typedef id _Nullable(^YHModelToPatameters)(id _Nullable model);
typedef id _Nullable(^YHParametersEncryption)(id _Nullable parameters);
typedef id _Nullable(^YHJSONSerialization)(id _Nullable response);
typedef id _Nullable(^YHResponseDecryption)(id _Nullable response);

typedef id _Nullable(^YHHTTPURLResponseHandle)(NSHTTPURLResponse * _Nullable httpURLResponse);
typedef void(^YHGlobalLoading)(BOOL isShowLoadingHUD);
typedef void(^YHGlobalEndLoad)(BOOL isDismissLoadingHUD);
typedef void(^YHGlobalSuccess)(BOOL isShowSuccessMsg, NSString * _Nullable message);
typedef void(^YHGlobalFail)(BOOL isShowFailMsg, NSInteger code, NSString * _Nullable message);

typedef void(^YHUploadGlobalComplete)(NSString * _Nullable identifier, id _Nullable response);
typedef void(^YHUploadGlobalFail)(NSString * _Nullable identifier, NSInteger code, NSString * _Nullable message);
typedef void(^YHUploadGlobalProgress)(NSString * _Nullable identifier, float progress);

typedef void(^YHDownloadGlobalComplete)(NSString * _Nullable identifier, id _Nullable response);
typedef void(^YHDownloadGlobalFail)(NSString * _Nullable identifier, NSInteger code, NSString * _Nullable message);
typedef void(^YHDownloadGlobalProgress)(NSString * _Nullable identifier, float progress);

typedef void(^YHManagerComplete)(id _Nullable response);
typedef void(^YHManagerFail)(NSInteger code, NSString * _Nullable message);
typedef void(^YHManagerProgress)(float progress);
//return what afnet return
typedef void(^YHManagerSuccess)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject);
typedef void(^YHManagerFailure)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);

//enum
typedef NS_ENUM(NSUInteger, YHRequestMethod) {
    YHRequestMethodPOST = 0,
    YHRequestMethodGET,
    YHRequestMethodPUT,
    YHRequestMethodDELETE,
    YHRequestMethodHEAD,
    YHRequestMethodPATCH,
};

//const
extern NSString * _Nonnull const YHNetworkingKey;

@interface YHNetworkConfig : NSObject

+ (nullable instancetype)shared;

@property (nonatomic, copy, nullable) NSString *baseUrlString;

- (void)responseStatusKey:(nullable NSString *)statusKey statusSuccess:(NSInteger)statusSuccess messageKey:(nullable NSString *)messageKey bodyKey:(nullable NSString *)bodyKey;

- (void)modelToPatameters:(nullable YHModelToPatameters)modelToPatameters;

- (void)globalLoading:(nullable YHGlobalLoading)globalLoading;

- (void)globalEndLoad:(nullable YHGlobalEndLoad)globalEndLoad;

- (void)globalSuccess:(nullable YHGlobalSuccess)globalSuccess;

- (void)globalFail:(nullable YHGlobalFail)globalFail;


@property (nonatomic, strong, nullable) NSURLSessionConfiguration *sessionConfiguration;
@property (nonatomic, assign) YHRequestMethod requestMethod;
@property (nonatomic, copy, nullable) NSDictionary *headerField;
@property (nonatomic, copy, nullable) NSString *fileName;
@property (nonatomic, copy, nullable) NSString *mimeType;


- (void)parametersEncryption:(nullable YHParametersEncryption)parametersEncryption;
- (void)jsonSerialization:(nullable YHJSONSerialization)jsonSerialization;
- (void)responseDecryption:(nullable YHResponseDecryption)responseDecryption;

- (void)httpURLResponseHandle:(nullable YHHTTPURLResponseHandle)httpURLResponseHandle;




@property (nonatomic, readonly, nullable) NSString *responseStatusKey;
@property (nonatomic, readonly) NSInteger responseStatusSuccess;
@property (nonatomic, readonly, nullable) NSString *responseMessageKey;
@property (nonatomic, readonly, nullable) NSString *responseBodyKey;

@property (nonatomic, readonly, nullable) YHModelToPatameters modelToPatameters;
@property (nonatomic, readonly, nullable) YHParametersEncryption parametersEncryption;
@property (nonatomic, readonly, nullable) YHJSONSerialization jsonSerialization;
@property (nonatomic, readonly, nullable) YHResponseDecryption responseDecryption;
@property (nonatomic, readonly, nullable) YHHTTPURLResponseHandle httpURLResponseHandle;
@property (nonatomic, readonly, nullable) YHGlobalLoading globalLoading;
@property (nonatomic, readonly, nullable) YHGlobalEndLoad globalEndLoad;
@property (nonatomic, readonly, nullable) YHGlobalSuccess globalSuccess;
@property (nonatomic, readonly, nullable) YHGlobalFail globalFail;

@end
