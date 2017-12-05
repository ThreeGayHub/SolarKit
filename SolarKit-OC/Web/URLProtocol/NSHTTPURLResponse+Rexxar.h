//
//  NSHTTPURLResponse+SLWeb.h
//  SLWeb
//
//  Created by XueMing on 03/03/2017.
//  Copyright © 2017 Douban.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSHTTPURLResponse (SLWeb)

/**
 Returns a new http response. If `noAccessControl` = YES, set CORS disabled.
 */
+ (nullable instancetype)responseWithURL:(NSURL *)url
                                  statusCode:(NSInteger)statusCode
                                headerFields:(nullable NSDictionary<NSString *, NSString *> *)headerFields
                             noAccessControl:(BOOL)noAccessControl;

@end

NS_ASSUME_NONNULL_END
