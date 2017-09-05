//
//  NSString+SLFoundation.h
//  Example
//
//  Created by wyh on 2017/8/2.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SLFoundation)

NSString *ToString(id obj);

//String -> Data
@property (nonatomic, readonly) NSData *data;

//String -> Base64Data
@property (nonatomic, readonly) NSData *enBase64Data;

//Base64String -> Data
@property (nonatomic, readonly) NSData *deBase64Data;

//String -> Base64String
@property (nonatomic, readonly) NSString *enBase64String;

//Base64String -> String
@property (nonatomic, readonly) NSString *deBase64String;

//Base64String -> Class
@property (nonatomic, readonly) Class clazz;

@property (nonatomic, readonly) NSString *localizedString;

@property (nonatomic, readonly) NSString *noSpacingString;

@property (nonatomic, readonly) BOOL isContainNumber;

@property (nonatomic, readonly) BOOL isContainUpperLetters;

@property (nonatomic, readonly) BOOL isContainLowerLetters;

@property (nonatomic, readonly) BOOL isContainSpecialCharacters;

@property (nonatomic, readonly) BOOL isContainChinese;

//yyyy-MM-dd
@property (nonatomic, readonly) NSDate *date;

//yyyy-MM-dd HH:mm:ss
@property (nonatomic, readonly) NSDate *dateTime;

- (BOOL)isMatchRegex:(NSString *)regex;

//TODO-时间戳

@end
