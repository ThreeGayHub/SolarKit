//
//  YHRequest.h
//  Neptune
//
//  Created by wyh on 2016/11/7.
//  Copyright © 2016年 NEO Capital. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHNetworkConfig.h"
#import "AFNetworking.h"

@interface YHRequest : NSObject

//子类用
+ (nullable instancetype)request;

//父类用
+ (nullable instancetype)requestWithPath:(nullable NSString *)path;
+ (nullable instancetype)requestWithUrlString:(nullable NSString *)urlString;

/**
 *  子类重写
 *  配置接口名: path
 */
- (void)loadRequest;

/**
 *  接口名
 *  example: @"login"
 */
@property (nonatomic, copy, nullable) NSString *path;

/**
 *  urlString
 *  urlString including path
 *  example: @"http://www.apple.com:8080/myPrefix/login"
 */
@property (nonatomic, copy, nullable) NSString *urlString;

/**
 *  请求方法
 *  default:POST
 */
@property (nonatomic, assign) YHRequestMethod method;

/**
 *  标识
 */
@property (nonatomic, copy, nullable)NSString *requestID;

/**
 *  showLoadingHUD
 *  default:YES
 */
@property (nonatomic, assign, getter=isShowLoadingHUD) BOOL showLoadingHUD;

/**
 *  showSuccessMsg
 *  default:YES
 */
@property (nonatomic, assign, getter=isShowSuccessMsg) BOOL showSuccessMsg;

/**
 *  isShowFailMsg
 *  default:YES
 */
@property (nonatomic, assign, getter=isShowFailMsg) BOOL showFailMsg;

/**
 *  Custom HttpHeader
 */
@property (nonatomic, copy, nullable) NSDictionary *headerField;

/**
 *  formDataDict
 */
@property (nonatomic, copy, nullable) NSDictionary *formDataDict;

/**
 *  fileName
 */
@property (nonatomic, copy, nullable) NSString *fileName;

/**
 *  mimeType
 */
@property (nonatomic, copy, nullable) NSString *mimeType;

@property (nonatomic, readonly, nullable) NSString *httpMethod;

@property (nonatomic, readonly, nullable) NSString *responseStatusKey;

@property (nonatomic, readonly) NSInteger responseStatusSuccess;

@property (nonatomic, readonly, nullable) NSString *responseMessageKey;

@property (nonatomic, readonly, nullable) NSString *responseBodyKey;

@property (nonatomic, readonly, nullable) NSString *downloadFilePath;

/**
 *  请求参数
 */
- (nullable id)parameters;


//////////////////////应付个别接口和大多数接口不同的情况//////////////////////

/**
 *  Custom HttpBody
 */
@property (nonatomic, strong, nullable) id customParameters;

@property (nonatomic, strong, nullable) AFHTTPRequestSerializer *customRequestSerializer;

@property (nonatomic, strong, nullable) AFHTTPResponseSerializer *customResponseSerializer;

@property (nonatomic, copy, nullable) NSString *customResponseStatusKey;

@property (nonatomic, assign) NSInteger customResponseStatusSuccess;

@property (nonatomic, copy, nullable) NSString *customResponseMessageKey;

@property (nonatomic, copy, nullable) NSString *customResponseBodyKey;

@property (nonatomic, copy, nullable) NSString *customDownloadFilePath;

/** 文件的总大小 */
@property (nonatomic, assign) NSInteger fileSize;
/** 当前下载大小 */
@property (nonatomic, assign) NSInteger currentSize;
/** 文件句柄对象 */
@property (nonatomic, strong, nullable) NSFileHandle *fileHandle;

@property (nonatomic, readonly, nullable) YHModelToPatameters modelToPatameters;
@property (nonatomic, readonly, nullable) YHParametersEncryption parametersEncryption;
@property (nonatomic, readonly, nullable) YHJSONSerialization jsonSerialization;
@property (nonatomic, readonly, nullable) YHResponseDecryption responseDecryption;

- (void)modelToPatameters:(nullable YHModelToPatameters)modelToPatameters;
- (void)parametersEncryption:(nullable YHParametersEncryption)parametersEncryption;
- (void)jsonSerialization:(nullable YHJSONSerialization)jsonSerialization;
- (void)responseDecryption:(nullable YHResponseDecryption)responseDecryption;

/**
 *  规范限制:这个类不要用这两个个创建方法
 */
- (nullable instancetype)init UNAVAILABLE_ATTRIBUTE;
- (nullable instancetype)new UNAVAILABLE_ATTRIBUTE;

@end
