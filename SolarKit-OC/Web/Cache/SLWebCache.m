//
//  SLWebCache.m
//  Example
//
//  Created by wyh on 2017/11/28.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "SLWebCache.h"
#import "SLWebCacheCategory.h"
#import <SSZipArchive/SSZipArchive.h>

@interface SLWebCache ()

@property (nonatomic, copy) SLWebCacheSuccess success;
@property (nonatomic, copy) SLWebCacheFail fail;

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation SLWebCache

+ (void)customUpdateJsonName:(NSString *)updateJsonName fullPackageName:(NSString *)fullPackageName webResorucePathName:(NSString *)webResorucePathName {
    if (![updateJsonName hasSuffix:@".json"]) {
        updateJsonName = [updateJsonName stringByAppendingString:@".json"];
    }
    if (![fullPackageName hasSuffix:@".zip"]) {
        fullPackageName = [fullPackageName stringByAppendingString:@".zip"];
    }
    [SLWebConstDictionary() setObject:updateJsonName forKey:SLWebUpdateJsonKey];
    [SLWebConstDictionary() setObject:fullPackageName forKey:SLWebFullPackageKey];
    [SLWebConstDictionary() setObject:webResorucePathName forKey:SLWebResourceKey];
}

+ (instancetype)shared {
    static SLWebCache *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[SLWebCache alloc] init];
    });
    return shared;
}

- (void)updateWithURLString:(NSString *)URLString success:(SLWebCacheSuccess)success fail:(SLWebCacheFail)fail {
    _success = success;
    _fail = fail;
    if (!URLString.length) return;
    
    if ([NSUserDefaults isNewAppVerson]) {
        //把bundle资源移动到document
        [[NSFileManager defaultManager] copyItemAtPath:SLWebUpdateJsonBundlePath toPath:SLWebUpdateJsonDocumentPath error:nil];
        [[NSFileManager defaultManager] copyItemAtPath:SLWebFullPackageBundlePath toPath:SLWebFullPackageDocumentPath error:nil];
        [[NSFileManager defaultManager] copyItemAtPath:SLWebResourceBundlePath toPath:SLWebResourceDocumentPath error:nil];
        
        NSDictionary *updateDict = SLWebUpdateJsonDocumentPath.dictOfPath;
        if (updateDict) {
            [[NSUserDefaults standardUserDefaults] setObject:updateDict[@"md5"] forKey:SLWebFullPackageMD5Key];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    if (self.isDebug) {
        [NSFileManager removeFileAtPath:SLWebUpdateJsonDocumentPath];
        [NSFileManager removeFileAtPath:SLWebFullPackageDocumentPath];
        [NSFileManager removeFileAtPath:SLWebResourceDocumentPath];
    }
    
    URLString = [NSString stringWithFormat:@"%@?t=%@", URLString, [NSDate date].timestamp];
    
    //0 下载updateJson
    [self downloadUpdateJsonWithURLString:URLString complete:^(NSDictionary *updateJsonDict) {
        //下载updateJson成功
        if (updateJsonDict) {
            //1 本地updateJson是否有效
            if ([self isValidUpdateJson]) {
                //2 是否最新版本
                if ([self isLastVersion:updateJsonDict]) {
                    if ([self isValidLocalFile]) {
                        NSLog(@"最新版本");
                        if (self.success) self.success();
                    }
                    else {//2.1 本地校验不通过
                        [self downloadFullPackageWithUpdateDict:updateJsonDict];
                    }
                }
                else {
                    //3 是否是下载全量包
                    if ([self isDownloadFullPackage:updateJsonDict]) {
                        [self downloadFullPackageWithUpdateDict:updateJsonDict];
                    }
                    else {
                        //4 本地校验通过
                        if ([self isValidLocalFile]) {
                            [self downloadIncreasePackageWithUpdateDict:updateJsonDict];
                        }
                        else {
                            [self downloadFullPackageWithUpdateDict:updateJsonDict];
                        }
                    }
                }
            }
            else {
                [self downloadFullPackageWithUpdateDict:updateJsonDict];
            }
        }
        else {
            [self isValidLocalFile] ? [self documentError] : [self InterpolationError];
        }
    }];
}

- (void)downloadUpdateJsonWithURLString:(NSString *)URLString complete:(void(^)(NSDictionary *updateJsonDict))complete {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:60];
    NSURLSessionDownloadTask *task = [self.session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"UpdateJson下载失败\ncode:%ld\nmessage:%@", error.code, error.localizedDescription);
            if (complete) complete(nil);
        }
        else {
            NSData *updateJsonData = [NSData dataWithContentsOfURL:location];
            NSDictionary *updateJsonDict = updateJsonData.dict;
            if (complete) complete(updateJsonDict);
        }
    }];
    [task resume];
}

- (void)downloadFullPackageWithUpdateDict:(NSDictionary *)updateDict {
    NSString *urlString = updateDict[@"url"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:60];
    NSURLSessionDownloadTask *task = [self.session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"全量包下载失败:\ncode:%ld\nmessage:%@", error.code, error.localizedDescription);
            [self documentError];
        }
        else {
            [self clearCache];
            [updateDict.data writeToFile:SLWebUpdateJsonDocumentPath atomically:YES];
            NSData *data = [NSData dataWithContentsOfURL:location];
            [data writeToFile:SLWebFullPackageDocumentPath atomically:YES];
            [[NSUserDefaults standardUserDefaults] setObject:updateDict[@"md5"] forKey:SLWebFullPackageMD5Key];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if ([self isValidFullPackage]) {
                if ([self unzipFullPackage]) {
                    if ([self isValidLocalFile]) {
                        NSLog(@"全量包通过");
                        if (self.success) self.success();
                    }
                    else {
                        [self InterpolationError];
                    }
                }
                else {
                    NSLog(@"全量包解压失败");
                    [self documentError];
                }
            }
            else {
                [self InterpolationError];
            }
        }
    }];
    [task resume];
}

- (void)downloadIncreasePackageWithUpdateDict:(NSDictionary *)updateDict {
    NSDictionary *nativeUpdateDict = SLWebUpdateJsonDocumentPath.dictOfPath;
    NSString *lastVersion = nativeUpdateDict[@"latestVersionName"];
    NSArray<NSDictionary *> *increasePackages = updateDict[@"data"];
    __block NSString *urlString;
    __block NSString *md5;
    [increasePackages enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[@"versionName"] isEqualToString:lastVersion]) {
            urlString = obj[@"url"];
            md5 = obj[@"md5"];
            *stop = YES;
        }
    }];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:60];
    NSURLSessionDownloadTask *task = [self.session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {//下载失败
            NSLog(@"增量包下载失败:\ncode:%ld\nmessage:%@", error.code, error.localizedDescription);
            [self downloadFullPackageWithUpdateDict:updateDict];
        }
        else {
            [NSFileManager removeFileAtPath:SLWebUpdateJsonDocumentPath];
            [NSFileManager removeFileAtPath:SLWebIncreasePackageDocumentPath];
            [updateDict.data writeToFile:SLWebUpdateJsonDocumentPath atomically:YES];
            NSData *data = [NSData dataWithContentsOfURL:location];
            [data writeToFile:SLWebIncreasePackageDocumentPath atomically:YES];
            [[NSUserDefaults standardUserDefaults] setObject:md5 forKey:SLWebIncreasePackageMD5Key];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if ([self isValidIncreasePackage]) {
                if ([self unzipIncreasePackage] && [NSFileManager mergePath:SLWebIncreaseWebResourceDocumentPath toPath:SLWebResourceDocumentPath] && [self removeOldFile]) {
                    if ([self isValidLocalFile]) {
                        NSLog(@"增量包通过");
                        if (self.success) self.success();
                    }
                    else {//增量包本地校验不通过
                        NSLog(@"增量包本地校验不通过");
                        [self downloadFullPackageWithUpdateDict:updateDict];
                    }
                }
                else {//增量包解压合并不通过
                    NSLog(@"增量包解压合并不通过");
                    [self downloadFullPackageWithUpdateDict:updateDict];
                }
            }
            else {//增量包压缩包校验不通过
                NSLog(@"增量包压缩包校验不通过");
                [self downloadFullPackageWithUpdateDict:updateDict];
            }
        }
    }];
    [task resume];
}

#pragma mark - Error

- (void)documentError {
    if (self.fail) {
        NSError *error = [NSError errorWithCode:SLWebErrorDocumentFail];
        self.fail(error);
    }
}

- (void)InterpolationError {
    if (self.fail) {
        NSError *error = [NSError errorWithCode:SLWebErrorInterpolation];
        self.fail(error);
    }
}


#pragma mark - Valid

- (BOOL)isValidUpdateJson {
    if ([NSFileManager fileExistsAtPath:SLWebUpdateJsonDocumentPath]) {
        NSDictionary *updateDict = SLWebUpdateJsonDocumentPath.dictOfPath;
        if (updateDict[@"latestVersionName"] && updateDict[@"md5"] && updateDict[@"url"] && updateDict[@"updateType"] && updateDict[@"versionCode"]) {
            return YES;
        }
    }
    NSLog(@"UpdateJson不通过");
    return NO;
}

//失败：无updateJson，//无清单文件，//无全量包，//全量包不合法，//资源不合法
- (BOOL)isValidLocalFile {
    if ([self isValidUpdateJson]) {
        if ([self isValidH5Cache]) {
            return YES;
        }
        else {
            if ([self isValidFullPackage] && [self unzipFullPackage]) {
                if ([self isValidIncreasePackage] && [self unzipIncreasePackage] && [NSFileManager mergePath:SLWebIncreaseWebResourceDocumentPath toPath:SLWebResourceDocumentPath] && [self removeOldFile] && [self isValidH5Cache]) {
                    return YES;
                }
                else {
                    if ([self isValidH5Cache]) {
                        return YES;
                    }
                }
            }
        }
    }
    [self clearCache];
    NSLog(@"本地校验不通过，清除H5缓存");
    return NO;
}

- (BOOL)isValidH5Cache {
    __block BOOL result = NO;
    if ([NSFileManager fileExistsAtPath:SLWebResourceDocumentPath] && [NSFileManager fileExistsAtPath:SLWebFileJsonPath]) {
        NSDictionary *fileDict = SLWebFileJsonPath.dictOfPath;
        NSDictionary<NSString *, NSString *> *md5Map = fileDict[@"md5Map"];
        if (md5Map) {
            result = YES;
        }
        [md5Map enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            NSString *h5ResourcePath = [SLWebResourceDocumentPath stringByAppendingPathComponent:obj];
            if (![h5ResourcePath.MD5OfPath isEqualToString:key]) {
                result = NO;
                NSLog(@"MD校验不通过%@ - %@, webMD5:%@", h5ResourcePath, h5ResourcePath.MD5OfPath, key);
                *stop = YES;
            }
        }];
    }
    else {
        NSLog(@"H5路径不存在或file.json不存在");
    }
    return result;
}

//每次下载全量包后，记录包的MD5
- (BOOL)isValidFullPackage {
    if ([NSFileManager fileExistsAtPath:SLWebFullPackageDocumentPath]) {
        NSString *FullPackageMD5 = [[NSUserDefaults standardUserDefaults] stringForKey:SLWebFullPackageMD5Key];
        NSString *md5OfFile = SLWebFullPackageDocumentPath.MD5OfPath;
        if ([FullPackageMD5 isEqualToString:md5OfFile]) {
            return YES;
        }
        NSLog(@"全量包被篡改");
    }
    else {
        NSLog(@"全量包不存在");
    }
    return NO;
}

//每次下载增量包后，记录包的MD5
- (BOOL)isValidIncreasePackage {
    if ([NSFileManager fileExistsAtPath:SLWebIncreasePackageDocumentPath]) {
        NSString *FullPackageMD5 = [[NSUserDefaults standardUserDefaults] stringForKey:SLWebIncreasePackageMD5Key];
        if ([FullPackageMD5 isEqualToString:SLWebIncreasePackageDocumentPath.MD5OfPath]) {
            return YES;
        }
        NSLog(@"增量包被篡改");
//        [self uploadBugly];
    }
    NSLog(@"增量包不存在");
    return NO;
}

- (BOOL)isLastVersion:(NSDictionary *)remoteUpdateDict {
    NSDictionary *nativeUpdateDict = SLWebUpdateJsonDocumentPath.dictOfPath;
    if ([remoteUpdateDict[@"versionCode"] integerValue] == [nativeUpdateDict[@"versionCode"] integerValue]) {
        return YES;
    }
    return NO;
}

- (BOOL)isDownloadFullPackage:(NSDictionary *)remoteUpdateDict {
    NSDictionary *nativeUpdateDict = SLWebUpdateJsonDocumentPath.dictOfPath;
    if ([remoteUpdateDict[@"updateType"] integerValue] == 1 && [remoteUpdateDict[@"versionCode"] integerValue] - [nativeUpdateDict[@"versionCode"] integerValue] == 1) {
        return NO;
    }
    return YES;
}

#pragma mark - Action

- (BOOL)removeOldFile {
    NSDictionary *fileDict = SLWebFileJsonPath.dictOfPath;
    NSDictionary<NSString *, NSString *> *pathMap = fileDict[@"pathMap"];
    NSArray<NSString *> *filesPath = [[NSFileManager defaultManager] subpathsAtPath:SLWebResourceDocumentPath];
    [filesPath enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *path = [SLWebResourceDocumentPath stringByAppendingPathComponent:obj];
        if ([NSFileManager isFileOfPath:path]) {
            if (!pathMap[obj] && ![obj isEqualToString:@"file.json"]) {
                [NSFileManager removeFileAtPath:path];
            }
        }
    }];
    return YES;
}

- (BOOL)unzipFullPackage {
    return [SSZipArchive unzipFileAtPath:SLWebFullPackageDocumentPath toDestination:SLWebResourceDocumentPath overwrite:YES password:nil error:nil];
}

- (BOOL)unzipIncreasePackage {
    return [SSZipArchive unzipFileAtPath:SLWebIncreasePackageDocumentPath toDestination:SLWebIncreaseWebResourceDocumentPath overwrite:YES password:nil error:nil];
}

- (void)clearCache {
    [NSFileManager removeFileAtPath:SLWebUpdateJsonDocumentPath];
    [NSFileManager removeFileAtPath:SLWebFullPackageDocumentPath];
    [NSFileManager removeFileAtPath:SLWebIncreasePackageDocumentPath];
    [NSFileManager removeFileAtPath:SLWebIncreaseWebResourceDocumentPath];
}

#pragma mark - Get

- (NSURLSession *)session {
    if (_session) return _session;
    
    NSURLSessionConfiguration *sessionCfg = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:sessionCfg
                                             delegate:nil
                                        delegateQueue:[[NSOperationQueue alloc] init]];
    return _session;
}

@end
