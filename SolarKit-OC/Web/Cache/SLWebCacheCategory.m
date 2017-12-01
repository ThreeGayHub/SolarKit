//
//  SLWebCacheCategory.m
//  Example
//
//  Created by wyh on 2017/11/28.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "SLWebCacheCategory.h"
#import <MobileCoreServices/UTType.h>

NSString * const SLWebUpdateJsonKey = @"SLWebUpdateJsonKey";
NSString * const SLWebFullPackageKey = @"SLWebFullPackageKey";
NSString * const SLWebResourceKey = @"SLWebResourceKey";

NSString * const SLWebIncreasePackageName = @"Increase.zip";
NSString * const SLWebIncreaseWebResourceName = @"Increase";
NSString * const SLWebFileJsonName = @"file.json";
NSString * const SLWebRouteName = @"route.json";


NSString * const SLWebFullPackageMD5Key = @"FullPackageMD5Key";
NSString * const SLWebIncreasePackageMD5Key = @"IncreasePackageMD5Key";
static NSString * const SLWebAppVersionKey = @"SLWebAppVersionKey";


NSMutableDictionary * SLWebConstDictionary() {
    static NSMutableDictionary *webConstDictionary;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        webConstDictionary = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                SLWebUpdateJsonKey : @"update.json",
                                                                                SLWebFullPackageKey : @"Full.zip",
                                                                                SLWebResourceKey : @"pages",
                                                                                }];
    });
    return webConstDictionary;
}

NSString * const SLWebErrorDomain = @"com.solar.SLWeb";

NSDictionary * SLWebErrorDictionary() {
    static NSDictionary *webErrorDictionary;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        webErrorDictionary = @{
                                  @(SLWebErrorInterpolation) : @"资源被篡改，为了您的资金安全，请删除应用重新下载",
                                  @(SLWebErrorDocumentFail) : @"资源更新失败，请稍后重试",
                                  
                                  };
    });
    return webErrorDictionary;
}

@implementation NSFileManager (SLWebCache)

+ (NSString *)documentPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (BOOL)moveItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath {
    if ([NSFileManager fileExistsAtPath:dstPath]) {
        [NSFileManager removeFileAtPath:dstPath];
    }
    BOOL result = NO;
    NSError * error = nil;
    result = [[NSFileManager defaultManager] moveItemAtPath:srcPath toPath:dstPath error:&error];
    if (error)
    {
        result = NO;
    }
    return result;
}

+ (BOOL)fileExistsAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (BOOL)removeFileAtPath:(NSString *)path {
    BOOL result = NO;
    NSError * error = nil;
    result = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    if (error)
    {
        result = NO;
    }
    return result;
}

+ (BOOL)createPath:(NSString *)path {
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:path] )
    {
        return [[NSFileManager defaultManager] createDirectoryAtPath:path
                                         withIntermediateDirectories:YES
                                                          attributes:nil
                                                               error:NULL];
    }
    return YES;
}

+ (BOOL)mergePath:(NSString *)srcPath toPath:(NSString *)dstPath {
    __block BOOL result = YES;
    NSArray<NSString *> *filesPath = [[NSFileManager defaultManager] subpathsAtPath:srcPath];
    [filesPath enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *srcItemPath = [srcPath stringByAppendingPathComponent:obj];
        NSString *dstItemPath = [dstPath stringByAppendingPathComponent:obj];
        if ([NSFileManager isFileOfPath:srcItemPath]) {
            result = [NSFileManager moveItemAtPath:srcItemPath toPath:dstItemPath];
        }
        //是路径则创建路径
        else {
            result = [NSFileManager createPath:dstItemPath];
        }
        if (!result) {
            *stop = YES;
        }
    }];
    [NSFileManager removeFileAtPath:srcPath];
    return result;
}

+ (BOOL)isFileOfPath:(NSString *)path {
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[path pathExtension], NULL);
        CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
        CFRelease(UTI);
        if (MIMEType) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)copyItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath {
    if ([NSFileManager fileExistsAtPath:dstPath]) {
        [NSFileManager removeFileAtPath:dstPath];
    }
    BOOL result = NO;
    NSError * error = nil;
    result = [[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:dstPath error:nil];
    if (error)
    {
        result = NO;
    }
    return result;
}

@end

#import <CommonCrypto/CommonCrypto.h>

@implementation NSData (SLWebCache)

- (NSString *)MD5 {
    
    unsigned char *digest;
    digest = malloc(CC_MD5_DIGEST_LENGTH);
    
    CC_MD5([self bytes], (CC_LONG)[self length], digest);
    NSData *md5Data = [NSData dataWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
    free(digest);
    
    if (md5Data.length == 0) { return nil; }
    
    static const char HexEncodeCharsLower[] = "0123456789abcdef";
    
    char *resultData;
    // malloc result data
    resultData = malloc([md5Data length] * 2 +1);
    // convert imgData(NSData) to char[]
    unsigned char *sourceData = ((unsigned char *)[md5Data bytes]);
    NSUInteger length = [md5Data length];
    
    for (NSUInteger index = 0; index < length; index++) {
        // set result data
        resultData[index * 2] = HexEncodeCharsLower[(sourceData[index] >> 4)];
        resultData[index * 2 + 1] = HexEncodeCharsLower[(sourceData[index] % 0x10)];
    }
    resultData[[md5Data length] * 2] = 0;
    
    // convert result(char[]) to NSString
    NSString *result = [NSString stringWithCString:resultData encoding:NSASCIIStringEncoding];
    sourceData = nil;
    free(resultData);
    
    return result;
}

- (NSDictionary *)dict {
    return [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:nil];
}

@end

@implementation NSDictionary (SLWebCache)

- (NSData *)data {
    return [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
}

@end

@implementation NSString (SLWebCache)

- (NSString *)MD5OfPath {
    return self.dataOfPath.MD5;
}

- (NSDictionary *)dictOfPath {
    NSData *data = self.dataOfPath;
    return data ? [NSJSONSerialization JSONObjectWithData:self.dataOfPath options:NSJSONReadingMutableContainers error:nil] : nil;
}

- (NSData *)dataOfPath {
    return [NSData dataWithContentsOfFile:self];
}

- (NSString *)pathInDocument {
    return [[NSFileManager documentPath] stringByAppendingPathComponent:self];
}

- (NSString *)pathInBundle {
    return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:self];
}

- (NSString *)timestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timeInterval = [date timeIntervalSince1970] * 1000;
    return [NSString stringWithFormat:@"%.f", timeInterval];
}

@end

@implementation NSUserDefaults (SLWebCache)

+ (BOOL)isNewAppVerson {
    NSString *appVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    if (![[[NSUserDefaults standardUserDefaults] stringForKey:SLWebAppVersionKey] isEqualToString:appVersion]) {
        [[NSUserDefaults standardUserDefaults] setObject:appVersion forKey:SLWebAppVersionKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
    return NO;
}

@end

@implementation NSDate (SLWebCache)

- (NSString *)timestamp {
    NSTimeInterval timeInterval = [self timeIntervalSince1970] * 1000;
    return [NSString stringWithFormat:@"%.f", timeInterval];
}

@end

@implementation NSError (SLWebCache)

+ (instancetype)errorWithCode:(NSInteger)code {
    return [NSError errorWithDomain:SLWebErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey : SLWebErrorDictionary()[@(code)]}];
}

@end
