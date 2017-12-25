//
//  UIImage+SLLuban.m
//  Example
//
//  Created by wyh on 2017/8/9.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "UIImage+SLLuban.h"

@implementation UIImage (SLLuban)

- (UIImage *)compressImageWithWatermark:(UIImage *)watermarkImage {
    double size;
    NSData *data = UIImageJPEGRepresentation(self, 1);
    
    NSLog(@"Original Image Size: %f kb", data.length / 1024.0);
    
    int fixelW = (int)self.size.width;
    int fixelH = (int)self.size.height;
    int thumbW = fixelW % 2  == 1 ? fixelW + 1 : fixelW;
    int thumbH = fixelH % 2  == 1 ? fixelH + 1 : fixelH;
    
    double scale = ((double)fixelW/fixelH);
    
    if (scale <= 1 && scale > 0.5625) {
        
        if (fixelH < 1664) {
            if (data.length/1024.0 < 150) {
                return self;
            }
            size = (fixelW * fixelH) / pow(1664, 2) * 150;
            size = size < 60 ? 60 : size;
        }
        else if (fixelH >= 1664 && fixelH < 4990) {
            thumbW = fixelW / 2;
            thumbH = fixelH / 2;
            size   = (thumbH * thumbW) / pow(2495, 2) * 300;
            size = size < 60 ? 60 : size;
        }
        else if (fixelH >= 4990 && fixelH < 10240) {
            thumbW = fixelW / 4;
            thumbH = fixelH / 4;
            size = (thumbW * thumbH) / pow(2560, 2) * 300;
            size = size < 100 ? 100 : size;
        }
        else {
            int multiple = fixelH / 1280 == 0 ? 1 : fixelH / 1280;
            thumbW = fixelW / multiple;
            thumbH = fixelH / multiple;
            size = (thumbW * thumbH) / pow(2560, 2) * 300;
            size = size < 100 ? 100 : size;
        }
    }
    else if (scale <= 0.5625 && scale > 0.5) {
        
        if (fixelH < 1280 && data.length/1024 < 200) {
            
            return self;
        }
        int multiple = fixelH / 1280 == 0 ? 1 : fixelH / 1280;
        thumbW = fixelW / multiple;
        thumbH = fixelH / multiple;
        size = (thumbW * thumbH) / (1440.0 * 2560.0) * 400;
        size = size < 100 ? 100 : size;
    }
    else {
        int multiple = (int)ceil(fixelH / (1280.0 / scale));
        thumbW = fixelW / multiple;
        thumbH = fixelH / multiple;
        size = ((thumbW * thumbH) / (1280.0 * (1280 / scale))) * 500;
        size = size < 100 ? 100 : size;
    }
    
    return [self _compressWithThumbW:thumbW thumbH:thumbH size:size watermark:watermarkImage];
}

- (UIImage *)compressImage {
    return [self compressImageWithWatermark:nil];
}

- (UIImage *)_compressWithThumbW:(int)width thumbH:(int)height size:(double)size watermark:(UIImage *)watermarkImage {
    UIImage *thumbImage = [self _fixOrientation];
    thumbImage = [thumbImage _resizeWithThumbWidth:width thumbHeight:height watermark:watermarkImage];
    
    int qualityCompress = 1.0;
    
    NSData *data = UIImageJPEGRepresentation(thumbImage, qualityCompress);
    
    NSUInteger lenght = data.length;
    while (lenght / 1024 > size && qualityCompress > 0.06) {
        qualityCompress -= 0.06;
        data = UIImageJPEGRepresentation(thumbImage, qualityCompress);
        lenght = data.length;
        thumbImage = [UIImage imageWithData:data];
    }
    NSLog(@"Compress Image Size: %f kb", data.length / 1024.0);
    return thumbImage;
}

- (UIImage *)_resizeWithThumbWidth:(int)width thumbHeight:(int)height watermark:(UIImage *)watermarkImage {
    
    int outW = (int)self.size.width;
    int outH = (int)self.size.height;
    
    int inSampleSize = 1;
    
    if (outW > width || outH > height) {
        int halfW = outW / 2;
        int halfH = outH / 2;
        
        while ((halfH / inSampleSize) > height && (halfW / inSampleSize) > width) {
            inSampleSize *= 2;
        }
    }
    int heightRatio = (int)ceil(outH / (float) height);
    int widthRatio  = (int)ceil(outW / (float) width);
    
    if (heightRatio > 1 || widthRatio > 1) {
        
        inSampleSize = heightRatio > widthRatio ? heightRatio : widthRatio;
    }
    CGSize thumbSize = CGSizeMake((NSUInteger)((CGFloat)outW/widthRatio), (NSUInteger)((CGFloat)outH/heightRatio));
    
    UIGraphicsBeginImageContext(thumbSize);
    
    [self drawInRect:CGRectMake(0, 0, thumbSize.width, thumbSize.height)];
    
    if (watermarkImage) {
        CGFloat imageMaskWidth = watermarkImage.size.width;
        CGFloat imageMaskHeight = watermarkImage.size.height;
        [watermarkImage drawInRect:CGRectMake(thumbSize.width - imageMaskWidth, thumbSize.height - imageMaskHeight, imageMaskWidth, imageMaskHeight)];
    }
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

- (UIImage *)_fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (UIImage *)compressToScale:(float)scale {
    if (scale >= 1) {
        return self;
    }
    
    CGSize imageSize = self.size;
    CGSize scaleImageSize = CGSizeMake(imageSize.width * scale, imageSize.height * scale);
    
    UIGraphicsBeginImageContext(scaleImageSize);
    [self drawInRect:CGRectMake(0, 0, scaleImageSize.width, scaleImageSize.height)];
    UIImage* scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaleImage;
}

- (UIImage *)compressToSize:(CGSize)newSize {
    
    CGSize imageSize = self.size;
    
    if (newSize.width > imageSize.width || newSize.height > imageSize.height) {
        return self;
    }
    
    CGFloat scale = newSize.width / imageSize.height;
    
    return [self compressToScale:scale];
}


@end
