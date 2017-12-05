//
//  SLURLProtocol.h
//  Rexxar
//
//  Created by GUO Lin on 5/17/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SLURLSessionDemux;

@interface SLURLProtocol : NSURLProtocol <NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSessionTask *dataTask;
@property (nonatomic, copy) NSArray *modes;

#pragma mark - Public methods, do not override

/**
 * 将该请求标记为可以忽略
 *
 */
+ (void)markRequestAsIgnored:(NSMutableURLRequest *)request;

/**
 * 清除该请求 `可忽略` 标识
 *
 */
+ (void)unmarkRequestAsIgnored:(NSMutableURLRequest *)request;

/**
 * 判断该请求是否是被忽略的
 *
 */
+ (BOOL)isRequestIgnored:(NSURLRequest *)request;

/**
 @param clazz a subclass of `SLURLProtocol`
 */
+ (BOOL)registerSLProtocolClass:(Class)clazz;

/**
 @param clazz a subclass of `SLURLProtocol`
 */
+ (void)unregisterSLProtocolClass:(Class)clazz;


/**
 实现 URLSession 共享和 URLProtocol client 回调的分发

 @return 共享的复用解析器
 */
+ (SLURLSessionDemux *)sharedDemux;

@end
