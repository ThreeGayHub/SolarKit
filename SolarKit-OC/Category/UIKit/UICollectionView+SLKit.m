//
//  UICollectionView+SLKit.m
//  Pods
//
//  Created by wyh on 2017/7/7.
//
//

#import "UICollectionView+SLKit.h"

@implementation UICollectionView (SLKit)

- (void)sl_registerNibforCellWithReuseIdentifier:(Class)sl_class {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(sl_class) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass(sl_class)];
}

- (void)sl_registerforCellWithReuseIdentifier:(Class)sl_class {
    [self registerClass:sl_class forCellWithReuseIdentifier:NSStringFromClass(sl_class)];
}

- (UICollectionViewCell *)sl_dequeueReusableCellWithReuseIdentifier:(Class)sl_class forIndexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableCellWithReuseIdentifier:NSStringFromClass(sl_class) forIndexPath:indexPath];
}

- (void)sl_registerNibForSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(Class)sl_class {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(sl_class) bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass(sl_class)];
}

- (void)sl_registerClassForSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(Class)sl_class {
    [self registerClass:sl_class forSupplementaryViewOfKind:elementKind withReuseIdentifier:NSStringFromClass(sl_class)];
}

- (UICollectionReusableView *)sl_dequeueReusableSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(Class)sl_class forIndexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableSupplementaryViewOfKind:elementKind withReuseIdentifier:NSStringFromClass(sl_class) forIndexPath:indexPath];
}

@end
