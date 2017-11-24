//
//  SLRequestToDictionaryPlugin.m
//  Example
//
//  Created by wyh on 2017/11/24.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "SLRequestToDictionaryPlugin.h"
#import <YYModel/YYModel.h>

@implementation SLRequestToDictionaryPlugin

- (void)prepareRequest:(SLRequest *)request {
    request.parameters = [request yy_modelToJSONObject];    
}

@end


