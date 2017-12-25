//
//  SLNavigationBarWidget.m
//  Example
//
//  Created by wyh on 2017/12/4.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "SLNavigationBarWidget.h"
#import "UIColor+SLWebHexColor.h"

@interface SLNavigationBarWidget ()

@property (nonatomic, copy) NSArray <NSDictionary *> *buttons;

@property (nonatomic, weak) SLWebViewController *controller;

@end

@implementation SLNavigationBarWidget

- (void)performWithURL:(NSURL *)URL inController:(SLWebViewController *)controller {
    [super performWithURL:URL inController:controller];

    NSString *dataString = [URL.queryDictionary itemForKey:@"data"];
    NSDictionary *dataDict = dataString.dictionary;
    
    if (dataDict) {
        NSString *title = dataDict[@"title"];
        NSString *bgColor = dataDict[@"bgColor"];
        _buttons = [dataDict[@"buttons"] isKindOfClass:[NSArray class]] ? dataDict[@"buttons"] : nil;
        
        if (title) {
            controller.title = title;
        }
        if (bgColor) {
            UIColor *navBgColor = [UIColor hexColor:bgColor];
            controller.navigationController.navigationBar.backgroundColor = navBgColor;
        }
        if (self.buttons.count > 0) {
            NSMutableArray *items = [NSMutableArray array];
            [self.buttons enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIBarButtonItem *item = [self barButtonItemWithDict:obj];
                item.tag = idx;
                [items addObject:item];
            }];
            controller.navigationItem.rightBarButtonItems = items;
            _controller = controller;
        }
    }
}

- (UIBarButtonItem *)barButtonItemWithDict:(NSDictionary *)dict {
    UIBarButtonItem *item = nil;
    if ([dict[@"type"] isEqualToString:@"SEARCH"]) {
        item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                             target:self
                                                             action:@selector(barButtonItemAction:)];
    } else {
        item = [[UIBarButtonItem alloc] initWithTitle:dict[@"text"]
                                                style:UIBarButtonItemStylePlain
                                               target:self
                                               action:@selector(barButtonItemAction:)];
    }
    return item;
}

- (void)barButtonItemAction:(UIBarButtonItem *)barButtonItem {
    NSDictionary *dict = self.buttons[barButtonItem.tag];
    [self.controller callJavaScript:dict[@"action"] parameters:nil];
}

@end
