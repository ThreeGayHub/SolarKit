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

@class SLRequest;
@class SLResponse;

@protocol SLPlugin <NSObject>

@optional

/**
 prepareRequest
 
 RequestToDictionary, Encryption
 */
- (void)prepareRequest:(SLRequest *)request;


/**
 willSendRequest
 
 Custom Request
 */
- (void)willSendRequest:(NSMutableURLRequest *)request;


/**
 didReceiveResponse

 Decryption
 */
- (void)didReceiveResponse:(SLResponse *)response;

- (void)responseSuccess:(SLResponse *)response;

- (void)responseError:(SLResponse *)response;

@end

#endif /* SLPlugin_h */
