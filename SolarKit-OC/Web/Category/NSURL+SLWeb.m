//
//  NSURL+SLWeb.m
//  SLWeb
//
//  Created by GUO Lin on 1/18/16.
//  Copyright © 2016 Douban.Inc. All rights reserved.
//

#import "NSURL+SLWeb.h"
#import "NSString+SLWeb.h"

@implementation NSURL (SLWeb)

+ (NSString *)queryFromDictionary:(NSDictionary *)dict
{
  NSMutableArray *pairs = [NSMutableArray array];
  [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
    [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
  }];

  NSString *query = nil;
  if (pairs.count > 0) {
    query = [pairs componentsJoinedByString:@"&"];
  }
  return query;
}

- (BOOL)isHttpOrHttps
{
  if ([self.scheme caseInsensitiveCompare:@"http"] == NSOrderedSame ||
      [self.scheme caseInsensitiveCompare:@"https"] == NSOrderedSame) {
    return YES;
  }
  return NO;
}

- (NSDictionary *)queryDictionary {
    return self.query.queryDictionary;
}

@end
