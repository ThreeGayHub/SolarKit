//
//  NSFileManager+SLFoundation.h
//  Pods
//
//  Created by wyh on 2017/8/2.
//
//

#import <Foundation/Foundation.h>

@interface NSFileManager (SLFoundation)

+ (NSString *)documentPath;

+ (NSString *)cachePath;

+ (BOOL)isExistsAtPath:(NSString *)path;

+ (BOOL)createPath:(NSString *)path;

+ (BOOL)createFile:(NSString *)file;

//这个路径移除
+ (BOOL)removePath:(NSString *)path;

//移除路径下文件
+ (BOOL)removeSubFileAtPath:(NSString *)path;

//是否是文件
+ (BOOL)isFileOfPath:(NSString *)path;

+ (BOOL)copyPath:(NSString *)srcPath toPath:(NSString *)dstPath;

+ (BOOL)cutPath:(NSString *)srcPath toPath:(NSString *)dstPath;

+ (BOOL)mergePath:(NSString *)srcPath toPath:(NSString *)dstPath;

/**
 *  遍历文件夹获得文件夹大小，返回多少 M
 */
+ (float)sizeOfPath:(NSString *)path;

@end
