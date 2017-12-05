//
//  SLRequestInterceptor.h
//  Rexxar
//
//  Created by bigyelow on 09/03/2017.
//  Copyright © 2017 Douban.Inc. All rights reserved.
//

#import "SLURLProtocol.h"
#import "SLDecorator.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * `SLRequestInterceptor` 是一个 Rexxar-Container 的请求侦听器。
 * 这个侦听器用于修改请求，比如增添请求的 url 参数，添加自定义的 http header。
 *
 */
@interface SLRequestInterceptor : SLURLProtocol

@property (class, nonatomic, readonly, nullable) NSMutableArray<id<SLDecorator>> *decorators;

+ (void)addDecorators:(id <SLDecorator>)decorator, ...;

@end

NS_ASSUME_NONNULL_END
