//
//  SLWebViewController.h
//  Example
//
//  Created by wyh on 2017/11/29.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SLWebRoute;
@class SLWidget;

@interface SLWebViewController : UIViewController

@property (nonatomic, readonly) UIWebView *webView;

@property (nonatomic, readonly) SLWebRoute *route;

- (instancetype)initWithURIString:(NSString *)URIString;

- (instancetype)initWithURIString:(NSString *)URIString paramters:(NSDictionary *)paramters;

- (instancetype)initWithURL:(NSURL *)URL paramters:(NSDictionary *)paramters;

- (void)addWidgets:(SLWidget *)widget, ...;

- (NSString *)callJavaScript:(NSString *)function parameters:(NSDictionary *)parameters;

@end
