//
//  UIImage+SLKit.m
//  Example
//
//  Created by wyh on 2017/8/9.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "UIImage+SLKit.h"

@implementation UIImage (SLKit)

- (NSData *)data {
    return UIImagePNGRepresentation(self);
}

- (NSData *)jpegData {
    return UIImageJPEGRepresentation(self, 1);
}

- (NSData *)jpegDataWithQuality:(float)quality {
    return UIImageJPEGRepresentation(self, quality);
}

@end
