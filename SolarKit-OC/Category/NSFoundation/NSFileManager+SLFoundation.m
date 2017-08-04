//
//  NSFileManager+SLFoundation.m
//  Pods
//
//  Created by wyh on 2017/8/2.
//
//

#import "NSFileManager+SLFoundation.h"
#import <MobileCoreServices/UTType.h>

@implementation NSFileManager (SLFoundation)

+ (NSString *)documentPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)cachePath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0];
}

+ (BOOL)isExistsAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (BOOL)createPath:(NSString *)path {
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return [[NSFileManager defaultManager] createDirectoryAtPath:path
                                         withIntermediateDirectories:YES
                                                          attributes:nil
                                                               error:NULL];
    }
    return YES;
}

+ (BOOL)createFile:(NSString *)file {
    if (![[NSFileManager defaultManager] fileExistsAtPath:file]) {
        return [[NSFileManager defaultManager] createFileAtPath:file
                                                       contents:[NSData data]
                                                     attributes:nil];
    }
    return YES;
}

+ (BOOL)removePath:(NSString *)path {
    BOOL result = NO;
    NSError *error = nil;
    result = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    if (error) {
        result = NO;
    }
    return result;
}

+ (BOOL)removeSubFileAtPath:(NSString *)path {
    BOOL result = YES;
    NSArray *files = [[NSFileManager defaultManager ] subpathsAtPath:path];
    for ( NSString * p in files) {
        NSError * error = nil ;
        //获取文件全路径
        NSString * fileAbsolutePath = [path stringByAppendingPathComponent:p];
        if ([[NSFileManager defaultManager ] fileExistsAtPath:fileAbsolutePath]) {
            result = [[NSFileManager defaultManager ] removeItemAtPath:fileAbsolutePath error:&error];
            if (!result || error) {
                result = NO;
                break;
            }
        }
    }
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

+ (BOOL)copyPath:(NSString *)srcPath toPath:(NSString *)dstPath {
    if ([NSFileManager isExistsAtPath:dstPath]) {
        [NSFileManager removePath:dstPath];
    }
    BOOL result = NO;
    NSError * error = nil;
    result = [[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:dstPath error:nil];
    if (error) {
        result = NO;
    }
    return result;
}

+ (BOOL)cutPath:(NSString *)srcPath toPath:(NSString *)dstPath {
    if ([NSFileManager isExistsAtPath:dstPath]) {
        [NSFileManager removePath:dstPath];
    }
    BOOL result = NO;
    NSError * error = nil;
    result = [[NSFileManager defaultManager] moveItemAtPath:srcPath toPath:dstPath error:&error];
    if (error) {
        result = NO;
    }
    return result;
}

+ (BOOL)mergePath:(NSString *)srcPath toPath:(NSString *)dstPath {
    __block BOOL result = YES;
    NSArray<NSString *> *filesPath = [[NSFileManager defaultManager] subpathsAtPath:srcPath];
    [filesPath enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *srcItemPath = [srcPath stringByAppendingPathComponent:obj];
        NSString *dstItemPath = [dstPath stringByAppendingPathComponent:obj];
        if ([NSFileManager isFileOfPath:srcItemPath]) {
            result = [NSFileManager cutPath:srcItemPath toPath:dstItemPath];
        }
        else {
            result = [NSFileManager createPath:dstItemPath];
        }
        if (!result) {
            *stop = YES;
        }
    }];
    [NSFileManager removePath:srcPath];
    return result;
}

+ (float)sizeOfPath:(NSString *)path {
    if (![NSFileManager isExistsAtPath:path])
        return 0 ;
    
    NSEnumerator *childFilesEnumerator = [[[NSFileManager defaultManager] subpathsAtPath:path] objectEnumerator];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        //获取文件全路径
        NSString *fileAbsolutePath = [path stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize / (1024.0 * 1024.0);
}

// 计算单个文件的大小
+ (long long)fileSizeAtPath:(NSString *)path {
    if ([NSFileManager isExistsAtPath:path]) {
        return [[[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil] fileSize];
    }
    return 0;
}


@end
