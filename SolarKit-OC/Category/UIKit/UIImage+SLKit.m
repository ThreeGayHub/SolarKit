//
//  UIImage+SLKit.m
//  Pluto
//
//  Created by wyh on 2017/12/14.
//  Copyright © 2017年 NEO Capital. All rights reserved.
//

#import "UIImage+SLKit.h"

@implementation UIImage (SLKit)

- (NSString *)enBase64String {
    return [UIImagePNGRepresentation(self) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

@end
