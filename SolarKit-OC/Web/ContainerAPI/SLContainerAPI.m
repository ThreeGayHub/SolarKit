//
//  SLContainerAPI.m
//  Example
//
//  Created by wyh on 2017/12/4.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "SLContainerAPI.h"
#import "NSData+SLWeb.h"
#import "NSString+SLWeb.h"

@implementation SLContainerAPI

- (nullable NSData *)responseData {
    return [NSData data];
}

- (nonnull NSURLResponse *)responseWithRequest:(nonnull NSURLRequest *)request {
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:request.URL
                                                              statusCode:200
                                                             HTTPVersion:@"HTTP/1.1"
                                                            headerFields:nil];
    return response;
}

- (BOOL)shouldInterceptRequest:(nonnull NSURLRequest *)request {
    return YES;
}

- (void)prepareWithRequest:(NSURLRequest *)request {
    
}

- (void)performWithRequest:(NSURLRequest *)request {
    NSString *bodyString = [[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding] decodingStringUsingURLEscape];
    NSArray<NSString *> *keyValues = [bodyString componentsSeparatedByString:@"&"];
    if (keyValues.count > 0) {
        NSMutableDictionary *form = [NSMutableDictionary dictionary];
        [keyValues enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *array = [obj componentsSeparatedByString:@"="];
            if (array.count == 2) {
                id value = array[1];
                if ([value hasPrefix:@"{"] || [value hasPrefix:@"["]) {
                    value = [NSJSONSerialization JSONObjectWithData:[value dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                }
                if (value) {
                    [form setObject:value forKey:array[0]];
                }
            }
        }];
        _bodyDictionary = form.copy;
    }
    
}

@end
