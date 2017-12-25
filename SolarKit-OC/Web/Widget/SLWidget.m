//
//  SLWidget.m
//  Example
//
//  Created by wyh on 2017/12/1.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "SLWidget.h"

NSString * const SLNavigationBarWidgetPath = @"/widget/navBar";
NSString * const SLAlertWidgetPath = @"/widget/alertDialog";

static NSMutableDictionary<NSString *, SLWidget *> *_widgetDictionary;
static NSString *_widgetScheme;

@implementation SLWidget

+ (void)setWidgetScheme:(NSString *)widgetScheme {
    _widgetScheme = widgetScheme;
}

+ (NSString *)widgetScheme {
    if (_widgetScheme) return _widgetScheme;
    
    _widgetScheme = @"slwidget";
    return _widgetScheme;
}

+ (void)addWidgets:(SLWidget *)widget, ... {
    va_list args;
    va_start(args, widget);
    if (widget) {
        [self addWidget:widget];
        SLWidget* nextWidget;
        while ((nextWidget = va_arg(args, SLWidget *))) {
            [self addWidget:nextWidget];
        }
    }
    va_end(args);
}

+ (void)addWidget:(SLWidget *)widget {
    if (![SLWidget.widgetDictionary.allKeys containsObject:widget.path]) {
        [SLWidget.widgetDictionary setObject:widget forKey:widget.path];
    }
}

+ (NSMutableDictionary<NSString *, SLWidget *> *)widgetDictionary {
    if (_widgetDictionary) return _widgetDictionary;
    
    _widgetDictionary = [NSMutableDictionary dictionaryWithCapacity:50];
    return _widgetDictionary;
}

#pragma mark - Init

+ (instancetype)widgetWithPath:(NSString *)path {
    return [[self alloc] initWithPath:path];
}

- (instancetype)initWithPath:(NSString *)path
{
    self = [super init];
    if (self) {
        _path = path;
    }
    return self;
}

#pragma mark - SLWidget

- (BOOL)canPerformWithURL:(NSURL *)URL {
    BOOL isCanPerform = [URL.path isEqualToString:self.path];
    if (!isCanPerform) {
        NSLog(@"Widget can't performWithURL:\n%@", URL);
    }
    return isCanPerform;
}

- (void)performWithURL:(NSURL *)URL inController:(SLWebViewController *)controller {
    NSLog(@"Widget performWithURL:\n%@", URL);
}

@end
