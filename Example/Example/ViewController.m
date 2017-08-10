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
{
    CGFloat Length;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Length = ScreenWidth / 4;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, Length, Length)];
    [self.view addSubview:view];
    view.backgroundColor = UIColor.redColor;
    [view touchUp:^{
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
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(Length, 64, Length, Length)];
    [self.view addSubview:label];
    label.backgroundColor = UIColor.orangeColor;
    @weakify(self);
    [label touchUp:^{
        @strongify(self);
//        self.timer = [NSTimer singleTimerWithInterval:2 block:^{
//            NSLog(@"singleTimer");
//        }];
//        self.timer = [NSTimer repeaticTimerWithInterval:2 block:^{
//            NSLog(@"repeaticTimer");
//        }];
//        self.timer = [NSTimer countdownTimerWithInterval:1 times:10 block:^(NSTimeInterval leftSeconds) {
//            NSLog(@"%ld", (long)leftSeconds);
//        }];
//        [self.timer start];
        
        [NSTimer throttle:0.5 block:^{
            NSLog(@"throttle");
        }];
        
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(Length * 2, 64, Length, Length)];
    imageView.backgroundColor = UIColor.yellowColor;
    [self.view addSubview:imageView];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView touchUp:^{
        @strongify(self);
        
        UIActionSheet *actionSheet = [UIActionSheet actionSheetWithTitle:@"Title"];
        [actionSheet addCancelButton:@"取消"];
        [actionSheet addDestructiveButton:@"录像" action:^{
            @strongify(self);
            UIImagePickerController *picker = [UIImagePickerController pickerWithType:SLImagePickerTypeVideo];
            [picker selectedVideo:^(NSData *mediaData, NSUInteger seconds) {
                NSLog(@"Length:%lu\nSeconds:%lu", [mediaData length], seconds);
            }];
            [picker showInVC:self];
        }];
        [actionSheet addButton:@"照相" action:^{
            @strongify(self);
            UIImagePickerController *picker = [UIImagePickerController pickerWithType:SLImagePickerTypeTakePhoto];
            [picker selected:^(NSData *mediaData) {
                imageView.image = [UIImage imageWithData:mediaData].compressImage;
                NSLog(@"Length:%lu", [mediaData length]);
            }];
            [picker showInVC:self];
        }];
        [actionSheet addButton:@"相册列表" action:^{
            @strongify(self);
            UIImagePickerController *picker = [UIImagePickerController pickerWithType:SLImagePickerTypeAlbumList];
            [picker selected:^(NSData *mediaData) {
                imageView.image = [UIImage imageWithData:mediaData];
                NSLog(@"Length:%lu", [mediaData length]);
            }];
            [picker showInVC:self];
        }];
        [actionSheet addButton:@"相册时间线" action:^{
            @strongify(self);
            UIImagePickerController *picker = [UIImagePickerController pickerWithType:SLImagePickerTypeAlbumTimeline];
            [picker selected:^(NSData *mediaData) {
                imageView.image = [UIImage imageWithData:mediaData];
                NSLog(@"Length:%lu", [mediaData length]);
            }];
            [picker showInVC:self];
        }];
        [actionSheet showInView:self.view];
    }];
    
    imageView.borderColor = UIColor.blackColor;
    imageView.multiBorderWidth = SLBorderWidthMake(1, 0, 1, 0);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.tintColor = [UIColor yellowColor];
    button.frame = CGRectMake(Length * 3, 64, Length, Length);
    button.backgroundColor = UIColor.greenColor;
    [self.view addSubview:button];
    [button touchUpInside:^(UIButton *button) {
        NSLog(@"touchUpInside");
    }];
    
    button.imageName = @"Solar";
    button.title = @"title";
    button.fontSize = 10;
    button.titleColor = [UIColor redColor];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 64 + Length, Length, Length)];
    textField.backgroundColor = UIColor.cyanColor;
    [self.view addSubview:textField];
    [textField editingChanged:^(UITextField *textField) {
        NSLog(@"%@", textField.text);
    }];
    textField.multiCornerRadius = SLRectCornerMake(5, 0, 0, 5);
    
    
    
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
