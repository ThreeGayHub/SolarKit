//
//  UICollectionView+SLKit.m
//  Pods
//
//  Created by wyh on 2017/7/7.
//
//

#import "UICollectionView+SLKit.h"

@implementation UICollectionView (SLKit)

- (void)sl_registerNibforCellWithReuseIdentifier:(Class)y_class {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(y_class) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass(y_class)];
}

- (void)sl_registerforCellWithReuseIdentifier:(Class)y_class {
    [self registerClass:y_class forCellWithReuseIdentifier:NSStringFromClass(y_class)];
}

- (UICollectionViewCell *)sl_dequeueReusableCellWithReuseIdentifier:(Class)y_class forIndexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableCellWithReuseIdentifier:NSStringFromClass(y_class) forIndexPath:indexPath];
}

@end
