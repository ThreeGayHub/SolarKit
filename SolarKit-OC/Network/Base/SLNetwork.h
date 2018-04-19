//
//  SLNetwork.h
//  Example
//
//  Created by wyh on 2017/7/5.
//  Copyright © 2017年 SolarKit. All rights reserved.
//


//  👌0.基本配置 session配置 (考虑多服务器地址：Moya的target)
//  👌1.请求和请求配置
//  👌2.上传
//  👌3.下载，断点下载
//  👌4.请求时和回调时的多线程控制 completionQueue
//  👌5.监测网络
//  👌6.开放请求配置：Serializer
//  👌7.Plugins
//  👌8.配置response正确错误的key和value
//  👌9.超时设置
//  👌10.打印格式化后的json?
//  👌11.HTTPS证书验证
//  👌TargetType+Request+Manager+Response+Plugin
//  👌创建N个配置类，实现TargetType配置基本信息，然后赋给Manager取manager单例对象
//  👌埋点给Plugin注入，根据BaseUrl进行不同的拦截配置
//  Manager(target.plugins).request(model).progress(progress).completion(response)


#ifndef SLNetwork_h
#define SLNetwork_h

#import "SLNetworkConstant.h"
#import "SLTarget.h"
#import "SLPlugin.h"
#import "SLManager.h"
#import "SLRequest.h"
#import "SLResponse.h"

#endif /* SLNetwork_h */
