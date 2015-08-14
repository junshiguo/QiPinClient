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
    
    // 修改用户名和昵称的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nickNameChanged:) name:@"ChangedNickName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jobChanged:) name:@"ChangedJob" object:nil];

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[UserInfo getUid] forKey:@"phoneNumber"];
    MKNetworkOperation *op = [ApplicationDelegate.httpEngine operationWithPath:@"/getUserInfo" params:dic httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSDictionary *response = [operation responseJSON];

        NSInteger statusCode = [[response objectForKey:@"status"] integerValue];
        if (statusCode == 1) {
            NSDictionary *dic = [response objectForKey:@"detail"];
            self.phoneNumber.text = [UserInfo getUid];
            self.nickName.text = [dic objectForKey:@"name"];
            
            if ([dic objectForKey:@"gender"] == 0) {
                self.gender.text = @"男";
            } else {
                self.gender.text = @"女";
            }
            self.age.text = [NSString stringWithFormat:@"%li岁", [[dic objectForKey:@"age"] integerValue]];
            self.job.text = [dic objectForKey:@"job"];
            
        } else {
            NSString *message = [response objectForKey:@"message"];
            if (message == nil) {
                message = @"网络异常";
            }
            [UIAlertShow showAlertViewWithMsg:message];
        }
        
    } errorHandler:^(MKNetworkOperation *errOp, NSError *err) {
        [UIAlertShow showAlertViewWithMsg:@"网络异常"];
        
    }];
    [ApplicationDelegate.httpEngine enqueueOperation:op];
}

- (void) nickNameChanged:(NSNotification*)notification {
    self.nickName.text = [notification object];
}

- (void) jobChanged:(NSNotification*)notification {
    self.job.text = [notification object];
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
