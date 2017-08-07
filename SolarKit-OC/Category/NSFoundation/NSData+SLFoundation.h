//
//  NSData+SLFoundation.h
//  Example
//
//  Created by wyh on 2017/8/4.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (SLFoundation)

@property (nonatomic, readonly) NSString *string;

@property (nonatomic, readonly) NSDictionary *dictionary;

@property (nonatomic, readonly) NSArray *array;

//Data -> Base64Data
@property (nonatomic, readonly) NSData *enBase64Data;

//Base64Data -> Data
@property (nonatomic, readonly) NSData *deBase64Data;

//Data -> Base64String
@property (nonatomic, readonly) NSString *enBase64String;

//Base64Data -> String
@property (nonatomic, readonly) NSString *deBase64String;

@end
