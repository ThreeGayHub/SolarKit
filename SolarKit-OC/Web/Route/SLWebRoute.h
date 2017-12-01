//
//  SLWebRoute.h
//  Example
//
//  Created by wyh on 2017/11/29.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLWebRoute : NSObject

+ (void)configURIPrefix:(NSString *)URIPrefix;

+ (void)updateRoute;

+ (instancetype)routeWithURIString:(NSString *)URIString;

+ (instancetype)routeWithURIString:(NSString *)URIString parameters:(NSDictionary *)parameters;

+ (instancetype)routeWithURL:(NSURL *)URL parameters:(NSDictionary *)parameters;

@property (nonatomic, readonly) NSString *URIString;

@property (nonatomic, readonly) NSDictionary *parameters;

@property (nonatomic, readonly) NSURL *URL;

@property (nonatomic, readonly) NSMutableURLRequest *mutableURLRequest;

@end
