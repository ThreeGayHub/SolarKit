//
//  SLMediator.m
//  Example
//
//  Created by wyh on 2017/9/25.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "SLMediator.h"

@interface SLMediator ()

@property (nonatomic, strong) NSMutableDictionary *cachedTarget;

@end

@implementation SLMediator

+ (instancetype)shared {
    static SLMediator *mediator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[SLMediator alloc] init];
    });
    return mediator;
}

- (id)call:(NSURL *)url completion:(void (^)(NSDictionary *))completion {
    
    if (url.host && url.path) {
        NSString *path = [url.host stringByAppendingString:url.path];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        for (NSString *param in [url.query componentsSeparatedByString:@"&"]) {
            NSArray *elts = [param componentsSeparatedByString:@"="];
            if([elts count] < 2) continue;
            [parameters setObject:elts.lastObject forKey:elts.firstObject];
        }
        
        // 这里这么写主要是出于安全考虑，防止黑客通过远程方式调用本地模块。这里的做法足以应对绝大多数场景，如果要求更加严苛，也可以做更加复杂的安全逻辑。
        NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
        if ([actionName hasPrefix:@"native"]) {
            return @(NO);
        }
        
        return [self call:path parameters:parameters completion:completion];
    }
    return @(NO);
    
}

- (id)call:(NSString *)path parameters:(NSDictionary *)parameters completion:(void (^)(NSDictionary *))completion {
    
    NSArray *array = [path componentsSeparatedByString:@"/"];
    if (array.count == 2) {
        NSString *targetClassString = array.firstObject;
        NSString *actionString = array.lastObject;
        
        Class targetClass;
        NSObject *target = self.cachedTarget[targetClassString];
        if (!target) {
            targetClass = NSClassFromString(targetClassString);
            target = [[targetClass alloc] init];
            if (!target) {
                NSLog(@"error: no target!");
                return nil;
            }
        }
        
        if (parameters || completion) {
            actionString = [actionString stringByAppendingString:@":"];
        }
        SEL action = NSSelectorFromString(actionString);

        NSMutableDictionary *mParameters = parameters.mutableCopy;
        if (completion) {
            if (!mParameters) {
                mParameters = [NSMutableDictionary dictionary];
            }
            [mParameters setObject:completion forKey:@"completion"];
        }
        
        
        if ([target respondsToSelector:action]) {
            self.cachedTarget[targetClassString] = target;
            return [self safePerformAction:action target:target params:mParameters];
        }
        else {
            NSLog(@"error: no action!");
        }
    }
    return nil;
}

#pragma mark - private methods
- (id)safePerformAction:(SEL)action target:(NSObject *)target params:(NSDictionary *)params
{
    NSMethodSignature* methodSig = [target methodSignatureForSelector:action];
    if(methodSig == nil) {
        return nil;
    }
    const char* retType = [methodSig methodReturnType];
    
    if (strcmp(retType, @encode(void)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        return nil;
    }
    
    if (strcmp(retType, @encode(NSInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(BOOL)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(CGFloat)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(NSUInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
}

- (void)removeCacheWithUrl:(NSURL *)url {
    [self.cachedTarget removeObjectForKey:url.host];
}

- (void)removeCacheWithPath:(NSString *)path {
    NSArray *array = [path componentsSeparatedByString:@"/"];
    if (array.count == 2) {
        [self.cachedTarget removeObjectForKey:array.firstObject];
    }
}

- (NSMutableDictionary *)cachedTarget {
    if (_cachedTarget) return _cachedTarget;
    
    _cachedTarget = [NSMutableDictionary dictionary];
    return _cachedTarget;
}

@end
