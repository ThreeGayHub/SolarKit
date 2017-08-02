//
//  UICollectionView+SLKit.m
//  Pods
//
//  Created by wyh on 2017/7/7.
//
//

#import "UICollectionView+SLKit.h"

@implementation UICollectionView (SLKit)

- (void)registerNibforCellWithClass:(Class)clazz {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(clazz) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass(clazz)];
}

- (void)registerforCellWithClass:(Class)clazz {
    [self registerClass:clazz forCellWithReuseIdentifier:NSStringFromClass(clazz)];
}

- (UICollectionViewCell *)dequeueReusableCellWithClass:(Class)clazz forIndexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableCellWithReuseIdentifier:NSStringFromClass(clazz) forIndexPath:indexPath];
}

- (void)registerNibForSupplementaryViewOfKind:(NSString *)kind withClass:(Class)clazz {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(clazz) bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass(clazz)];
}

- (void)registerClassForSupplementaryViewOfKind:(NSString *)elementKind withClass:(Class)clazz {
    [self registerClass:clazz forSupplementaryViewOfKind:elementKind withReuseIdentifier:NSStringFromClass(clazz)];
}

- (UICollectionReusableView *)dequeueReusableSupplementaryViewOfKind:(NSString *)elementKind withClass:(Class)clazz forIndexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableSupplementaryViewOfKind:elementKind withReuseIdentifier:NSStringFromClass(clazz) forIndexPath:indexPath];
}

@end
