//
//  SLWebRoute.m
//  Example
//
//  Created by wyh on 2017/11/29.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "SLWebRoute.h"
#import "SLWebCacheCategory.h"
#import "NSString+SLWeb.h"
#import "NSDictionary+SLWeb.h"

@interface SLWebRoute ()

@property (nonatomic, copy) NSString *URIPrefix;

@property (nonatomic, copy) NSDictionary *routeDictionary;


@property (nonatomic, copy) NSString *URIString;

@property (nonatomic, copy) NSDictionary *parameters;

@property (nonatomic, strong) NSURL *URL;

@end

@implementation SLWebRoute

+ (instancetype)shared {
    static SLWebRoute *route = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        route = [[self alloc] init];
    });
    return route;
}

+ (void)updateRoute {
    [SLWebRoute shared].routeDictionary = nil;
}

+ (void)configURIPrefix:(NSString *)URIPrefix {
    [SLWebRoute shared].URIPrefix = URIPrefix;
}

+ (instancetype)routeWithURIString:(NSString *)URIString {
    return [self routeWithURIString:URIString parameters:nil];
}

+ (instancetype)routeWithURIString:(NSString *)URIString parameters:(NSDictionary *)parameters {
    return [[self alloc] initWithURIString:URIString parameters:parameters];
}

- (instancetype)initWithURIString:(NSString *)URIString parameters:(NSDictionary *)parameters {
    self = [super init];
    if (self) {
        _URIString = URIString;
        _parameters = parameters;        
    }
    return self;
}

+ (instancetype)routeWithURL:(NSURL *)URL parameters:(NSDictionary *)parameters {
    return [[self alloc] initWithURL:URL parameters:parameters];
}

- (instancetype)initWithURL:(NSURL *)URL parameters:(NSDictionary *)parameters {
    self = [super init];
    if (self) {
        _URL = URL;
        _parameters = parameters;
    }
    return self;
}

//拼接路由
- (NSString *)splicingRoute:(NSString *)URLString {
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@""];
    NSString *URIEncode = [NSString stringWithFormat:@"uri=%@", [self.URIString stringByAddingPercentEncodingWithAllowedCharacters:set]];
    NSURL *URL = [NSURL URLWithString:URLString];
    
    NSString *query = URL.query ? [NSString stringWithFormat:@"?%@&%@", URL.query, URIEncode] : [NSString stringWithFormat:@"?%@", URIEncode];
    NSString *fragment = URL.fragment ? [@"#" stringByAppendingString:URL.fragment] : @"";
    
    if (URL.isFileURL) {
        URLString = [NSString stringWithFormat:@"%@://%@%@%@", URL.scheme, URL.path, query, fragment];
    }
    else {
        NSString *port = URL.port ? [@":" stringByAppendingString:[URL.port stringValue]] : @"";
        NSString *path = URL.path ? : @"/";
        URLString = [NSString stringWithFormat:@"%@://%@%@%@%@%@", URL.scheme, URL.host, port, path, query, fragment];
    }
    return URLString;
}

#pragma mark - Get

- (NSURL *)URL {
    if (_URL) return _URL;
    //http请求
    if (self.URIString.isHTTP) {
        _URL = [NSURL URLWithString:self.URIString];
    }
    else {
        NSString *URIPrefix = [SLWebRoute shared].URIPrefix;
        if (URIPrefix && ![self.URIString hasPrefix:URIPrefix]) {
            self.URIString = [URIPrefix stringByAppendingString:self.URIString];
        }
        
        //完整的URL或者没有scheme,host的URL
        __block NSString *URLString = [SLWebRoute shared].routeDictionary[self.URIString];
        
        //拼接本地路径
        if (!URLString.isHTTP) {
            URLString = [NSString stringWithFormat:@"file://%@%@", [NSFileManager documentPath], URLString];
        }
        
        //拼接路由
        URLString = [self splicingRoute:URLString];
        
        if ([self isGETRequest:URLString] || !URLString.isHTTP) {
            //http Get && File: 替换入参
            [self.parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                URLString = [URLString stringByReplacingOccurrencesOfString:key withString:obj];
            }];
            self.parameters = nil;
        }
        _URL = [NSURL URLWithString:URLString];
    }
    return _URL;
}

- (BOOL)isGETRequest:(NSString *)URLString {
    __block BOOL isGET = YES;
    [self.parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (![URLString containsString:key]) {
            isGET = NO;
            *stop = YES;
        }
    }];
    return isGET;
}

- (NSMutableURLRequest *)mutableURLRequest {
    if (_mutableURLRequest) return _mutableURLRequest;
    
    _mutableURLRequest = [NSMutableURLRequest requestWithURL:self.URL];
    if (self.parameters) { //POST
        _mutableURLRequest.HTTPMethod = @"POST";
        NSData *HTTPBody = self.parameters.data;
        NSString *contentLength = [NSString stringWithFormat:@"%ld", (unsigned long)HTTPBody.length];
        [_mutableURLRequest setValue:contentLength forHTTPHeaderField:@"Content-Length"];
        [_mutableURLRequest setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        _mutableURLRequest.HTTPBody = HTTPBody;
    }
    return _mutableURLRequest;
}

- (NSDictionary *)routeDictionary {
    if (_routeDictionary) return _routeDictionary;
    
    _routeDictionary = [NSDictionary dictionaryWithContentsOfFile:SLWebRoutePath];
    
    _routeDictionary = @{@"xnph://xnph66.com/rexxar/forgotpwd/sendcode" : @"/pages/rexxar/index.html?timestamp=1510928869805#/forgotpwd/sendcode?userAccount=:userAccount",
                         @"xnph://xnph66.com/rexxar/forgotpwd" : @"/pages/rexxar/index.html?timestamp=1510928869805#/forgotpwd",
                         };
    
    return _routeDictionary;
}

@end
