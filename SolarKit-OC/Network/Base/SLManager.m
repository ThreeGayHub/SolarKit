//
//  SLManager.m
//  Example
//
//  Created by wyh on 2017/10/18.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "SLManager.h"
#import "SLTarget.h"
#import "SLRequest.h"

@interface SLRequest (SLNetwork_Private)

- (void)configTarget:(SLTarget *)target;

@end

@interface SLManager ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, SLManager *> *managers;

@property (nonatomic, strong) SLTarget *target;

@property (nonatomic, copy) SLManagerReachability change;

@property (nonatomic, strong) NSMutableArray<id<SLPlugin>> *plugins;

@end

@implementation SLManager

#pragma mark - Data

- (NSURLSessionDataTask *)send:(SLRequest *)request complete:(SLManagerComplete)complete fail:(SLManagerFail)fail success:(SLManagerSuccess)success failure:(SLManagerFailure)failure {
    [request configTarget:self.target];
    
    //prepareRequest
    [self.plugins enumerateObjectsUsingBlock:^(id<SLPlugin>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(prepareRequest:)]) {
            [obj prepareRequest:request];
        }
    }];
    
    NSError *serializationError = nil;
    SLHTTPMethod httpMethod = request.httpMethod ?: self.target.httpMethod;
    NSDictionary *methodDict = SLHTTPMethodDictionary();
    NSMutableURLRequest *mutableRequest = [self.requestSerializer requestWithMethod:methodDict[@(httpMethod)] URLString:request.urlString parameters:request.parameters error:&serializationError];
//    if ([YHResponse responseSerializationError:serializationError failure:failure]) {//这是不对的，还有一个failblock没回调
//        return nil;
//    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:mutableRequest
                          uploadProgress:nil
                        downloadProgress:nil
                       completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
//                           [YHResponse responseWithTask:dataTask request:request complete:complete fail:fail success:success failure:failure response:response responseObject:responseObject error:error];
                       }];
    [dataTask resume];
    return dataTask;
}


#pragma mark - Reachability

- (void)observeReachability {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        self.reachabilityStatus = status;
        if (self.change) self.change(status);
        
#if DEBUG
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"\nReachability: unKnown NetWork");
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"\nReachability: no NetWork");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"\nReachability: 2G 3G 4G");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"\nReachability: WiFi");
                break;
        }
#endif
    }];
}

#pragma mark - Set

+ (void)setDefaultManager:(SLTarget *)target {
    SLManager *defaultManager = [self managerWithTarget:target];
    defaultManager.completionQueue = dispatch_queue_create(SLNetworkDefaultCompletionQueueKey, DISPATCH_QUEUE_CONCURRENT);
    [[SLManager shared].managers setObject:defaultManager forKey:SLNetworkDefaultManagerKey];
}

- (void)reachabilityChange:(SLManagerReachability)change {
    self.change = change;
}

- (void)addPlugin:(id<SLPlugin>)plugin, ... {
    va_list args;
    va_start(args, plugin);
    if (plugin) {
        [self.plugins addObject:plugin];
        while (va_arg(args, id<SLPlugin>)) {
            id<SLPlugin> nextPlugin = va_arg(args, id<SLPlugin>);
            [self.plugins addObject:nextPlugin];
        }
    }
    va_end(args);
}

#pragma mark - Get

+ (instancetype)defaultManager {
    return [SLManager shared].managers[SLNetworkDefaultManagerKey];
}

+ (instancetype)customManager:(SLTarget *)target {
    SLManager *customManager;
    if (target.baseURLString.length > 0) {
        customManager = [SLManager defaultManager].managers[target.baseURLString];
        if (!customManager) {
            customManager = [self managerWithTarget:target];
            customManager.completionQueue = dispatch_queue_create(SLNetworkCustomCompletionQueueKey, DISPATCH_QUEUE_CONCURRENT);
            [[SLManager shared].managers setObject:customManager forKey:target.baseURLString];
        }
    }
    return customManager;
}

- (NSMutableDictionary *)managers {
    if (_managers) return _managers;
    
    _managers = [NSMutableDictionary dictionaryWithCapacity:20];
    return _managers;
}

- (NSMutableArray<id<SLPlugin>> *)plugins {
    if (_plugins) return _plugins;
    
    _plugins = [NSMutableArray arrayWithCapacity:20];
    return _plugins;
}

+ (instancetype)shared {
    static SLManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

+ (instancetype)managerWithTarget:(SLTarget *)target {
    SLManager *manager = [[self alloc] initWithBaseURL:[NSURL URLWithString:target.baseURLString] sessionConfiguration:target.configuration];
    manager.target = target;
    [target.headerField enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    return manager;
}

#pragma mark - Init

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (self) {
        [self observeReachability];
    }
    return self;
}

#pragma mark - Quick Method

- (NSURLSessionDataTask *)send:(SLRequest *)request {
    return [self send:request complete:nil];
}

- (NSURLSessionDataTask *)send:(SLRequest *)request complete:(SLManagerComplete)complete {
    return [self send:request complete:complete fail:nil];
}

- (NSURLSessionDataTask *)send:(SLRequest *)request complete:(SLManagerComplete)complete fail:(SLManagerFail)fail {
    return [self send:request complete:complete fail:fail success:nil failure:nil];
}

- (NSURLSessionDataTask *)send:(SLRequest *)request success:(SLManagerSuccess)success {
    return [self send:request success:success failure:nil];
}

- (NSURLSessionDataTask *)send:(SLRequest *)request success:(SLManagerSuccess)success failure:(SLManagerFailure)failure {
    return [self send:request complete:nil fail:nil success:success failure:failure];
}

@end
