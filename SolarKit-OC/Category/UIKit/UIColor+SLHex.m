//
//  UIColor+SLHex.m
//  Pods
//
//  Created by wyh on 2017/7/7.
//
//

#import "UIColor+SLHex.h"

@implementation UIColor (SLHex)

+ (instancetype)hexColor:(NSString *)hexString {
    if (hexString) {
        unsigned rgbValue = 0;
        hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
        NSScanner *scanner = [NSScanner scannerWithString:hexString];
        [scanner scanHexInt:&rgbValue];
        return [self colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.f green:((rgbValue & 0xFF00) >> 8) / 255.f blue:(rgbValue & 0xFF) / 255.f alpha:1.f];
    }
    return nil;
}

@end
