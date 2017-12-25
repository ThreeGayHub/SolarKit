//
//  SLOpenWebVCContainerAPI.m
//  Example
//
//  Created by wyh on 2017/12/4.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "SLOpenWebVCContainerAPI.h"

@implementation SLOpenWebVCContainerAPI

- (void)performWithRequest:(NSURLRequest *)request {
    [super performWithRequest:request];

    NSString *URIString = self.bodyDictionary[@"uri"] ? : self.bodyDictionary[@"url"];
    NSDictionary *params = self.bodyDictionary[@"params"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (params) {
        [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [parameters setObject:obj forKey:[@":" stringByAppendingString:key]];
        }];
    }
    SLWebViewController * webVC = [[SLWebViewController alloc] initWithURIString:URIString paramters:parameters];
    [self.controller.navigationController pushViewController:webVC animated:YES];
}

@end
