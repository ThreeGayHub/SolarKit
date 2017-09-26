//
//  SLLoginVC.m
//  Example
//
//  Created by wyh on 2017/9/26.
//  Copyright © 2017年 SolarKit. All rights reserved.
//

#import "SLLoginVC.h"
#import "SLKit.h"

typedef void(^SLLoginVCCompletion)(NSDictionary *response);

@interface SLLoginVC ()

@property (nonatomic, copy) SLLoginVCCompletion completion;

@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation SLLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.completion = self.parameters[@"completion"];
    [self.view addSubview:self.loginButton];
    // Do any additional setup after loading the view.
}

- (void)loginButtonAction:(UIButton *)loginButton {
    
    if (self.completion) {
        self.completion(@{@"code" : @(200),
                          @"msg"  : @"loginsucceed"});
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (UIButton *)loginButton {
    if (_loginButton) return _loginButton;
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _loginButton.frame = CGRectMake(0, self.view.height - 50, self.view.width, 50);
    _loginButton.backgroundColor = UIColor.greenColor;
    [_loginButton setTitle:@"login" forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    return _loginButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
