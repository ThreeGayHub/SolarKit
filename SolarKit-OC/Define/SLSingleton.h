//
//  SLSingleton.h
//  Example
//
//  Created by wyh on 2017/8/3.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#ifndef SLSingleton_h
#define SLSingleton_h

// .h
#define shared_h(class)  + (nullable class *)shared;

// .m
// \ 代表下一行也属于宏
// ## 是分隔符
#define shared_m(class) \
static class *instance; \
\
+ (class *)shared \
{ \
if (instance == nil) { \
instance = [[self alloc] init]; \
} \
return instance; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instance = [super allocWithZone:zone]; \
}); \
return instance; \
}

#endif /* SLSingleton_h */
