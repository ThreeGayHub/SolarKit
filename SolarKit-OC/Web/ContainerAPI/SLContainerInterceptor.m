//
//  SLContainerInterceptor.m
//  Rexxar
//
//  Created by GUO Lin on 5/17/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

#import "SLContainerInterceptor.h"
#import "NSHTTPURLResponse+Rexxar.h"
#import "SLContainerAPI.h"

static NSMutableDictionary<NSString *, SLContainerAPI *> *_containerAPIDictionary;

@implementation SLContainerInterceptor

+ (void)addContainerAPIs:(SLContainerAPI *)containerAPI, ... {
    va_list args;
    va_start(args, containerAPI);
    if (containerAPI) {
        [self addContainerAPI:containerAPI];
        SLContainerAPI * nextContainerAPI;
        while ((nextContainerAPI = va_arg(args, SLContainerAPI *))) {
            [self addContainerAPI:nextContainerAPI];
        }
    }
    va_end(args);
}

+ (void)addContainerAPI:(SLContainerAPI *)containerAPI {
    if (![SLContainerInterceptor.containerAPIDictionary.allKeys containsObject:containerAPI.path]) {
        [SLContainerInterceptor.containerAPIDictionary setObject:containerAPI forKey:containerAPI.path];
    }
}

+ (NSMutableDictionary<NSString *,SLContainerAPI *> *)containerAPIDictionary {
    if (_containerAPIDictionary) return _containerAPIDictionary;
    
    _containerAPIDictionary = [NSMutableDictionary dictionaryWithCapacity:50];
    return _containerAPIDictionary;
}

#pragma mark - Implement NSURLProtocol methods

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    // 请求不是来自浏览器，不处理
    if (![request.allHTTPHeaderFields[@"User-Agent"] hasPrefix:@"Mozilla"]) {
        return NO;
    }
    
    SLContainerAPI *containerAPI = _containerAPIDictionary[request.URL.path];
    return [containerAPI shouldInterceptRequest:request];
}

- (void)startLoading {
    SLContainerAPI *containerAPI = _containerAPIDictionary[self.request.URL.path];
    if ([containerAPI respondsToSelector:@selector(shouldInterceptRequest:)] && [containerAPI shouldInterceptRequest:self.request]) {
        if ([containerAPI respondsToSelector:@selector(prepareWithRequest:)]) {
            [containerAPI prepareWithRequest:self.request];
        }
        if ([containerAPI respondsToSelector:@selector(performWithRequest:)]) {
            [containerAPI performWithRequest:self.request];
        }
        NSData *data = [containerAPI responseData];
        NSURLResponse *response = [containerAPI responseWithRequest:self.request];
        [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [self.client URLProtocol:self didLoadData:data];
        [self.client URLProtocolDidFinishLoading:self];
    }
}

@end
