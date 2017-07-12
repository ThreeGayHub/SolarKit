//
//  UICollectionView+SLKit.h
//  Pods
//
//  Created by wyh on 2017/7/7.
//
//

#import <UIKit/UIKit.h>

@interface UICollectionView (SLKit)

- (void)sl_registerNibforCellWithReuseIdentifier:(Class)sl_class;

- (void)sl_registerforCellWithReuseIdentifier:(Class)sl_class;

- (__kindof UICollectionViewCell *)sl_dequeueReusableCellWithReuseIdentifier:(Class)sl_class forIndexPath:(NSIndexPath *)indexPath;


- (void)sl_registerNibForSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(Class)sl_class;

- (void)sl_registerClassForSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(Class)sl_class ;

- (__kindof UICollectionReusableView *)sl_dequeueReusableSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(Class)sl_class forIndexPath:(NSIndexPath *)indexPath;

@end
