//
//  AppDelegate.m
//  Example
//
//  Created by wyh on 2017/7/5.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "AppDelegate.h"
#import "SLNetwork.h"
#import "SLWebCache.h"
#import "SLWebRoute.h"
#import "SLWebCacheCategory.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSString *URLString = @"http://ounl8txt0.bkt.clouddn.com/update.json";

    [SLWebCache shared].debug = YES;
    [[SLWebCache shared] updateWithURLString:URLString success:^{
        [SLWebRoute updateRoute];
    } fail:^(NSError *error) {
        
    }];
    
    
    
    SLWebRoute *route = [SLWebRoute routeWithURIString:@"xnph://xnph66.com/rexxar/forgotpwd/sendcode" parameters:@{@":userAccount" : @"caojiba71493847983"} ];
    
    NSLog(@"%@", route.URL);
    
    
    UIWebView *webPool = [[UIWebView alloc]initWithFrame:CGRectZero];
    [webPool loadHTMLString:@"" baseURL:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
