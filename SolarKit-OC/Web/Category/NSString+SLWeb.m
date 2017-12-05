//
//  NSString+SLWeb.m
//  Example
//
//  Created by wyh on 2017/11/29.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "NSString+SLWeb.h"
#import "NSDictionary+SLWeb.h"

@implementation NSString (SLWeb)

- (BOOL)isHTTP {
    return [self hasPrefix:@"https"] || [self hasPrefix:@"http"] || [self isEqualToString:@"https"] || [self isEqualToString:@"http"];
}

- (NSString *)encodingStringUsingURLEscape {
    CFStringRef originStringRef = (__bridge_retained CFStringRef)self;
    CFStringRef escapedStringRef = CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                           originStringRef,
                                                                           NULL,
                                                                           (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                           kCFStringEncodingUTF8);
    NSString *escapedString = (__bridge_transfer NSString *)escapedStringRef;
    CFRelease(originStringRef);
    return escapedString;
}

- (NSString *)decodingStringUsingURLEscape {
    CFStringRef originStringRef = (__bridge_retained CFStringRef)self;
    CFStringRef escapedStringRef = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                           originStringRef,
                                                                                           CFSTR(""),
                                                                                           kCFStringEncodingUTF8);
    NSString *escapedString = (__bridge_transfer NSString *)escapedStringRef;
    CFRelease(originStringRef);
    return escapedString;
}

- (NSDictionary *)dictionary {
    return [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
}

- (NSDictionary *)queryDictionary {
    NSString *query = self;
    if ([query length] == 0) {
        return nil;
    }
    
    // Replace '+' with space
    query = [query stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
    
    NSCharacterSet *delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary *pairs = [NSMutableDictionary dictionary];
    
    NSScanner *scanner = [[NSScanner alloc] initWithString:query];
    while (![scanner isAtEnd]) {
        NSString *pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray *kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2) {
            [pairs addItem:[[kvPair objectAtIndex:1] decodingStringUsingURLEscape]
                    forKey:[[kvPair objectAtIndex:0] decodingStringUsingURLEscape]];
        }
    }
    
    return [pairs copy];
}

@end
