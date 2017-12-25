//
//  SLWidget.h
//  Example
//
//  Created by wyh on 2017/12/1.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SLWebViewController.h"
#import "NSURL+SLWeb.h"
#import "NSDictionary+SLWeb.h"
#import "NSString+SLWeb.h"

extern NSString * const SLNavigationBarWidgetPath;
extern NSString * const SLAlertWidgetPath;

/**
 * `SLWidget` 是一个 Widget 协议。
 * 实现 SLWidget 协议的类将完成一个 Web 对 Native 的功能调用。
 */
@protocol SLWidget <NSObject>

/**
 * 判断该 Widget 是否要对该 URL 做出反应。
 *
 * @param URL 对应的 URL。
 */
- (BOOL)canPerformWithURL:(NSURL *)URL;

/**
 * 执行 Widget 的操作。
 *
 * @param URL 对应的 URL。
 * @param controller 执行该 Widget 的 Controller。
 */
- (void)performWithURL:(NSURL *)URL inController:(SLWebViewController *)controller;

@end

@interface SLWidget : NSObject <SLWidget>

@property (class, nonatomic, copy) NSString *widgetScheme;

@property (class, nonatomic, readonly)NSMutableDictionary<NSString *, SLWidget *> *widgetDictionary;

+ (void)addWidgets:(SLWidget *)widget, ...;

+ (instancetype)widgetWithPath:(NSString *)path;

@property (nonatomic, readonly) NSString *path;


- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)new UNAVAILABLE_ATTRIBUTE;

@end
