//
//  UICollectionView+SLKit.h
//  Pods
//
//  Created by wyh on 2017/7/7.
//
//

#import <UIKit/UIKit.h>

@interface UICollectionView (SLKit)

- (void)sl_registerNibforCellWithReuseIdentifier:(Class)y_class;

- (void)sl_registerforCellWithReuseIdentifier:(Class)y_class;

- (__kindof UICollectionViewCell *)sl_dequeueReusableCellWithReuseIdentifier:(Class)y_class forIndexPath:(NSIndexPath *)indexPath;

@end
