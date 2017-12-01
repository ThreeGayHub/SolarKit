//
//  UIWebView+SLGobackGesture.h
//  Example
//
//  Created by wyh on 2017/11/30.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (SLGobackGesture)

@property (nonatomic, assign) BOOL gobackGestureEnable;

@property (nonatomic, readonly) UIPanGestureRecognizer *gobackGesture;

@property (nonatomic, strong) UIView *currentSnapShotView;

@property (nonatomic, strong) UIView *preSnapShotView;

@property (nonatomic, readonly) NSMutableArray *snapShots;

- (void)addSnapshotViewWithRequest:(NSURLRequest*)request;

@end
