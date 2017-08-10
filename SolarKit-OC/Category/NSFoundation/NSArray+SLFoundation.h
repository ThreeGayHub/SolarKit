//
//  NSArray+NSArray_SLFoundation.h
//  Example
//
//  Created by renegade on 2017/8/3.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SLFoundation)

- (id)randomItem;

- (NSArray *)scrambled;

- (NSArray *)reversed;

- (NSArray *)sorted;

- (NSArray *)sortedCaseInsensitive;

- (NSArray *)uniqueElements;

- (NSArray *)unionWithArray: (NSArray *) anArray;

- (NSArray *)intersectionWithArray: (NSArray *) anArray;

- (NSArray *)differenceToArray: (NSArray *) anArray;

#pragma mark - Lisp

- (NSArray *)each:(void (^)(id obj))block;

- (NSArray *)eachWithIndex:(void (^)(id obj, NSUInteger idx))block;

- (NSArray *)map:(id (^)(id object))block;

- (NSArray *)filter:(BOOL (^)(id object))block;

- (NSArray *)reject:(BOOL (^)(id object))block;

- (id)detect:(BOOL (^)(id object))block;

- (id)reduce:(id (^)(id accumulator, id object))block;

- (id)reduce:(id)initial withBlock:(id (^)(id accumulator, id object))block;

@end
