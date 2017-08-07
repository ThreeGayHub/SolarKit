//
//  NSData+SLFoundation.m
//  Example
//
//  Created by wyh on 2017/8/4.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "NSData+SLFoundation.h"

@implementation NSData (SLFoundation)

- (NSString *)string {
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

- (NSDictionary *)dictionary {
    NSError *error = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:&error];
    if (error || ![obj isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return obj;
}

- (NSArray *)array {
    NSError *error = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:&error];
    if (error || ![obj isKindOfClass:[NSArray class]]) {
        return nil;
    }
    return obj;
}

- (NSData *)enBase64Data {
    return [self base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (NSData *)deBase64Data {
    return [[NSData alloc] initWithBase64EncodedData:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
}

- (NSString *)enBase64String {
    return [self base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (NSString *)deBase64String {
    return [[NSString alloc] initWithData:self.deBase64Data encoding:NSUTF8StringEncoding];
}

@end
