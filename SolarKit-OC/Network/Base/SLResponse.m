//
//  SLResponse.m
//  Example
//
//  Created by wyh on 2017/11/20.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "SLResponse.h"
#import "SLTarget.h"
#import "SLRequest.h"

@interface NSError (SLResponse_Private)

+ (instancetype)errorWithCode:(NSInteger)code message:(NSString *)message;

@end

@interface SLResponse ()


@end

@implementation SLResponse



+ (nullable instancetype)responseWithSessionDataTask:(nullable NSURLSessionDataTask *)dataTask
                                              target:(nullable SLTarget *)target
                                             plugins:(nullable NSMutableArray<id<SLPlugin>> *)plugins
                                             request:(nullable SLRequest *)request
                                            response:(nullable NSURLResponse *)response
                                      responseObject:(nullable id)responseObject
                                               error:(nullable NSError *)error {
    return [[self alloc] initWithSessionDataTask:dataTask
                                          target:target
                                         plugins:plugins
                                         request:request
                                        response:response
                                  responseObject:responseObject
                                           error:error];
}

- (instancetype)initWithSessionDataTask:(nullable NSURLSessionDataTask *)dataTask
                                 target:(nullable SLTarget *)target
                                plugins:(nullable NSMutableArray<id<SLPlugin>> *)plugins
                                request:(nullable SLRequest *)request
                               response:(nullable NSURLResponse *)response
                         responseObject:(nullable id)responseObject
                                  error:(nullable NSError *)error  {
    self = [super init];
    if (self) {
        _dataTask = dataTask;
        _target = target;
        _plugins = plugins;
        _request = request;
        _response = response;
        _responseObject = responseObject;
        _error = error;
    }
    return self;
}

- (void)dealResponseSuccess:(SLManagerSuccess)success failure:(SLManagerFailure)failure {
    if (self.error) {
        if (failure) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(self.dataTask, self.error);
            });
        }
    } else {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(self.dataTask, self.responseObject);
            });
        }
    }
}

- (void)dealResponseComplete:(SLManagerComplete)complete fail:(SLManagerFail)fail {
    if (self.error) {
        [self dealResponseFail:fail];
    }
    else {
        //didReceiveResponse
        [self.plugins enumerateObjectsUsingBlock:^(id<SLPlugin>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(didReceiveResponse:)]) {
                [obj didReceiveResponse:self];
            }
        }];
        
        //responseObjectToJsonObject
        [self jsonToObjectWithFail:fail];
        SLNLog(@"URL:%@ \nResponse:\n %@", self.request.urlString, self.responseObject);
        
        if ([self.responseObject isKindOfClass:[NSDictionary class]]) {
            NSInteger code = [[self.responseObject objectForKey:self.target.statusCodeKey] integerValue];
            if (code == self.target.successStatusCode) {
                [self dealResponseComplete:complete];
            }
            else {
                NSString *message = [self.responseObject objectForKey:self.target.messageKey];
                if (!self.error) {
                    self.error = [NSError errorWithCode:code message:message];
                }
                [self dealResponseFail:fail];
            }
        }
    }
}

- (void)dealResponseComplete:(SLManagerComplete)complete {
    //responseSuccess
    [self.plugins enumerateObjectsUsingBlock:^(id<SLPlugin>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(responseSuccess:)]) {
            [obj responseSuccess:self];
        }
    }];
    
    id response = [self.responseObject objectForKey:self.target.responseDataKey];
    if (complete) complete(response);
}

- (void)dealResponseFail:(SLManagerFail)fail {
    //responseError
    [self.plugins enumerateObjectsUsingBlock:^(id<SLPlugin>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(responseError:)]) {
            [obj responseError:self];
        }
    }];
    
    if (fail) fail(self.error);
}

- (void)jsonToObjectWithFail:(SLManagerFail)fail {
    if (![self.responseObject isKindOfClass:[NSDictionary class]]) {
        NSError *jsonSerializationError = nil;
        self.responseObject = [NSJSONSerialization JSONObjectWithData:self.responseObject options:self.target.jsonReadingOptions error:&jsonSerializationError];
        if (jsonSerializationError) {
            self.error = jsonSerializationError;
            [self dealResponseFail:fail];
        }
    }
}

@end

@implementation NSError (SLResponse_Private)

+ (instancetype)errorWithCode:(NSInteger)code message:(NSString *)message {
    return [NSError errorWithDomain:[self bundleID] code:code userInfo:@{NSLocalizedDescriptionKey : message ?: @""}];
}

+ (NSString *)bundleID {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

@end
