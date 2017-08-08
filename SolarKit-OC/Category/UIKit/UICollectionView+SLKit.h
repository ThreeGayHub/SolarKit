//
//  UICollectionView+SLKit.h
//  Pods
//
//  Created by wyh on 2017/7/7.
//
//

#import <UIKit/UIKit.h>

@interface UICollectionView (SLKit)

- (void)registerCellWithClass:(Class)clazz;

- (void)registerNibCellWithClass:(Class)clazz;

- (__kindof UICollectionViewCell *)dequeueReusableCellWithClass:(Class)clazz forIndexPath:(NSIndexPath *)indexPath;


- (void)registerNibForSupplementaryViewOfKind:(NSString *)kind withClass:(Class)clazz;

- (void)registerClassForSupplementaryViewOfKind:(NSString *)elementKind withClass:(Class)clazz;

- (__kindof UICollectionReusableView *)dequeueReusableSupplementaryViewOfKind:(NSString *)elementKind withClass:(Class)clazz forIndexPath:(NSIndexPath *)indexPath;

@end
