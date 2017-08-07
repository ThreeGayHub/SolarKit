//
//  NSTimer+SLBlock.h
//  Pods
//
//  Created by wyh on 2017/7/27.
//
//

#import <Foundation/Foundation.h>

@interface NSTimer (SLBlock)

+ (instancetype)singleTimerWithInterval:(NSTimeInterval)seconds block:(void (^)(void))block;

+ (instancetype)repeaticTimerWithInterval:(NSTimeInterval)seconds block:(void (^)(void))block;

+ (instancetype)countdownTimerWithInterval:(NSTimeInterval)seconds times:(NSTimeInterval)totalSeconds block:(void (^)(NSTimeInterval leftSeconds))block;

+ (void)throttle:(NSTimeInterval)seconds block:(void (^)(void))block;

+ (void)throttle:(NSTimeInterval)seconds key:(NSString *)key block:(void (^)(void))block;

- (void)start;

- (void)stop;

@end
