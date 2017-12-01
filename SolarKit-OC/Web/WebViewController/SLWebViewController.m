//
//  SLWebViewController.m
//  Example
//
//  Created by wyh on 2017/11/29.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "SLWebViewController.h"
#import "UIWebView+SLGobackGesture.h"
#import "NSBundle+SLWeb.h"

@interface SLWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIBarButtonItem *backBarButtonItem;

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) SLWebRoute *route;

@end

@implementation SLWebViewController

- (instancetype)initWithURIString:(NSString *)URIString {
    return [self initWithURIString:URIString paramters:nil];
}

- (instancetype)initWithURIString:(NSString *)URIString paramters:(NSDictionary *)paramters {
    SLWebRoute *route = [SLWebRoute routeWithURIString:URIString parameters:paramters];
    return [self initWithRoute:route];
}

- (instancetype)initWithURL:(NSURL *)URL paramters:(NSDictionary *)paramters {
    SLWebRoute *route = [SLWebRoute routeWithURL:URL parameters:paramters];
    return [self initWithRoute:route];
}

- (instancetype)initWithRoute:(SLWebRoute *)route {
    self = [super init];
    if (self) {
        _route = route;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUI];
    
    [self.webView loadRequest:self.route.mutableURLRequest];
    
}

- (void)setUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = self.backBarButtonItem;

    [self.view addSubview:self.webView];
    self.webView.gobackGestureEnable = YES;
    
    [self updateNavigation];
}

- (void)updateNavigation {
    self.navigationItem.leftBarButtonItem.customView.hidden = self.navigationController.viewControllers.count == 1 && !self.webView.canGoBack;
    self.navigationController.interactivePopGestureRecognizer.enabled = self.webView.snapShots.count == 1;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"\nURL:%@\nParameters:%@", request.URL.absoluteString, webView.request.HTTPBody);
    switch (navigationType) {
        case UIWebViewNavigationTypeLinkClicked:
        case UIWebViewNavigationTypeFormSubmitted:
        case UIWebViewNavigationTypeOther: {
            [webView addSnapshotViewWithRequest:request];
        }
            break;

        case UIWebViewNavigationTypeBackForward:
        case UIWebViewNavigationTypeReload:
        case UIWebViewNavigationTypeFormResubmitted: break;

        default: break;
    }
    [self updateNavigation];

    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self updateNavigation];
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

#pragma mark - Action

- (void)backBarButtonItemAction:(UIButton *)backBarButton {
    if (self.webView.canGoBack) {
        [self.webView goBack];
        [self.webView.snapShots removeLastObject];
    }
    else {
        if (self.navigationController.viewControllers.count > 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark - Get

- (UIBarButtonItem *)backBarButtonItem {
    if (_backBarButtonItem) return _backBarButtonItem;
    
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.frame = CGRectMake(0, 0, 40, 42);
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -7, 0, 0);
    
    NSBundle *bundle = [NSBundle bundleWithName:@"SLWeb"];
    NSString *imagePath = [bundle pathForImage:@"backBarButtonItem" inDirectory:@"images"];
    UIImage *backBarButtonItemImage = [UIImage imageWithContentsOfFile:imagePath];
    [backButton setImage:backBarButtonItemImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    return _backBarButtonItem;
}

- (UIWebView *)webView {
    if (_webView) return _webView;
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.scalesPageToFit = YES;
//    _webView.scrollView.bounces = NO;
    _webView.delegate = self;
    return _webView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"[SLWebViewController Dealloc]");
}

@end
