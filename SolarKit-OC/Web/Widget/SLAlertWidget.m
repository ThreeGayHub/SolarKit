//
//  SLAlertWidget.m
//  Example
//
//  Created by wyh on 2017/12/4.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "SLAlertWidget.h"

@implementation SLAlertWidget

- (void)performWithURL:(NSURL *)URL inController:(SLWebViewController *)controller {
    [super performWithURL:URL inController:controller];
    
    NSString *dataString = [URL.queryDictionary itemForKey:@"data"];
    NSDictionary *dataDict = dataString.dictionary;
    
    if (dataDict) {
        NSString *title = dataDict[@"title"];
        NSString *message = dataDict[@"message"];
        NSArray<NSDictionary *> *buttons = [dataDict[@"buttons"] isKindOfClass:[NSArray class]] ? dataDict[@"buttons"] : nil;
        
        if (buttons.count > 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            [buttons enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIAlertAction *action = [UIAlertAction actionWithTitle:obj[@"text"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [controller callJavaScript:obj[@"action"] parameters:nil];
                }];
                [alert addAction:action];
            }];
        }
    }
}

@end
