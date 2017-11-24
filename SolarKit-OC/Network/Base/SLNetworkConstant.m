//
//  SLNetworkConstant.m
//  Example
//
//  Created by wyh on 2017/10/26.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "SLNetworkConstant.h"

NSString * const SLNetworkDefaultManagerKey = @"SLNetworkDefaultManager";
const char * SLNetworkDefaultCompletionQueueKey = "com.solar.SLNetwork.default.completionQueue";
const char * SLNetworkCustomCompletionQueueKey = "com.solar.SLNetwork.custom.completionQueue";

NSDictionary * SLHTTPMethodDictionary() {
    static NSDictionary *httpMethodDictionary;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpMethodDictionary = @{
                                 @(SLHTTPMethodNONE)     : @"",
                                 @(SLHTTPMethodPOST)     : @"POST",
                                 @(SLHTTPMethodGET)      : @"GET",
                                 @(SLHTTPMethodPUT)      : @"PUT",
                                 @(SLHTTPMethodDELETE)   : @"DELETE",
                                 @(SLHTTPMethodHEAD)     : @"HEAD",
                                 @(SLHTTPMethodPATCH)    : @"PATCH",
                                 };
    });
    return httpMethodDictionary;
}

@implementation SLNetworkConstant

@end
