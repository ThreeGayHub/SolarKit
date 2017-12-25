//
//  UIWebView+SLGobackGesture.m
//  Example
//
//  Created by wyh on 2017/11/30.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "UIWebView+SLGobackGesture.h"
#import <objc/runtime.h>

@implementation UIWebView (SLGobackGesture)

#pragma mark - Action

- (void)gobackGestureAction:(UIPanGestureRecognizer *)gobackGesture {
    CGPoint translation = [gobackGesture translationInView:self];
    CGPoint location = [gobackGesture locationInView:self];
    
    if (gobackGesture.state == UIGestureRecognizerStateBegan) {
        if (location.x <= 100 && translation.x > 0) {
            [self startPopSnapshotView];
        }
    }else if (gobackGesture.state == UIGestureRecognizerStateCancelled || gobackGesture.state == UIGestureRecognizerStateEnded){
        [self endPopSnapShotView];
    }else if (gobackGesture.state == UIGestureRecognizerStateChanged){
        [self popSnapShotViewWithPanGestureDistance:translation.x];
    }
}

- (void)startPopSnapshotView {
    if (!self.canGoBack) {
        return;
    }
    //create a center of scrren
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    self.currentSnapShotView.center = center;
    center.x -= 60;
    self.preSnapShotView.center = center;
    self.preSnapShotView.alpha = 1;
    
    [self addSubview:self.preSnapShotView];
    [self addSubview:self.currentSnapShotView];
}

- (void)popSnapShotViewWithPanGestureDistance:(CGFloat)distance {
    
    if (distance <= 0) {
        return;
    }
    
    CGFloat boundsWidth = self.bounds.size.width;
    CGFloat boundsHeight = self.bounds.size.height;
    
    
    CGPoint currentSnapshotViewCenter = CGPointMake(boundsWidth/2, boundsHeight/2);
    currentSnapshotViewCenter.x += distance;
    CGPoint preSnapShotViewCenter = CGPointMake(boundsWidth/2, boundsHeight/2);
    preSnapShotViewCenter.x -= (boundsWidth - distance)*60/boundsWidth;
    
    self.currentSnapShotView.center = currentSnapshotViewCenter;
    self.preSnapShotView.center = preSnapShotViewCenter;
}

- (void)endPopSnapShotView {
    
    CGFloat boundsWidth = self.bounds.size.width;
    CGFloat boundsHeight = self.bounds.size.height;
    
    if (self.currentSnapShotView.center.x >= boundsWidth) {
        // pop success
        [UIView animateWithDuration:0.2 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            
            self.currentSnapShotView.center = CGPointMake(boundsWidth*3/2, boundsHeight/2);
            self.preSnapShotView.center = CGPointMake(boundsWidth/2, boundsHeight/2);
        }completion:^(BOOL finished) {
            [self.preSnapShotView removeFromSuperview];
            self.preSnapShotView = nil;
            [self.currentSnapShotView removeFromSuperview];
            self.currentSnapShotView = nil;
            [self goBack];
            [self.snapShots removeLastObject];
            
        }];
    }else{
        //pop fail
        [UIView animateWithDuration:0.2 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            
            self.currentSnapShotView.center = CGPointMake(boundsWidth/2, boundsHeight/2);
            self.preSnapShotView.center = CGPointMake(boundsWidth/2-60, boundsHeight/2);
            self.preSnapShotView.alpha = 1;
        }completion:^(BOOL finished) {
            [self.preSnapShotView removeFromSuperview];
            self.preSnapShotView = nil;
            [self.currentSnapShotView removeFromSuperview];
            self.currentSnapShotView = nil;
            
        }];
    }
}

- (void)addSnapshotViewWithRequest:(NSURLRequest*)request {
    NSURLRequest* lastRequest = (NSURLRequest*)[[self.snapShots lastObject] objectForKey:@"request"];
    //如果url是很奇怪的就不push
    //如果url一样就不进行push
    if (request && ![request.URL.absoluteString isEqualToString:@"about:blank"] && ![request.URL.absoluteString isEqualToString:lastRequest.URL.absoluteString] && request.URL.isFileURL) {
        UIView* snapShotView = [self snapshotViewAfterScreenUpdates:YES];
        [self.snapShots addObject:@{@"request":request, @"snapShotView":snapShotView}];
//        NSLog(@"\nsnapShots:%@", self.snapShots);
    }
}

#pragma mark - Set

- (void)setCurrentSnapShotView:(UIView *)currentSnapShotView {
    objc_setAssociatedObject(self, @selector(currentSnapShotView), currentSnapShotView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setPreSnapShotView:(UIView *)preSnapShotView {
    objc_setAssociatedObject(self, @selector(preSnapShotView), preSnapShotView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setGobackGestureEnable:(BOOL)gobackGestureEnable {
    self.gobackGesture.enabled = gobackGestureEnable;
    if (gobackGestureEnable && ![self.gestureRecognizers containsObject:self.gobackGesture]) {
        [self addGestureRecognizer:self.gobackGesture];
    }
}

- (BOOL)gobackGestureEnable {
    return self.gobackGesture.enabled;
}

#pragma mark - Get

- (UIPanGestureRecognizer *)gobackGesture {
    UIPanGestureRecognizer *gobackGesture = objc_getAssociatedObject(self, _cmd);
    if (gobackGesture) return gobackGesture;
    
    gobackGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gobackGestureAction:)];
    
    objc_setAssociatedObject(self, _cmd, gobackGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return gobackGesture;
}

- (UIView *)currentSnapShotView {
    UIView *currentSnapShotView = objc_getAssociatedObject(self, _cmd);
    if (currentSnapShotView) return currentSnapShotView;
    
    currentSnapShotView = [self snapshotViewAfterScreenUpdates:YES];
    currentSnapShotView.layer.shadowColor = [UIColor blackColor].CGColor;
    currentSnapShotView.layer.shadowOffset = CGSizeMake(3, 3);
    currentSnapShotView.layer.shadowRadius = 5;
    currentSnapShotView.layer.shadowOpacity = 0.75;
    
    objc_setAssociatedObject(self, _cmd, currentSnapShotView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return currentSnapShotView;
}

- (UIView *)preSnapShotView {
    UIView *preSnapShotView = objc_getAssociatedObject(self, _cmd);
    if (preSnapShotView) return preSnapShotView;
    
    preSnapShotView = (UIView*)[[self.snapShots lastObject] objectForKey:@"snapShotView"];
    
    objc_setAssociatedObject(self, _cmd, preSnapShotView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return preSnapShotView;
}

- (NSMutableArray *)snapShots {
    NSMutableArray *snapShots = objc_getAssociatedObject(self, _cmd);
    if (snapShots) return snapShots;
    
    snapShots = [NSMutableArray array];
    
    objc_setAssociatedObject(self, _cmd, snapShots, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return snapShots;
}

@end
