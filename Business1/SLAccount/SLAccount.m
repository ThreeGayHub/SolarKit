//
//  SLAccount.m
//  Example
//
//  Created by wyh on 2017/9/26.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "SLAccount.h"
#import "SLKit.h"
#import "SLLoginVC.h"

@implementation SLAccount

- (UIViewController *)login:(NSDictionary *)params {
    
    SLLoginVC *vc = [[SLLoginVC alloc] init];
    vc.parameters = params;
    return vc;
    
}

@end
