//
//  SecondViewController.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/1.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "MeViewController.h"

@interface MeViewController ()

@end

@implementation MeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    if (![UserInfo hasUserInfo]) {
        [ScreenSwitch switchToScreenIn:@"User" withStoryboardIdentifier:@"LoginViewController" inView:self];
    }

    self.phoneNumber.text = [UserInfo getUid];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 注销登录
- (IBAction)logOff:(id)sender {
    [UserInfo clearUserInfo];
    [ScreenSwitch switchToScreenIn:@"Main" withStoryboardIdentifier:@"TabBarController" inView:self];
    
    // 环信退出登陆地接口
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        if (!error) {
            NSLog(@"退出成功");
        }
    } onQueue:nil];
    
}
- (IBAction)modifyNickname:(id)sender {
    [ScreenSwitch switchToScreenIn:@"Profile" withStoryboardIdentifier:@"ModifyNicknameViewController" inView:self];
}

- (IBAction)modifyJob:(id)sender {
    [ScreenSwitch switchToScreenIn:@"Profile" withStoryboardIdentifier:@"ModifyJobViewController" inView:self];
}
@end
