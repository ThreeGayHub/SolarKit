//
//  SLRequestLogPlugin.m
//  Example
//
//  Created by wyh on 2017/11/24.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "SLRequestLogPlugin.h"

@implementation SLRequestLogPlugin

- (void)prepareRequest:(SLRequest *)request {
    SLNLog(@"URL:%@ \nParameters:\n %@", request.urlString, request.parameters);
}

@end
