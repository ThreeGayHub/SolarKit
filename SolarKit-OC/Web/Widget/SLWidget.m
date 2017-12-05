//
//  SLWidget.m
//  Example
//
//  Created by wyh on 2017/12/1.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "SLWidget.h"

static NSMutableArray *_widgets;
static NSString *_widgetScheme;

@interface SLWidget ()

@property (nonatomic, strong) NSMutableArray *widgets;

@property (nonatomic, strong) NSString *widgetScheme;

@end

@implementation SLWidget

+ (void)setWidgetScheme:(NSString *)widgetScheme {
    _widgetScheme = widgetScheme;
}

+ (NSString *)widgetScheme {
    return _widgetScheme;
}

+ (void)addWidgets:(id<SLWidget>)widget, ... {
    va_list args;
    va_start(args, widget);
    if (widget) {
        [SLWidget.widgets addObject:widget];
        id<SLWidget> nextWidget;
        while ((nextWidget = va_arg(args, id<SLWidget>))) {
            [SLWidget.widgets addObject:nextWidget];
        }
    }
    va_end(args);
}

+ (NSMutableArray *)widgets {
    if (_widgets) return _widgets;
    
    _widgets = [NSMutableArray arrayWithCapacity:50];
    return _widgets;    
}

- (BOOL)canPerformWithURL:(NSURL *)URL {
    return YES;
}

- (void)performWithURL:(NSURL *)URL inController:(SLWebViewController *)controller {
    
}

@end
