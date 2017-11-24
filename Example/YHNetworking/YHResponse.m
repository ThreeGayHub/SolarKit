//
//  YHResponse.m
//  Neptune
//
//  Created by wyh on 2016/11/8.
//  Copyright © 2016年 NEO Capital. All rights reserved.
//

#import "YHResponse.h"
#import "YHRequest.h"
#import "YHManager.h"

@implementation YHResponse

+ (BOOL)responseSerializationError:(NSError *)serializationError failure:(YHManagerFailure)failure {
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return YES;
    }
    return NO;
}

+ (void)responseWithTask:(NSURLSessionDataTask *)dataTask request:(YHRequest *)request complete:(YHManagerComplete)complete fail:(YHManagerFail)fail success:(YHManagerSuccess)success failure:(YHManagerFailure)failure response:(NSURLResponse *)response responseObject:(id)responseObject error:(NSError *)error {
    if ([YHNetworkConfig shared].globalEndLoad) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [YHNetworkConfig shared].globalEndLoad(request.isShowLoadingHUD);
        });
    }
    if (success || failure) {
        if (error) {
            if (failure) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(dataTask, error);
                });
            }
        } else {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(dataTask, responseObject);
                });
            }
        }
    }
    else {
        if (error) {
            [self responseFail:fail request:request status:error.code message:error.localizedDescription];
        }
        else {
            [self responseSuccess:response responseObject:responseObject error:error request:request complete:complete fail:fail];
        }
    }
}

+ (void)responseSuccess:(NSURLResponse *)response responseObject:(id)responseObject error:(NSError *)error request:(YHRequest *)request complete:(YHManagerComplete)complete fail:(YHManagerFail)fail {
    if ([YHNetworkConfig shared].httpURLResponseHandle) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [YHNetworkConfig shared].httpURLResponseHandle((NSHTTPURLResponse *)response);
        });
    }
    
    id jsonObject;
    if (request.jsonSerialization) {
        jsonObject = request.jsonSerialization(responseObject);
    }
    else if ([YHNetworkConfig shared].jsonSerialization) {
        jsonObject = [YHNetworkConfig shared].jsonSerialization(responseObject);
    }
    else {
        NSError *jsonSerializationError;
        jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&jsonSerializationError];
        if (jsonSerializationError) {
            [self responseFail:fail request:request status:jsonSerializationError.code message:jsonSerializationError.localizedDescription];
            return;
        }
    }
    
    if (request.responseDecryption) {
        jsonObject = request.responseDecryption(jsonObject);
    }
    else if ([YHNetworkConfig shared].responseDecryption) {
        jsonObject = [YHNetworkConfig shared].responseDecryption(jsonObject);
    }
    
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        NSInteger status = [[jsonObject objectForKey:request.responseStatusKey] integerValue];
        NSString *message = [jsonObject objectForKey:request.responseMessageKey];
        if (status == request.responseStatusSuccess) {
            id responseBody = [jsonObject objectForKey:request.responseBodyKey];
            if (complete) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    complete(responseBody);
                });
            }
            
            if ([YHNetworkConfig shared].globalSuccess) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [YHNetworkConfig shared].globalSuccess(request.isShowSuccessMsg, message);
                });
            }
            
            if ([YHManager shared].uploadGlobalComplete) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [YHManager shared].uploadGlobalComplete(request.requestID, responseBody);
                });
            }
            
            if ([YHManager shared].downloadGlobalComplete) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [YHManager shared].downloadGlobalComplete(request.requestID, responseBody);
                });
            }
#if DEBUG
            if ([responseBody isKindOfClass:[NSArray class]]) {
                [responseBody enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    YHLog(@"Success-requestID:%@(%ld)\n%@", request.requestID, (unsigned long)idx, [obj description]);
                }];
            }
            else {
                YHLog(@"Success-requestID:%@\n%@", request.requestID, [responseBody description]);
            }
#endif
        }
        else {
            [self responseFail:fail request:request status:status message:message];
        }
    }
}

+ (void)responseFail:(YHManagerFail)fail request:(YHRequest *)request status:(NSInteger)status message:(NSString *)message {
    if (fail) {
        dispatch_async(dispatch_get_main_queue(), ^{
            fail(status, message);
        });
    }
    
    if ([YHNetworkConfig shared].globalFail) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [YHNetworkConfig shared].globalFail(request.isShowFailMsg, status, message);
        });
    }
    
    if ([YHManager shared].uploadGlobalFail) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [YHManager shared].uploadGlobalFail(request.requestID, status, message);
        });
    }
    
    if ([YHManager shared].downloadGlobalFail) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [YHManager shared].downloadGlobalFail(request.requestID, status, message);
        });
    }
    YHLog(@"Error-requestID:%@ \ncode:%ld \nmessage:%@", request.requestID, status, message);
}

@end
