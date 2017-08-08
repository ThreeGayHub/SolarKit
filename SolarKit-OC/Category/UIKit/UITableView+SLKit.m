//
//  UITableView+SLKit.m
//  Example
//
//  Created by wyh on 2017/8/8.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "UITableView+SLKit.h"

@implementation UITableView (SLKit)

- (void)registerCellWithClass:(Class)clazz {
    [self registerClass:clazz forCellReuseIdentifier:NSStringFromClass(clazz)];
}

- (void)registerNibCellWithClass:(Class)clazz {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(clazz) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass(clazz)];
}

- (UITableViewCell *)dequeueReusableCellWithClass:(Class)clazz forIndexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableCellWithIdentifier:NSStringFromClass(clazz) forIndexPath:indexPath];
}

- (void)registerHeaderFooterViewWithClass:(Class)clazz {
    [self registerClass:clazz forHeaderFooterViewReuseIdentifier:NSStringFromClass(clazz)];
}

- (void)registerNibHeaderFooterViewWithClass:(Class)clazz {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(clazz) bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:NSStringFromClass(clazz)];
}

- (UITableViewHeaderFooterView *)dequeueReusableHeaderFooterViewWithClass:(Class)clazz {
    return [self dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(clazz)];
}

- (void)setEmptyTableFooterView {
    self.tableFooterView = [[UIView alloc] init];
}

@end
