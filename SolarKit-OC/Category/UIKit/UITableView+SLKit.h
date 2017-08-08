//
//  UITableView+SLKit.h
//  Example
//
//  Created by wyh on 2017/8/8.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (SLKit)

- (void)registerCellWithClass:(Class)clazz;

- (void)registerNibCellWithClass:(Class)clazz;

- (__kindof UITableViewCell *)dequeueReusableCellWithClass:(Class)clazz forIndexPath:(NSIndexPath *)indexPath;

- (void)registerHeaderFooterViewWithClass:(Class)clazz;

- (void)registerNibHeaderFooterViewWithClass:(Class)clazz;

- (__kindof UITableViewHeaderFooterView *)dequeueReusableHeaderFooterViewWithClass:(Class)clazz;

- (void)setEmptyTableFooterView;

@end
