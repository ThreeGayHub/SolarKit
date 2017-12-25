//
//  SLLogContainerAPI.m
//  Example
//
//  Created by wyh on 2017/12/4.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "SLLogContainerAPI.h"

@implementation SLLogContainerAPI

- (void)performWithRequest:(NSURLRequest *)request {
    [super performWithRequest:request];
    
    NSLog(@"Log event:%@\nlabel:%@", self.bodyDictionary[@"event"],  self.bodyDictionary[@"label"]);
}

@end
