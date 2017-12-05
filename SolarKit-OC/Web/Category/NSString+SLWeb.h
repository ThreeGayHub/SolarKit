//
//  NSString+SLWeb.h
//  Example
//
//  Created by wyh on 2017/11/29.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SLWeb)

@property (nonatomic, readonly) BOOL isHTTP;

/**
 * url 字符串编码
 */
- (NSString *)encodingStringUsingURLEscape;

/**
 * url 字符串解码
 */
- (NSString *)decodingStringUsingURLEscape;

@property (nonatomic, readonly) NSDictionary *dictionary;

@property (nonatomic, readonly) NSDictionary *queryDictionary;

@end
