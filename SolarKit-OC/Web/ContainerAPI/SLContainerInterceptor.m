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

static NSMutableArray<id<SLContainerAPI>> *_containerAPIs;

@implementation SLContainerInterceptor

+ (void)addContainerAPIs:(id<SLContainerAPI>)containerAPI, ... {
    va_list args;
    va_start(args, containerAPI);
    if (containerAPI) {
        [SLContainerInterceptor.containerAPIs addObject:containerAPI];
        id<SLContainerAPI> nextContainerAPI;
        while ((nextContainerAPI = va_arg(args, id<SLContainerAPI>))) {
            [SLContainerInterceptor.containerAPIs addObject:nextContainerAPI];
        }
    }
    va_end(args);
}

+ (NSMutableArray<id<SLContainerAPI>> *)containerAPIs {
    if (_containerAPIs) return _containerAPIs;
    
    _containerAPIs = [NSMutableArray arrayWithCapacity:50];
    return _containerAPIs;
}

#pragma mark - Implement NSURLProtocol methods

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
  // 请求不是来自浏览器，不处理
  if (![request.allHTTPHeaderFields[@"User-Agent"] hasPrefix:@"Mozilla"]) {
    return NO;
  }

  for (id<SLContainerAPI> containerAPI in _containerAPIs) {
    if ([containerAPI shouldInterceptRequest:request]) {
      return YES;
    }
  }

  return NO;
}

- (void)startLoading
{
  for (id<SLContainerAPI> containerAPI in _containerAPIs) {
    if ([containerAPI shouldInterceptRequest:self.request]) {

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
      break;
    }
  }
}

@end
