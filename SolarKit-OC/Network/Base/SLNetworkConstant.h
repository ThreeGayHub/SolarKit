//
//  SLNetworkConstant.h
//  Example
//
//  Created by wyh on 2017/10/26.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

#if DEBUG
#define SLNLog(format, ...) printf("\n[%s]\n------------------- SLNetwork ------------------ \n%s\n------------------------------------------------\n", __TIME__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define SLNLog(format, ...)
#endif

extern NSString * _Nonnull const SLNetworkDefaultManagerKey;
extern const char * _Nonnull SLNetworkDefaultCompletionQueueKey;
extern const char * _Nonnull SLNetworkCustomCompletionQueueKey;

typedef void(^SLManagerReachability)(AFNetworkReachabilityStatus status);
typedef void(^SLManagerComplete)(id _Nullable response);
typedef void(^SLManagerFail)(NSInteger code, NSString * _Nullable message);
typedef void(^SLManagerProgress)(float progress);
//return what afnet return
typedef void(^SLManagerSuccess)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject);
typedef void(^SLManagerFailure)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);

typedef NS_ENUM(NSUInteger, SLHTTPMethod) {
    SLHTTPMethodNONE = 0,
    SLHTTPMethodPOST,
    SLHTTPMethodGET,
    SLHTTPMethodPUT,
    SLHTTPMethodDELETE,
    SLHTTPMethodHEAD,
    SLHTTPMethodPATCH,
};

NSDictionary * _Nonnull SLHTTPMethodDictionary();

@interface SLNetworkConstant : NSObject

@end
