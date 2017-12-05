//
//  SLOpenWebVCContainerAPI.m
//  Example
//
//  Created by wyh on 2017/12/4.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "SLOpenWebVCContainerAPI.h"

@implementation SLOpenWebVCContainerAPI

- (BOOL)shouldInterceptRequest:(NSURLRequest *)request {
    return [request.URL.path isEqualToString:@"/api/openWebview"];
}

- (void)performWithRequest:(NSURLRequest *)request {
    [super performWithRequest:request];

    NSString *uri = self.bodyDictionary[@"uri"];
    NSString *url = self.bodyDictionary[@"url"];
    NSDictionary *parameters = self.bodyDictionary[@"params"];
    
//    NSData *params = [[form rxr_itemForKey:@"params"] dataUsingEncoding:NSUTF8StringEncoding];
    
}

@end
