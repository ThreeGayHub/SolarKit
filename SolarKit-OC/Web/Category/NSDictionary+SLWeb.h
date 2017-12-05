//
//  NSDictionary+SLWeb.h
//  Example
//
//  Created by wyh on 2017/11/29.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SLWeb)

@property (nonatomic, readonly) NSData *data;

@property (nonatomic, readonly) NSString *jsonString;

/**
 * 字典对应关键字的元素，该元素如果是数组，返回数组的首个元素。
 *
 * Return the first item of array for the specificed key.
 * -[NSDictionary objectForKey:] will return an object or an array depending on how the NSDictionary is created.
 *
 * @param key 关键字
 */
- (id)itemForKey:(id)key;

/**
 * 字典对应该关键字的元素，该元素如果是数组，返回该数组。
 *
 * Return a NSArray object which contains all the items for specificed key.
 * -[NSDictionary objectForKey:] will return an object or an array depending on how the NSDictionary is created.
 *
 * @param key 关键字
 */
- (NSArray *)allItemsForKey:(id)key;

@end

@interface NSMutableDictionary (SLWeb)

/**
 * 在字典以关键字添加一个元素。
 *
 * @param item 待添加的元素
 * @param key 关键字
 */
- (void)addItem:(id)item forKey:(id<NSCopying>)key;

@end
