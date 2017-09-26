//
//  HomeVC.m
//  Example
//
//  Created by wyh on 2017/8/17.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "HomeVC.h"

#import "SLKit.h"
#import "SLFoundation.h"
#import "SLDefine.h"
#import "SLMediator.h"

@interface HomeVC ()

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(UIButton *)sender {
    
    UIViewController *vc = [[SLMediator shared] call:@"SLAccount/login" parameters:nil completion:^(NSDictionary *response) {
        NSLog(@"%@", response);
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
