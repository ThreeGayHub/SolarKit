//
//  SLWebViewController.m
//  Example
//
//  Created by wyh on 2017/11/29.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "SLWebViewController.h"

#import "SLWebRoute.h"
#import "SLWidget.h"
#import "SLContainerInterceptor.h"
#import "SLRequestInterceptor.h"
#import "SLWebCache.h"

#import "SLLogContainerAPI.h"
#import "SLOpenWebVCContainerAPI.h"

#import "SLRequestDecorator.h"

#import "SLNavigationBarWidget.h"
#import "SLAlertWidget.h"

#import "UIWebView+SLGobackGesture.h"
#import "NSBundle+SLWeb.h"
#import "NSDictionary+SLWeb.h"
#import "UIView+SLWebFailView.h"

@interface SLWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIBarButtonItem *backBarButtonItem;

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) SLWebRoute *route;

@property (nonatomic, strong) NSMutableDictionary<NSString *, SLWidget *> *widgetDictionary;

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
    
    [self registerInterceptor];

    [self reloadWebView];
}

- (void)reloadWebView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.webView loadRequest:self.route.mutableURLRequest];
    });
}

- (void)setUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = self.backBarButtonItem;

    [self.view addSubview:self.webView];
    self.webView.gobackGestureEnable = YES;
    
    [self updateNavigation];
}

- (void)registerInterceptor {
    SLNavigationBarWidget *naviWidget = [SLNavigationBarWidget widgetWithPath:SLNavigationBarWidgetPath];
    SLAlertWidget *alertWidget = [SLAlertWidget widgetWithPath:SLAlertWidgetPath];
    [SLWidget addWidgets:naviWidget, alertWidget, nil];
    
    SLRequestDecorator *requestDecorator = [[SLRequestDecorator alloc] init];
    [SLRequestInterceptor addDecorators:requestDecorator, nil];
    [SLURLProtocol registerSLProtocolClass:[SLRequestInterceptor class]];
    [SLRequestInterceptor.decorators enumerateObjectsUsingBlock:^(SLDecorator * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.controller = self;
    }];
    
    SLLogContainerAPI *logContainerAPI = [SLLogContainerAPI containerAPIWithPath:SLLogContainerAPIPath];
    SLOpenWebVCContainerAPI *openWebVCContainerAPI = [SLOpenWebVCContainerAPI containerAPIWithPath:SLOpenWebVCContainerAPIPath];
    [SLContainerInterceptor addContainerAPIs:logContainerAPI, openWebVCContainerAPI, nil];
    [SLURLProtocol registerSLProtocolClass:[SLContainerInterceptor class]];
    [SLContainerInterceptor.containerAPIDictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, SLContainerAPI * _Nonnull obj, BOOL * _Nonnull stop) {
        obj.controller = self;
    }];
}

- (void)updateNavigation {
    self.navigationItem.leftBarButtonItem.customView.hidden = self.navigationController.viewControllers.count == 1 && !self.webView.canGoBack;
    self.navigationController.interactivePopGestureRecognizer.enabled = self.webView.snapShots.count <= 1;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //navigation & gobackGesture
    NSLog(@"\nURL:%@\nParameters:%@", request.URL.absoluteString, webView.request.HTTPBody);
    
    if (request.URL.isFileURL && ![request.URL.absoluteString isEqualToString:self.route.mutableURLRequest.URL.absoluteString]) {
        self.route.mutableURLRequest = request.mutableCopy;//切换一下，方便reload
    }
    
    [self updateNavigation];
    
    switch (navigationType) {
        case UIWebViewNavigationTypeLinkClicked:
        case UIWebViewNavigationTypeFormSubmitted:
        case UIWebViewNavigationTypeOther: {
            [webView addSnapshotViewWithRequest:request];
        }
            break;

        default: break;
    }
    
    //widget
    if ([request.URL.scheme isEqualToString:[SLWidget widgetScheme]]) {
        SLWidget *widget = SLWidget.widgetDictionary[request.URL.path];
        if ([widget canPerformWithURL:request.URL]) {
            [widget performWithURL:request.URL inController:self];
        }
        else {
            NSLog(@"NO Widget:\n%@", request.URL);
        }
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self updateNavigation];
    [webView removeFailView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self updateNavigation];
    self.title = @"加载失败";
    
    [self showErrorView];
}

#pragma mark - Action

- (void)showErrorView {
    __weak typeof(self) weakSelf = self;
    [self.webView addFailViewWithImageName:@"SLWebFailView" text:@"点击重新加载" click:^{
        [[SLWebCache shared] updateSuccess:^{
            __weak typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf reloadWebView];
        } fail:^(NSError *error) {
            __weak typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf reloadWebView];
        }];
    }];
}

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

- (void)addWidgets:(SLWidget *)widget, ... {
    va_list args;
    va_start(args, widget);
    if (widget) {
        [self addWidget:widget];
        SLWidget *nextWidget;
        while ((nextWidget = va_arg(args, SLWidget *))) {
            [self addWidget:nextWidget];
        }
    }
    va_end(args);
}

- (void)addWidget:(SLWidget *)widget {
    if (![self.widgetDictionary.allKeys containsObject:widget.path]) {
        [self.widgetDictionary setObject:widget forKey:widget.path];
    }
}

- (NSString *)callJavaScript:(NSString *)function parameters:(NSDictionary *)parameters {
    NSString *jsCall;
    NSString *jsonParameter = parameters.jsonString;
    if (jsonParameter) {
        jsonParameter = [jsonParameter stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
        jsonParameter = [jsonParameter stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        jsonParameter = [jsonParameter stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
        jsonParameter = [jsonParameter stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
        jsonParameter = [jsonParameter stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
        jsonParameter = [jsonParameter stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
        jsonParameter = [jsonParameter stringByReplacingOccurrencesOfString:@"\u2028" withString:@"\\u2028"];
        jsonParameter = [jsonParameter stringByReplacingOccurrencesOfString:@"\u2029" withString:@"\\u2029"];
        jsCall = [NSString stringWithFormat:@"%@('%@')", function, jsonParameter];
    } else {
        jsCall = [NSString stringWithFormat:@"%@()", function];
    }
    NSString *result = [_webView stringByEvaluatingJavaScriptFromString:jsCall];
    NSLog(@"jsCall: function:%@, parameter %@, result: %@", function, jsonParameter, result);
    return result;
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

- (NSMutableDictionary<NSString *, SLWidget *> *)widgetDictionary {
    if (_widgetDictionary) return _widgetDictionary;
    
    _widgetDictionary = [NSMutableDictionary dictionaryWithDictionary:SLWidget.widgetDictionary];
    return _widgetDictionary;
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [SLURLProtocol unregisterSLProtocolClass:[SLContainerInterceptor class]];
    [SLURLProtocol unregisterSLProtocolClass:[SLRequestInterceptor class]];
    NSLog(@"[SLWebViewController Dealloc]");
}

@end
