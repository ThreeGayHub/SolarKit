//
//  SLRequest.m
//  Example
//
//  Created by wyh on 2017/10/20.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "SLRequest.h"
#import "SLTarget.h"

@implementation SLRequest

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
    _showLoadingHUD = YES;
    _showSuccessHUD = NO;
    _showFailHUD = YES;
}

#pragma mark - Set

- (void)configTarget:(SLTarget *)target {
    if (self.httpMethod == SLHTTPMethodNONE) {
        self.httpMethod = target.httpMethod;
    }
    
    if (!self.urlString && self.path) {
        self.urlString = [target.baseURLString stringByAppendingString:self.path];
    }
}

- (void)setParameters:(id)parameters {
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mParameters = [parameters mutableCopy];
        [mParameters removeObjectsForKeys:[self modelPropertyBlacklist]];
        _parameters = [mParameters copy];
    }
    else {
        _parameters = parameters;
    }
}

#pragma mark - Get

- (NSString *)requestID {
    if (_requestID) return _requestID;
    
    _requestID = [[self.urlString dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return _requestID;
}

- (NSMutableArray<SLFormData *> *)formDataArray {
    if (_formDataArray) return _formDataArray;
    
    _formDataArray = [NSMutableArray arrayWithCapacity:20];
    return _formDataArray;
}

- (NSArray *)modelPropertyBlacklist {
    return @[
             @"httpMethod",
             @"path",
             @"urlString",
             @"parameters",
             @"requestID",
             @"headerField",
             @"showSuccessHUD",
             @"showFailHUD",
             @"showLoadingHUD",
             
             //             @"formDataDict",
             //             @"fileName",
             //             @"mimeType",
             //             @"customResponseStatusKey",
             //             @"customResponseStatusSuccess",
             //             @"customResponseMessageKey",
             //             @"customResponseBodyKey",
             //             @"customDownloadPath",
             //             @"currentSize",
             //             @"fileSize",
             ];
}

@end

@implementation SLFormData

+ (instancetype)formData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType {
    return [[self alloc] initWithData:data name:name fileName:fileName mimeType:mimeType];
}

- (instancetype)initWithData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType
{
    self = [super init];
    if (self) {
        _data = data;
        _name = name;
        _fileName = fileName;
        _mimeType = mimeType;
    }
    return self;
}

@end

