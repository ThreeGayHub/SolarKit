//
//  SLRequest.h
//  Example
//
//  Created by wyh on 2017/10/20.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLNetworkConstant.h"
@class SLFormData;
@class SLTarget;

@interface SLRequest : NSObject

/**
 init

 e.g.:  SLRequest *request = [SLRequest request];
 @return instance of Subclass
 */
+ (nullable instancetype)request;

/**
 init
 
 e.g.:  SLRequest *request = [SLRequest requestWithPath:@"account/login"];
 @param path name of path
 @return instance of SLRequest
 */
+ (nullable instancetype)requestWithPath:(nullable NSString *)path;

/**
 init
 
 e.g.:  SLRequest *request = [SLRequest requestWithUrlString:@"http://127.0.0.1:8080/account/login..."];
 @param urlString full path
 @return instance of SLRequest
 */
+ (nullable instancetype)requestWithUrlString:(nullable NSString *)urlString;

/**
 子类重写后配置自定义参数
 Subclass overrides configure custom parameters.
 
 e.g.:  path, httpMethod, urlString...
 */
- (void)loadRequest;

/**
 httpMethod:    HTTP方法(HTTP Method)
 
 def:           POST
 */
@property (nonatomic, assign) SLHTTPMethod httpMethod;

/**
 path:   接口名(name of path)
 
 e.g.:   @"account/login"
 */
@property (nonatomic, copy, nullable) NSString *path;

/**
 urlString:     完整路径(full path)
 
 e.g.:          @"scheme://host:port/path..." @"http://127.0.0.1:8080/account/login..."
 */
@property (nonatomic, copy, nullable) NSString *urlString;

/**
 parameters:    The parameters to be encoded according to the client request serializer.(请求参数)
 
 e.g.:          @{@"userName" : @"customerName", @"password" : @"******"}
 */
@property (nonatomic, strong, nullable) id parameters;

/**
 requestID:     标识(ID of request's instance)
 
 def:           base64String of self.urlString
 */
@property (nonatomic, copy, nullable)NSString *requestID;

/**
 headerField:   custom headerField
 
 */
@property (nonatomic, copy, nullable) NSDictionary *headerField;

@property (nonatomic, weak, nullable) SLTarget *target;

/**
 showLoadingHUD
 
 def:       YES
 */
@property (nonatomic, assign, getter=isShowLoadingHUD) BOOL showLoadingHUD;

/**
 showSuccessHUD
 
 def:       NO
 */
@property (nonatomic, assign, getter=isShowSuccessHUD) BOOL showSuccessHUD;

/**
 showFailHUD
 
 def:       YES
 */
@property (nonatomic, assign, getter=isShowFailHUD) BOOL showFailHUD;





/**
 formDataArray: upload by formData
 
 af:    appendPartWithFileData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType
 e.g.:  [request.formDataArray addObject:slFormData];
 */
@property (nonatomic, copy, nullable) NSMutableArray <SLFormData *> *formDataArray;


- (void)appendPartWithFilePath:(nullable NSString *)filePath name:(nullable NSString *)name fileName:(nullable NSString *)fileName mimeType:(nullable NSString *)mimeType;

- (void)appendPartWithInputStream:(nullable NSInputStream *)inputStream name:(nullable NSString *)name fileName:(nullable NSString *)fileName mimeType:(nullable NSString *)mimeType;

- (void)appendPartWithData:(nullable NSString *)data name:(nullable NSString *)name fileName:(nullable NSString *)fileName mimeType:(nullable NSString *)mimeType;

/**
 *  规范限制:这个类不要用这两个个创建方法
 */
- (nullable instancetype)init UNAVAILABLE_ATTRIBUTE;
- (nullable instancetype)new UNAVAILABLE_ATTRIBUTE;


@end

@interface SLFormData : NSObject

+ (nullable instancetype)formDataWithFilePath:(nullable NSString *)filePath name:(nullable NSString *)name fileName:(nullable NSString *)fileName mimeType:(nullable NSString *)mimeType;

+ (nullable instancetype)formDataWithInputStream:(nullable NSInputStream *)inputStream name:(nullable NSString *)name fileName:(nullable NSString *)fileName mimeType:(nullable NSString *)mimeType;

+ (nullable instancetype)formDataWithData:(nullable NSData *)data name:(nullable NSString *)name fileName:(nullable NSString *)fileName mimeType:(nullable NSString *)mimeType;


@property (nonatomic, readonly, nullable) NSURL *FileURL;

@property (nonatomic, readonly, nullable) NSInputStream *inputStream;

@property (nonatomic, readonly, nullable) NSData *data;

@property (nonatomic, readonly, nullable) NSString *name;

@property (nonatomic, readonly, nullable) NSString *fileName;

@property (nonatomic, readonly, nullable) NSString *mimeType;

@end


