//
//  NSTimer+SLBlock.m
//  Pods
//
//  Created by wyh on 2017/7/27.
//
//

#import "NSTimer+SLBlock.h"
#import <objc/runtime.h>

@interface NSTimer (SLTimer_Private)

@property (nonatomic, assign) NSTimeInterval leftSeconds;

@end

@implementation NSTimer (SLBlock)

+ (instancetype)singleTimerWithInterval:(NSTimeInterval)seconds block:(void (^)(void))block {
    return [NSTimer timerWithTimeInterval:seconds target:self selector:@selector(onTimer:) userInfo:block repeats:NO];
}

+ (instancetype)repeaticTimerWithInterval:(NSTimeInterval)seconds block:(void (^)(void))block {
    return [NSTimer timerWithTimeInterval:seconds target:self selector:@selector(onTimer:) userInfo:block repeats:YES];
}

+ (instancetype)countdownTimerWithInterval:(NSTimeInterval)seconds times:(NSTimeInterval)totalSeconds block:(void (^)(NSTimeInterval))block {
    NSTimer *timer = [NSTimer timerWithTimeInterval:seconds target:self selector:@selector(onCountdownTimer:) userInfo:block repeats:YES];
    timer.leftSeconds = totalSeconds;
    return timer;
}

+ (void)throttle:(NSTimeInterval)seconds block:(void (^)(void))block {
    [self throttle:seconds key:@"SLThrottle" block:block];
}

+ (void)throttle:(NSTimeInterval)seconds key:(NSString *)key block:(void (^)(void))block {
    if ([self.throttleDictionary.allKeys containsObject:key]) {
        NSTimer *timer = self.throttleDictionary[key];
        if (timer) {
            [self.throttleDictionary removeObjectForKey:key];
            [timer invalidate];
        }
    }
    NSTimer *timer = [NSTimer timerWithTimeInterval:seconds target:self selector:@selector(onThrottleTimer:) userInfo:@{@"block" : block, @"key" : key} repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [self.throttleDictionary setObject:timer forKey:key];
}

+ (void)onTimer:(NSTimer *)timer {
    if([timer userInfo]) {
        void (^block)(void) = (void (^)(void))[timer userInfo];
        block();
    }
}

+ (void)onCountdownTimer:(NSTimer *)timer {
    if([timer userInfo]) {
        void (^block)(NSTimeInterval) = (void (^)(NSTimeInterval))[timer userInfo];
        block(timer.leftSeconds--);
    }
}

+ (void)onThrottleTimer:(NSTimer *)timer {
    NSDictionary *userInfoDict = [timer userInfo];
    if(userInfoDict) {
        void (^block)(void) = (void (^)(void))userInfoDict[@"block"];
        block();
    }
    if ([self.throttleDictionary.allKeys containsObject:userInfoDict[@"key"]]) {
        [self.throttleDictionary removeObjectForKey:userInfoDict[@"key"]];
    }
}

- (void)start {
    [[NSRunLoop mainRunLoop] addTimer:self forMode:NSRunLoopCommonModes];
}

- (void)stop {
    [self invalidate];
}

- (void)setLeftSeconds:(NSTimeInterval)leftSeconds {
    objc_setAssociatedObject(self, @selector(leftSeconds), @(leftSeconds), OBJC_ASSOCIATION_ASSIGN);
}

- (NSTimeInterval)leftSeconds {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

+ (NSMutableDictionary *)throttleDictionary {
    static NSMutableDictionary *throttleDictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        throttleDictionary = [NSMutableDictionary dictionary];
    });
    return throttleDictionary;
}

@end
