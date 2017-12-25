//
//  SLWebCache.h
//  Example
//
//  Created by wyh on 2017/11/28.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SLWebCacheSuccess)(void);
typedef void(^SLWebCacheFail)(NSError *error);

@interface SLWebCache : NSObject

//path of updateJson, fullPackage, webResoruce: document/XXX
+ (void)customUpdateJsonName:(NSString *)updateJsonName fullPackageName:(NSString *)fullPackageName webResorucePathName:(NSString *)webResorucePathName;

+ (instancetype)shared;

- (void)updateSuccess:(SLWebCacheSuccess)success fail:(SLWebCacheFail)fail;
- (void)updateWithURLString:(NSString *)URLString success:(SLWebCacheSuccess)success fail:(SLWebCacheFail)fail;

//debug模式，每次启动都删除本地资源，走下载全量包流程
@property (nonatomic, assign, getter=isDebug) BOOL debug;

@end
