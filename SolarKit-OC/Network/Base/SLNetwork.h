//
//  SLNetwork.h
//  Example
//
//  Created by wyh on 2017/7/5.
//  Copyright © 2017年 SolarKit. All rights reserved.
//


//  👌0.基本配置 session配置 (考虑多服务器地址：Moya的target)
//  👌1.请求和请求配置
//  2.上传，断点续传 (非WiFi网络提示)
//  3.下载，断点下载 (非WiFi网络提示)
//  3.组合 completionGroup？
//  👌4.请求时和回调时的多线程控制 completionQueue
//  👌5.监测网络
//  6.全局上传下载回调
//  7.上传下载队列以及网络变换时的并发数处理
//  👌8.开放请求配置：Serializer
//  9.插件：把HUD回调到外面处理(处理add在view上的问题)
//  👌10.插件：把Request的加密解耦(Moya的plugins)
//  11.同步队列
//  👌12.配置response正确错误的key和value
//  13.请求参数的判断 断言NSAssert()NSParameterAssert()
//  14.重复查询，request的缓存
//  15.response的缓存？
//  👌16.超时设置
//  👌17.打印格式化后的json?
//  18.HTTPS自签名证书的验证
//  👌TargetType+Request+Manager+Response+Plugin
//  👌创建N个配置类，实现TargetType配置基本信息，然后赋给Manager取manager单例对象
//  👌埋点给Plugin注入，根据BaseUrl进行不同的拦截配置
//  👌成功失败bodyKey如何处理？


//AFSecurityPolicy*policy=[AFSecurityPolicypolicyWithPinningMode:AFSSLPinningModePublicKey];policy.validatesDomainName=YES;AFHTTPSessionManager*manager=[AFHTTPSessionManagermanager];manager.securityPolicy=policy;manager.requestSerializer.cachePolicy=NSURLRequestReloadIgnoringLocalCacheData;
//CA 防中间人攻击



#ifndef SLNetwork_h
#define SLNetwork_h

#import "SLNetworkConstant.h"
#import "SLTarget.h"
#import "SLPlugin.h"
#import "SLManager.h"
#import "SLRequest.h"
#import "SLResponse.h"

#endif /* SLNetwork_h */
