//
//  YHRequest.m
//  Neptune
//
//  Created by wyh on 2016/11/7.
//  Copyright © 2016年 NEO Capital. All rights reserved.
//
#import "YHRequest.h"

@interface YHRequest ()

@property (nonatomic, copy) YHModelToPatameters modelToPatameters;
@property (nonatomic, copy) YHParametersEncryption parametersEncryption;
@property (nonatomic, copy) YHJSONSerialization jsonSerialization;
@property (nonatomic, copy) YHResponseDecryption responseDecryption;

@end

@implementation YHRequest

#pragma mark - Init

+ (instancetype)request {
    return [self requestWithUrlString:nil];
}

+ (instancetype)requestWithPath:(NSString *)path {
    return [[self alloc] initWithPath:path];
}

+(instancetype)requestWithUrlString:(NSString *)urlString {
    return [[self alloc] initWithUrlString:urlString];
}

- (instancetype)initWithUrlString:(NSString *)urlString {
    self = [super init];
    if (self) {
        [self loadRequest];
        _urlString = urlString;
    }
    return self;
}

- (instancetype)initWithPath:(NSString *)path {
    self = [super init];
    if (self) {
        [self loadRequest];
        _path = path;
    }
    return self;
}

- (void)loadRequest {
    _method = [YHNetworkConfig shared].requestMethod > YHRequestMethodPOST ? [YHNetworkConfig shared].requestMethod : YHRequestMethodPOST;
    _showLoadingHUD = YES;
    _showSuccessMsg = YES;
    _showFailMsg = YES;
    _customResponseStatusSuccess = -1;
}

#pragma Get

- (NSString *)httpMethod {
    return self.methodDict[@(self.method)];
}

- (NSString *)urlString {
    if (_urlString) return _urlString;
    
    _urlString = [[YHNetworkConfig shared].baseUrlString stringByAppendingPathComponent:self.path];
    return _urlString;
}

- (NSDictionary *)headerField {
    if (!_headerField) {
        _headerField = [YHNetworkConfig shared].headerField;
    }
    if (self.currentSize > 0) {
        NSMutableDictionary *mutableHeaderField = _headerField.mutableCopy;
        [mutableHeaderField setObject:[NSString stringWithFormat:@"bytes=%zd-", self.currentSize] forKey:@"Range"];
        _headerField = mutableHeaderField.copy;
    }
    return _headerField;
}

- (id)parameters {
    id parameters = self.customParameters ?: self.defaultParameters;
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *parametersM = [parameters mutableCopy];
        [parametersM removeObjectsForKeys:self.modelPropertyBlacklist];
        parameters = parametersM;
    }
    YHLog(@"Parameters-%@:\n%@", self.requestID, [parameters description]);
    
    if (self.parametersEncryption) {
        parameters = self.parametersEncryption(parameters);
    }
    else if ([YHNetworkConfig shared].parametersEncryption) {
        parameters = [YHNetworkConfig shared].parametersEncryption(parameters);
    }
    return parameters;
}

- (id)defaultParameters {
    id defaultParameters;
    if (self.modelToPatameters) {
        defaultParameters = self.modelToPatameters(self);
    }
    else if ([YHNetworkConfig shared].modelToPatameters) {
        defaultParameters = [YHNetworkConfig shared].modelToPatameters(self);
    }
    return defaultParameters;
}

- (NSString *)fileName {
    if (_fileName) return _fileName;
    
    _fileName = [YHNetworkConfig shared].fileName;
    return _fileName;
}

- (NSString *)mimeType {
    if (_mimeType) return _mimeType;
    
    _mimeType = [YHNetworkConfig shared].mimeType;
    return _mimeType;
}

//用"_"是因为防止做缓存时"/"引起的错误
- (NSString *)requestID {
    if (_requestID) return _requestID;
    
    if (self.urlString) {
        NSArray<NSString *> *array = [self.urlString componentsSeparatedByString:@"/"];
        if (array.count >= 2) {
            _requestID = [NSString stringWithFormat:@"%@_%@", array[array.count - 2], [array lastObject]];
        }
    }
    return _requestID;
}

- (NSDictionary *)methodDict {
    return @{
             @(YHRequestMethodPOST)     : @"POST",
             @(YHRequestMethodGET)      : @"GET",
             @(YHRequestMethodPUT)      : @"PUT",
             @(YHRequestMethodDELETE)   : @"DELETE",
             @(YHRequestMethodHEAD)     : @"HEAD",
             @(YHRequestMethodPATCH)    : @"PATCH",
             };
}

- (NSString *)responseStatusKey {
    return self.customResponseStatusKey ? : [YHNetworkConfig shared].responseStatusKey;
}

- (NSInteger)responseStatusSuccess {
    return self.customResponseStatusSuccess >= 0 ? self.customResponseStatusSuccess : [YHNetworkConfig shared].responseStatusSuccess;
}

- (NSString *)responseMessageKey {
    return self.customResponseMessageKey ? : [YHNetworkConfig shared].responseMessageKey;
}

- (NSString *)responseBodyKey {
    return self.customResponseBodyKey ? : [YHNetworkConfig shared].responseBodyKey;
}

- (NSString *)downloadFilePath {
    NSString *defaultDownloadPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:YHNetworkingKey];
    if ([self touchPath:defaultDownloadPath]) {
        return self.customDownloadFilePath ? : [defaultDownloadPath stringByAppendingPathComponent:self.requestID];
    }
    return nil;
}

- (NSInteger)currentSize {
    NSInteger currentSize = [self fileLengthForPath:self.downloadFilePath];
    return currentSize > 0 ? currentSize : 0;
}

- (void)modelToPatameters:(YHModelToPatameters)modelToPatameters {
    _modelToPatameters = modelToPatameters;
}

- (void)parametersEncryption:(YHParametersEncryption)parametersEncryption {
    _parametersEncryption = parametersEncryption;
}

- (void)jsonSerialization:(YHJSONSerialization)jsonSerialization {
    _jsonSerialization = jsonSerialization;
}

- (void)responseDecryption:(YHResponseDecryption)responseDecryption {
    _responseDecryption = responseDecryption;
}

- (NSArray *)modelPropertyBlacklist {
    return @[
             @"requestID",
             @"method",
             @"path",
             @"urlString",
             @"headerField",
             @"customParameters",
             @"formDataDict",
             @"fileName",
             @"mimeType",
             @"showSuccessMsg",
             @"showFailMsg",
             @"showLoadingHUD",
             @"customResponseStatusKey",
             @"customResponseStatusSuccess",
             @"customResponseMessageKey",
             @"customResponseBodyKey",
             @"customDownloadPath",
             @"currentSize",
             @"fileSize",
             ];
}

/**
 * 获取已下载的文件大小
 */
- (NSInteger)fileLengthForPath:(NSString *)path {
    NSInteger fileLength = 0;
    NSFileManager *fileManager = [[NSFileManager alloc] init]; // default is not thread safe
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileLength = [fileDict fileSize];
        }
    }
    return fileLength;
}

- (BOOL)touchPath:(NSString *)path {
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:path] )
    {
        return [[NSFileManager defaultManager] createDirectoryAtPath:path
                                         withIntermediateDirectories:YES
                                                          attributes:nil
                                                               error:NULL];
    }
    return YES;
}

@end
