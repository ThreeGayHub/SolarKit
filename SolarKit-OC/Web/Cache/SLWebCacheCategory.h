//
//  SLWebCacheCategory.h
//  Example
//
//  Created by wyh on 2017/11/28.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SLWebUpdateJsonBundlePath            [SLWebConstDictionary()[SLWebUpdateJsonKey] pathInBundle]
#define SLWebFullPackageBundlePath           [SLWebConstDictionary()[SLWebFullPackageKey] pathInBundle]
#define SLWebResourceBundlePath              [SLWebConstDictionary()[SLWebResourceKey] pathInBundle]

#define SLWebUpdateJsonDocumentPath          [SLWebConstDictionary()[SLWebUpdateJsonKey] pathInDocument]
#define SLWebFullPackageDocumentPath         [SLWebConstDictionary()[SLWebFullPackageKey] pathInDocument]
#define SLWebResourceDocumentPath            [SLWebConstDictionary()[SLWebResourceKey] pathInDocument]

#define SLWebIncreasePackageDocumentPath     [SLWebIncreasePackageName pathInDocument]
#define SLWebIncreaseWebResourceDocumentPath [SLWebIncreaseWebResourceName pathInDocument]
#define SLWebFileJsonPath                    [SLWebResourceDocumentPath stringByAppendingPathComponent:SLWebFileJsonName]
#define SLWebRoutePath                       [SLWebResourceDocumentPath stringByAppendingPathComponent:SLWebRouteName]

extern NSString * const SLWebUpdateJsonKey;
extern NSString * const SLWebFullPackageKey;
extern NSString * const SLWebResourceKey;

extern NSString * const SLWebIncreasePackageName;
extern NSString * const SLWebIncreaseWebResourceName;
extern NSString * const SLWebFileJsonName;
extern NSString * const SLWebRouteName;

extern NSString * const SLWebFullPackageMD5Key;
extern NSString * const SLWebIncreasePackageMD5Key;

NSMutableDictionary * SLWebConstDictionary();

typedef NS_ENUM(NSInteger, SLWebError) {
    SLWebErrorInterpolation = -10086, //资源被篡改
    SLWebErrorDocumentFail,
};

extern NSString * const SLWebErrorDomain;

NSDictionary * SLWebErrorDictionary();

@interface NSFileManager (SLWebCache)

+ (NSString *)documentPath;

//文件或路径是否存在
+ (BOOL)fileExistsAtPath:(NSString *)path;

+ (BOOL)removeFileAtPath:(NSString *)path;

+ (BOOL)createPath:(NSString *)path;

//覆盖文件
+ (BOOL)moveItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath;

+ (BOOL)mergePath:(NSString *)srcPath toPath:(NSString *)dstPath;

+ (BOOL)isFileOfPath:(NSString *)path;

+ (BOOL)copyItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath;

@end

@interface NSData (SLWebCache)

//32位 小写
@property (nonatomic, readonly) NSString *MD5;

@property (nonatomic, readonly) NSDictionary *dict;

@end

@interface NSDictionary (SLWebCache)

@property (nonatomic, readonly) NSData *data;

@end

@interface NSString (SLWebCache)

@property (nonatomic, readonly) NSString *MD5OfPath;

@property (nonatomic, readonly) NSDictionary *dictOfPath;

@property (nonatomic, readonly) NSData *dataOfPath;

@property (nonatomic, readonly) NSString *pathInDocument;

@property (nonatomic, readonly) NSString *pathInBundle;

@end

@interface NSUserDefaults (SLWebCache)

+ (BOOL)isNewAppVerson;

@end

@interface NSDate (SLWebCache)

@property (nonatomic, readonly) NSString *timestamp;

@end

@interface NSError (SLWebCache)

+ (instancetype)errorWithCode:(NSInteger)code;

@end
