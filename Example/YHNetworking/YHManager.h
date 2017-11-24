//
//  YHManager.h
//  Neptune
//
//  Created by wyh on 2016/11/7.
//  Copyright © 2016年 NEO Capital. All rights reserved.
//

#import "AFNetworking.h"
#import "YHNetworkConfig.h"

@class YHRequest;

@interface YHManager : AFHTTPSessionManager

/**
 *  singleton
 *  PS:Don't forget to set requestSerializer || responseSerializer if you need.
 */
+ (nullable instancetype)shared;

/**
 *  https
 */
- (void)configHttps:(AFSSLPinningMode)pinningMode;

/**
 *  Reachability
 *  Please Observe it
 */
@property (nonatomic, assign) AFNetworkReachabilityStatus reachabilityStatus;

/**
 *  send
 */
- (nullable NSURLSessionDataTask *)send:(nullable YHRequest *)request;
- (nullable NSURLSessionDataTask *)send:(nullable YHRequest *)request complete:(nullable YHManagerComplete)complete;
- (nullable NSURLSessionDataTask *)send:(nullable YHRequest *)request complete:(nullable YHManagerComplete)complete fail:(nullable YHManagerFail)fail;
- (nullable NSURLSessionDataTask *)send:(nullable YHRequest *)request success:(nullable YHManagerSuccess)success;
- (nullable NSURLSessionDataTask *)send:(nullable YHRequest *)request success:(nullable YHManagerSuccess)success failure:(nullable YHManagerFailure)failure;

/**
 *  upload
 */
- (nullable NSURLSessionUploadTask *)upload:(nullable YHRequest *)request;
- (nullable NSURLSessionUploadTask *)upload:(nullable YHRequest *)request progress:(nullable YHManagerProgress)progress;
- (nullable NSURLSessionUploadTask *)upload:(nullable YHRequest *)request progress:(nullable YHManagerProgress)progress complete:(nullable YHManagerComplete)complete;
- (nullable NSURLSessionUploadTask *)upload:(nullable YHRequest *)request progress:(nullable YHManagerProgress)progress complete:(nullable YHManagerComplete)complete fail:(nullable YHManagerFail)fail;
- (nullable NSURLSessionUploadTask *)upload:(nullable YHRequest *)request progress:(nullable YHManagerProgress)progress success:(nullable YHManagerSuccess)success;
- (nullable NSURLSessionUploadTask *)upload:(nullable YHRequest *)request progress:(nullable YHManagerProgress)progress success:(nullable YHManagerSuccess)success failure:(nullable YHManagerFailure)failure;

/**
 *  download
 */
- (nullable NSURLSessionDataTask *)download:(nullable YHRequest *)request;
- (nullable NSURLSessionDataTask *)download:(nullable YHRequest *)request progress:(nullable YHManagerProgress)progress;
- (nullable NSURLSessionDataTask *)download:(nullable YHRequest *)request progress:(nullable YHManagerProgress)progress complete:(nullable YHManagerComplete)complete;
- (nullable NSURLSessionDataTask *)download:(nullable YHRequest *)request progress:(nullable YHManagerProgress)progress complete:(nullable YHManagerComplete)complete fail:(nullable YHManagerFail)fail;
- (nullable NSURLSessionDataTask *)download:(nullable YHRequest *)request progress:(nullable YHManagerProgress)progress success:(nullable YHManagerSuccess)success;
- (nullable NSURLSessionDataTask *)download:(nullable YHRequest *)request progress:(nullable YHManagerProgress)progress success:(nullable YHManagerSuccess)success failure:(nullable YHManagerFailure)failure;

/**
 *  background response
 */
- (nullable YHManager *)uploadGlobalComplete:(nullable YHUploadGlobalComplete)uploadGlobalComplete;
- (nullable YHManager *)uploadGlobalFail:(nullable YHUploadGlobalFail)uploadGlobalFail;
- (nullable YHManager *)uploadGlobalProgress:(nullable YHUploadGlobalProgress)uploadGlobalProgress;

@property (nonatomic, readonly, nullable)YHUploadGlobalComplete uploadGlobalComplete;
@property (nonatomic, readonly, nullable)YHUploadGlobalFail uploadGlobalFail;
@property (nonatomic, readonly, nullable)YHUploadGlobalProgress uploadGlobalProgress;

- (nullable YHManager *)downloadGlobalComplete:(nullable YHDownloadGlobalComplete)downloadGlobalComplete;
- (nullable YHManager *)downloadGlobalFail:(nullable YHDownloadGlobalFail)downloadGlobalFail;
- (nullable YHManager *)downloadGlobalProgress:(nullable YHDownloadGlobalProgress)downloadGlobalProgress;

@property (nonatomic, readonly, nullable)YHDownloadGlobalComplete downloadGlobalComplete;
@property (nonatomic, readonly, nullable)YHDownloadGlobalFail downloadGlobalFail;
@property (nonatomic, readonly, nullable)YHDownloadGlobalProgress downloadGlobalProgress;

@end
