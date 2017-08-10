//
//  NSArray+NSArray_SLFoundation.m
//  Example
//
//  Created by renegade on 2017/8/3.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "NSArray+SLFoundation.h"

@implementation NSArray (SLFoundation)

- (id)randomItem
{
    if (!self.count) return nil;
    
    static BOOL seeded = NO;
    if (!seeded) {seeded = YES; srandom((unsigned int) time(0));}
    
    NSUInteger whichItem = (NSUInteger)(random() % self.count);
    return self[whichItem];
}

- (NSArray *)scrambled
{
    static BOOL seeded = NO;
    if (!seeded) {seeded = YES; srandom((unsigned int) time(0));}
    
    NSMutableArray *resultArray = [self mutableCopy];
    for (int i = 0; i < (self.count - 2); i++)
        [resultArray exchangeObjectAtIndex:i withObjectAtIndex:(i + (random() % (self.count - i)))];
    return resultArray.copy;
}

- (NSArray *)reversed
{
    return [[self reverseObjectEnumerator] allObjects];
}

- (NSArray *)sorted
{
    NSArray *resultArray = [self sortedArrayUsingComparator:
                            ^(id obj1, id obj2){return [obj1 compare:obj2];}];
    return resultArray;
}

- (NSArray *)sortedCaseInsensitive
{
    NSArray *resultArray = [self sortedArrayUsingComparator:
                            ^(id obj1, id obj2){return [obj1 caseInsensitiveCompare:obj2];}];
    return resultArray;
}

- (NSArray *)uniqueElements
{
    return [NSOrderedSet orderedSetWithArray:self].array.copy;
}

- (NSArray *)unionWithArray: (NSArray *) anArray
{
    NSMutableOrderedSet *set1 = [NSMutableOrderedSet orderedSetWithArray:self];
    NSMutableOrderedSet *set2 = [NSMutableOrderedSet orderedSetWithArray:anArray];
    
    [set1 unionOrderedSet:set2];
    
    return set1.array.copy;
}

- (NSArray *)intersectionWithArray: (NSArray *) anArray
{
    NSMutableOrderedSet *set1 = [NSMutableOrderedSet orderedSetWithArray:self];
    NSMutableOrderedSet *set2 = [NSMutableOrderedSet orderedSetWithArray:anArray];
    
    [set1 intersectOrderedSet:set2];
    
    return set1.array.copy;
}

- (NSArray *)differenceToArray: (NSArray *) anArray
{
    NSMutableOrderedSet *set1 = [NSMutableOrderedSet orderedSetWithArray:self];
    NSMutableOrderedSet *set2 = [NSMutableOrderedSet orderedSetWithArray:anArray];
    
    [set1 minusOrderedSet:set2];
    
    return set1.array.copy;
}

#pragma mark - Lisp

- (NSArray *)each:(void (^)(id obj))block {
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj);
    }];
    return self;
}

- (NSArray *)eachWithIndex:(void (^)(id obj, NSUInteger idx))block {
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj, idx);
    }];
    return self;
}

- (NSArray *)map:(id (^)(id object))block {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    
    for (id object in self) {
        [array addObject:block(object) ?: [NSNull null]];
    }
    
    return array;
}

- (NSArray *)filter:(BOOL (^)(id object))block {
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return block(evaluatedObject);
    }]];
}

- (NSArray *)reject:(BOOL (^)(id object))block {
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return !block(evaluatedObject);
    }]];
}

- (id)detect:(BOOL (^)(id object))block {
    for (id object in self) {
        if (block(object))
            return object;
    }
    return nil;
}

- (id)reduce:(id (^)(id accumulator, id object))block {
    return [self reduce:nil withBlock:block];
}

- (id)reduce:(id)initial withBlock:(id (^)(id accumulator, id object))block {
    id accumulator = initial;
    
    for(id object in self)
        accumulator = accumulator ? block(accumulator, object) : object;
    
    return accumulator;
}

@end
