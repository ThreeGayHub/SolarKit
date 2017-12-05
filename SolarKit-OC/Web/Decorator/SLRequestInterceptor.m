//
//  SLRequestInterceptor.m
//  Rexxar
//
//  Created by bigyelow on 09/03/2017.
//  Copyright © 2017 Douban.Inc. All rights reserved.
//

#import "SLRequestInterceptor.h"
#import "SLURLSessionDemux.h"

static NSMutableArray<id<SLDecorator>> *_decorators;

@implementation SLRequestInterceptor

#pragma mark - Properties

+ (NSMutableArray<id<SLDecorator>> *)decorators {
    if (_decorators) return _decorators;
        
    _decorators = [NSMutableArray arrayWithCapacity:50];
    return _decorators;
}

+ (void)addDecorators:(id<SLDecorator>)decorator, ... {
    va_list args;
    va_start(args, decorator);
    if (decorator) {
        [SLRequestInterceptor.decorators addObject:decorator];
        id<SLDecorator> nextDecorator;
        while ((nextDecorator = va_arg(args, id<SLDecorator>))) {
            [SLRequestInterceptor.decorators addObject:nextDecorator];
        }
    }
    va_end(args);
}

#pragma mark - Superclass methods

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
  // 请求被忽略（被标记为忽略或者已经请求过），不处理
  if ([self isRequestIgnored:request]) {
    return NO;
  }
  // 请求不是来自浏览器，不处理
  if (![request.allHTTPHeaderFields[@"User-Agent"] hasPrefix:@"Mozilla"]) {
    return NO;
  }

  for (id<SLDecorator> decorator in _decorators) {
    if ([decorator shouldInterceptRequest:request]){
      return YES;
    }
  }

  return NO;
}

- (void)startLoading
{
  NSMutableURLRequest *newRequest = nil;
  if ([self.request isKindOfClass:[NSMutableURLRequest class]]) {
    newRequest = (NSMutableURLRequest *)self.request;
  } else {
    newRequest = [self.request mutableCopy];
  }

  for (id<SLDecorator> decorator in _decorators) {
    if ([decorator shouldInterceptRequest:self.request]) {
      if ([decorator respondsToSelector:@selector(prepareWithRequest:)]) {
        [decorator prepareWithRequest:self.request];
      }
      newRequest = [[decorator decoratedRequestFromOriginalRequest:newRequest] mutableCopy];
    }
  }

  [[self class] markRequestAsIgnored:newRequest];

  NSMutableArray *modes = [NSMutableArray array];
  [modes addObject:NSDefaultRunLoopMode];

  NSString *currentMode = [[NSRunLoop currentRunLoop] currentMode];
  if (currentMode != nil && ![currentMode isEqualToString:NSDefaultRunLoopMode]) {
    [modes addObject:currentMode];
  }
  [self setModes:modes];

  NSURLSessionTask *dataTask = [[[self class] sharedDemux] dataTaskWithRequest:newRequest delegate:self modes:self.modes];
  [dataTask resume];
  [self setDataTask:dataTask];
}

@end
