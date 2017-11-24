//
//  SLTarget.m
//  Example
//
//  Created by wyh on 2017/11/23.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "SLTarget.h"

@implementation SLTarget

+ (instancetype)targetWithBaseURLString:(NSString *)baseURLString {
    return [[self alloc] initWithBaseURLString:baseURLString];
}

- (instancetype)initWithBaseURLString:(NSString *)baseURLString
{
    self = [super init];
    if (self) {
        _baseURLString = baseURLString;
    }
    return self;
}

- (void)setStatusCodeKey:(NSString *)statusCodeKey successStatusCode:(NSInteger)successStatusCode messageKey:(NSString *)messageKey responseDataKey:(NSString *)responseDataKey {
    _statusCodeKey = statusCodeKey;
    _successStatusCode = successStatusCode;
    _messageKey = messageKey;
    _responseDataKey = responseDataKey;
}

@end
