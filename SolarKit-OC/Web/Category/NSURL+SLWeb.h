//
//  NSURL+SLWeb.h
//  SLWeb
//
//  Created by GUO Lin on 1/18/16.
//  Copyright © 2016 Douban.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (SLWeb)

/**
 * 将一个字典内容转换成 url 的 query 的形式。
 *
 * @param dict 需要转换成的 query 的 dictionary。
 */
+ (NSString *)queryFromDictionary:(NSDictionary *)dict;

/**
 * 该 url 的 scheme 是否是 http 或 https？
 */
@property (nonatomic, readonly) BOOL isHttpOrHttps;

/**
 * 将该 url 的 query 以字典形式返回。
 */
@property (nonatomic, readonly) NSDictionary *queryDictionary;

@end
