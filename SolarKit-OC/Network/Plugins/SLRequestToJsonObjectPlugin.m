//
//  SLRequestToJsonObjectPlugin.m
//  Example
//
//  Created by wyh on 2017/11/24.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "SLRequestToJsonObjectPlugin.h"
#import <YYModel/YYModel.h>

@implementation SLRequestToJsonObjectPlugin

- (void)prepareRequest:(SLRequest *)request {
    request.parameters = [request yy_modelToJSONObject];    
}

@end


