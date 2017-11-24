//
//  YHManager.m
//  Neptune
//
//  Created by wyh on 2016/11/7.
//  Copyright © 2016年 NEO Capital. All rights reserved.
//

#import "YHManager.h"
#import "YHRequest.h"
#import "YHResponse.h"

@interface YHManager ()

@property (nonatomic, copy)YHUploadGlobalComplete uploadGlobalComplete;
@property (nonatomic, copy)YHUploadGlobalFail uploadGlobalFail;
@property (nonatomic, copy)YHUploadGlobalProgress uploadGlobalProgress;

@property (nonatomic, copy)YHDownloadGlobalComplete downloadGlobalComplete;
@property (nonatomic, copy)YHDownloadGlobalFail downloadGlobalFail;
@property (nonatomic, copy)YHDownloadGlobalProgress downloadGlobalProgress;

@end

@implementation YHManager

#pragma mark - Init

+ (instancetype)shared {
    static YHManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (![YHNetworkConfig shared].baseUrlString) {
            YHLog(@"Error-Don't forget to set baseUrlString!");
        }
        shared = [[self alloc] initWithBaseURL:[NSURL URLWithString:[YHNetworkConfig shared].baseUrlString] sessionConfiguration:[YHNetworkConfig shared].sessionConfiguration];
        shared.completionQueue = dispatch_queue_create("com.wyh.YHNetworking.CompletionQueue", DISPATCH_QUEUE_CONCURRENT);
    });
    return shared;
}

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (self) {
        [self observeReachability];
    }
    return self;
}

- (void)configHttps:(AFSSLPinningMode)pinningMode {
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:pinningMode];
    self.securityPolicy = securityPolicy;
}

#pragma mark - Data

- (NSURLSessionDataTask *)send:(YHRequest *)request complete:(YHManagerComplete)complete fail:(YHManagerFail)fail success:(YHManagerSuccess)success failure:(YHManagerFailure)failure {
    
    if ([YHNetworkConfig shared].globalLoading)
        [YHNetworkConfig shared].globalLoading(request.isShowLoadingHUD);
    
    [self setHeaderField:request.headerField];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *mutableRequest = [self.requestSerializer requestWithMethod:request.httpMethod URLString:request.urlString parameters:request.parameters error:&serializationError];
    if ([YHResponse responseSerializationError:serializationError failure:failure]) {
        return nil;
    }

    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:mutableRequest
                          uploadProgress:nil
                        downloadProgress:nil
                       completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                           [YHResponse responseWithTask:dataTask request:request complete:complete fail:fail success:success failure:failure response:response responseObject:responseObject error:error];
                       }];
    [dataTask resume];
    return dataTask;
}

#pragma mark - Upload

- (NSURLSessionUploadTask *)upload:(YHRequest *)request progress:(YHManagerProgress)progress complete:(YHManagerComplete)complete fail:(YHManagerFail)fail success:(nullable YHManagerSuccess)success failure:(nullable YHManagerFailure)failure {
    if ([YHNetworkConfig shared].globalLoading)
        [YHNetworkConfig shared].globalLoading(request.isShowLoadingHUD);
    
    [self setHeaderField:request.headerField];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *mutableRequest = [self.requestSerializer multipartFormRequestWithMethod:request.httpMethod URLString:request.urlString parameters:request.parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [request.formDataDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [formData appendPartWithFileData:obj name:key fileName:request.fileName mimeType:request.mimeType];
        }];
    } error:&serializationError];
    if ([YHResponse responseSerializationError:serializationError failure:failure]) {
        return nil;
    }
    
    __block NSURLSessionUploadTask *uploadTask = nil;
    uploadTask = [self uploadTaskWithStreamedRequest:mutableRequest progress:^(NSProgress * _Nonnull uploadProgress) {
        // This is not called back on the main queue.
        dispatch_async(dispatch_get_main_queue(), ^{
            float persent = (float)uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
            if (progress) {
                progress(persent);
            }
            if (self.uploadGlobalProgress) {
                self.uploadGlobalProgress(request.requestID, persent);
            }
            YHLog(@"%.2f", persent);
        });
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [YHResponse responseWithTask:uploadTask request:request complete:complete fail:fail success:success failure:failure response:response responseObject:responseObject error:error];
    }];
    [uploadTask resume];
    return uploadTask;
}

#pragma mark - Download

- (NSURLSessionDataTask *)download:(YHRequest *)request progress:(YHManagerProgress)progress complete:(YHManagerComplete)complete fail:(YHManagerFail)fail success:(nullable YHManagerSuccess)success failure:(nullable YHManagerFailure)failure {
    if ([YHNetworkConfig shared].globalLoading)
        [YHNetworkConfig shared].globalLoading(request.isShowLoadingHUD);
    
    [self setHeaderField:request.headerField];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *mutableRequest = [self.requestSerializer requestWithMethod:request.httpMethod URLString:request.urlString parameters:request.parameters error:&serializationError];
    if ([YHResponse responseSerializationError:serializationError failure:failure]) {
        return nil;
    }
    
//    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:request.urlString]];
    
    __block NSURLSessionDataTask *downloadTask = nil;
    downloadTask = [self dataTaskWithRequest:mutableRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        request.fileSize = 0;
        request.currentSize = 0;
        
        [request.fileHandle closeFile];
        request.fileHandle = nil;
        
        [YHResponse responseWithTask:downloadTask request:request complete:complete fail:fail success:success failure:failure response:response responseObject:responseObject error:error];
    }];
    
    __weak typeof(self) weakSelf = self;
    [self setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSURLResponse * _Nonnull response) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        // 获得下载文件的总长度：请求下载的文件长度 + 当前已经下载的文件长度
        request.fileSize = response.expectedContentLength + request.currentSize;
        
        if ([strongSelf touchFile:request.downloadFilePath]) {
            request.fileHandle = [NSFileHandle fileHandleForWritingAtPath:request.downloadFilePath];
            // 允许处理服务器的响应，才会继续接收服务器返回的数据
            return NSURLSessionResponseAllow;
        }
        return NSURLSessionResponseCancel;
    }];
    
    [self setDataTaskDidReceiveDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSData * _Nonnull data) {
        // 指定数据的写入位置 -- 文件内容的最后面
        [request.fileHandle seekToEndOfFile];
        // 向沙盒写入数据
        [request.fileHandle writeData:data];
        // 拼接文件总长度
        request.currentSize += data.length;
        // 获取主线程，不然无法正确显示进度。
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            float persent = (float)request.currentSize / request.fileSize;
            if (progress) {
                progress(persent);
            }
            if (strongSelf.uploadGlobalProgress) {
                strongSelf.uploadGlobalProgress(request.requestID, persent);
            }
            YHLog(@"%.2f", persent);
        });
    }];
    
    [downloadTask resume];
    return downloadTask;
}

#pragma mark - QuickMethod

- (NSURLSessionDataTask *)send:(YHRequest *)request {
    return [self send:request complete:nil];
}

- (NSURLSessionDataTask *)send:(YHRequest *)request complete:(YHManagerComplete)complete {
    return [self send:request complete:complete fail:nil];
}

- (NSURLSessionDataTask *)send:(YHRequest *)request complete:(YHManagerComplete)complete fail:(YHManagerFail)fail {
    return [self send:request complete:complete fail:fail success:nil failure:nil];
}

- (NSURLSessionDataTask *)send:(YHRequest *)request success:(YHManagerSuccess)success {
    return [self send:request success:success failure:nil];
}

- (NSURLSessionDataTask *)send:(YHRequest *)request success:(YHManagerSuccess)success failure:(YHManagerFailure)failure {
    return [self send:request complete:nil fail:nil success:success failure:failure];
}

- (NSURLSessionUploadTask *)upload:(YHRequest *)request {
    return [self upload:request progress:nil];
}

- (NSURLSessionUploadTask *)upload:(YHRequest *)request progress:(YHManagerProgress)progress {
    return [self upload:request progress:progress complete:nil];
}

- (NSURLSessionUploadTask *)upload:(YHRequest *)request progress:(YHManagerProgress)progress complete:(YHManagerComplete)complete {
    return [self upload:request progress:progress complete:complete fail:nil];
}

- (NSURLSessionUploadTask *)upload:(YHRequest *)request progress:(YHManagerProgress)progress complete:(YHManagerComplete)complete fail:(YHManagerFail)fail {
    return [self upload:request progress:progress complete:complete fail:fail success:nil failure:nil];
}

- (NSURLSessionUploadTask *)upload:(YHRequest *)request progress:(YHManagerProgress)progress success:(YHManagerSuccess)success {
    return [self upload:request progress:progress success:success failure:nil];
}

- (NSURLSessionUploadTask *)upload:(YHRequest *)request progress:(YHManagerProgress)progress success:(YHManagerSuccess)success failure:(nullable YHManagerFailure)failure {
    return [self upload:request progress:progress complete:nil fail:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)download:(YHRequest *)request {
    return [self download:request progress:nil];
}

- (NSURLSessionDataTask *)download:(YHRequest *)request progress:(YHManagerProgress)progress {
    return [self download:request progress:progress complete:nil];
}

- (NSURLSessionDataTask *)download:(YHRequest *)request progress:(YHManagerProgress)progress complete:(YHManagerComplete)complete {
    return [self download:request progress:progress complete:complete fail:nil];
}

- (NSURLSessionDataTask *)download:(YHRequest *)request progress:(YHManagerProgress)progress complete:(YHManagerComplete)complete fail:(YHManagerFail)fail {
    return [self download:request progress:progress complete:complete fail:fail success:nil failure:nil];
}

- (NSURLSessionDataTask *)download:(YHRequest *)request progress:(YHManagerProgress)progress success:(YHManagerSuccess)success {
    return [self download:request progress:progress success:success failure:nil];
}

- (NSURLSessionDataTask *)download:(YHRequest *)request progress:(YHManagerProgress)progress success:(YHManagerSuccess)success failure:(nullable YHManagerFailure)failure {
    return [self download:request progress:progress complete:nil fail:nil success:success failure:failure];
}

#pragma mark - Set

- (YHManager *)uploadGlobalComplete:(YHUploadGlobalComplete)uploadGlobalComplete {
    _uploadGlobalComplete = uploadGlobalComplete;
    return self;
}

- (YHManager *)uploadGlobalFail:(YHUploadGlobalFail)uploadGlobalFail {
    _uploadGlobalFail = uploadGlobalFail;
    return self;
}

- (YHManager *)uploadGlobalProgress:(YHUploadGlobalProgress)uploadGlobalProgress {
    _uploadGlobalProgress = uploadGlobalProgress;
    return self;
}

- (YHManager *)downloadGlobalComplete:(YHDownloadGlobalComplete)downloadGlobalComplete {
    _downloadGlobalComplete = downloadGlobalComplete;
    return self;
}

- (YHManager *)downloadGlobalFail:(YHDownloadGlobalFail)downloadGlobalFail {
    _downloadGlobalFail = downloadGlobalFail;
    return self;
}

- (YHManager *)downloadGlobalProgress:(YHDownloadGlobalProgress)downloadGlobalProgress {
    _downloadGlobalProgress = downloadGlobalProgress;
    return self;
}

- (void)setHeaderField:(NSDictionary *)headerField {
    [headerField enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
}

#pragma mark - Reachability

- (void)observeReachability {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        self.reachabilityStatus = status;
#if DEBUG
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                YHLog(@"unKnown NetWork");
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                YHLog(@"no NetWork");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                YHLog(@"2G 3G 4G");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                YHLog(@"WiFi");
                break;
        }
#endif
    }];
}



- (BOOL)touchFile:(NSString *)file {
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:file] )
    {
        return [[NSFileManager defaultManager] createFileAtPath:file
                                                       contents:[NSData data]
                                                     attributes:nil];
    }
    return YES;
}

@end
