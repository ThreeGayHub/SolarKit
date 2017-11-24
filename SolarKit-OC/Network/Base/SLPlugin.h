//
//  SLPlugin.h
//  Example
//
//  Created by wyh on 2017/11/20.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#ifndef SLPlugin_h
#define SLPlugin_h

//0.hud
//1.log
//2.header
//3.encrypting
//4.NSJSONSerialization
//5.decryption
//6.jsonToModel

#import "SLRequest.h"
#import "SLResponse.h"

@protocol SLPlugin <NSObject>

@optional
- (void)prepareRequest:(SLRequest *)request;

- (void)willSendRequest:(NSMutableURLRequest *)request;

- (void)didReceiveResponse:(SLResponse *)response;

- (void)responseSuccess:(SLResponse *)response;

- (void)responseError:(SLResponse *)response;

@end

#endif /* SLPlugin_h */
