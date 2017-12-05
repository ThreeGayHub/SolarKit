//
//  SLDecorator.m
//  Example
//
//  Created by wyh on 2017/12/4.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "SLDecorator.h"

@implementation SLDecorator

- (nonnull NSURLRequest *)decoratedRequestFromOriginalRequest:(nonnull NSURLRequest *)originalRequest {
    return [[NSURLRequest alloc] init];
}

- (BOOL)shouldInterceptRequest:(nonnull NSURLRequest *)request {
    return YES;
}

- (void)prepareWithRequest:(NSURLRequest *)request {
    
}

@end
