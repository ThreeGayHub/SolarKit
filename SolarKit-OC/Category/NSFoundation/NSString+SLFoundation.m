//
//  NSString+SLFoundation.m
//  Example
//
//  Created by wyh on 2017/8/2.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "NSString+SLFoundation.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@implementation NSString (SLFoundation)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(containsString:);
        SEL swizzledSelector = @selector(sl_containsString:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }
        else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (BOOL)sl_containsString:(NSString *)str {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        return [self sl_containsString:str];
    }
    return [self rangeOfString:str].location != NSNotFound;
}

NSString *ToString(id obj) {
    return (obj && ![obj isKindOfClass:[NSNull class]]) ? [NSString stringWithFormat:@"%@", obj] : @"";
}

- (NSData *)data {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSData *)enBase64Data {
    return [self.data base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (NSData *)deBase64Data {
    return [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
}

- (NSString *)enBase64String {
    return [self.data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (NSString *)deBase64String {
    return [[NSString alloc] initWithData:self.deBase64Data encoding:NSUTF8StringEncoding];
}

- (Class)clazz {
    return NSClassFromString(self);
}

- (NSString *)localizedString {
    return NSLocalizedString(self, nil);
}

- (NSString *)noSpacingString {
    return [[self stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"　" withString:@""];
}

- (BOOL)isContainNumber {
    return [self isMatchRegex:@".*?\\d+.*?"];
}

- (BOOL)isContainUpperLetters {
    return [self isMatchRegex:@".*?[A-Z]+.*?"];
}

- (BOOL)isContainLowerLetters {
    return [self isMatchRegex:@".*?[a-z]+.*?"];
}

- (BOOL)isContainSpecialCharacters {
    return [self isMatchRegex:@".*?[^A-Za-z0-9]+.*?"];
}

- (BOOL)isContainChinese {
    return [self isMatchRegex:@"[\u4e00-\u9fa5]+"];
}

- (NSDate *)dateWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = format;
    return [formatter dateFromString:self];
}

- (NSDate *)date {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter dateFromString:self];
}

- (NSDate *)dateTime {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter dateFromString:self];
}

- (BOOL)isMatchRegex:(NSString *)regex {
    BOOL result = NO;
    if (self.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [predicate evaluateWithObject:self];
    }
    return result;
}

@end
