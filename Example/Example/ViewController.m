//
//  ViewController.m
//  Example
//
//  Created by wyh on 2017/7/5.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "ViewController.h"

#import "SLKit.h"
#import "SLFoundation.h"
#import "SLDefine.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewController ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 100, 100)];
    [self.view addSubview:view];
    view.backgroundColor = UIColor.greenColor;
    [view sl_touchUp:^{
        UIAlertView *alertView = [UIAlertView alertWithTitle:@"Title" message:@"Message"];
        [alertView addButton:@"nil"];
        [alertView addButton:@"cancel" action:^{
            NSLog(@"cancel");
        }];
        [alertView addButton:@"other" action:^{
            NSLog(@"other");
        }];
        [alertView show];
    }];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 64, 100, 100)];
    [self.view addSubview:label];
    label.backgroundColor = UIColor.orangeColor;
    @weakify(self);
    [label sl_touchUp:^{
        @strongify(self);
//        self.timer = [NSTimer singleTimerWithInterval:2 block:^{
//            NSLog(@"singleTimer");
//        }];
//        self.timer = [NSTimer repeaticTimerWithInterval:2 block:^{
//            NSLog(@"repeaticTimer");
//        }];
        self.timer = [NSTimer countdownTimerWithInterval:1 times:10 block:^(NSTimeInterval leftSeconds) {
            NSLog(@"%ld", (long)leftSeconds);
        }];
        [self.timer start];
        
    }];
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.timer stop];
    NSLog(@"%s", __FUNCTION__);
}


@end
