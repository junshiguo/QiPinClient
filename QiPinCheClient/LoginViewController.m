//
//  LoginViewController.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/1.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "UserInfo.h"

@implementation LoginViewController

- (void)viewDidLoad{
    NSLog(@"LoginViewController---viewDidLoad");
    [super viewDidLoad];
    
    self.phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginOnClick:(id)sender {
    NSLog(@"loginOnClick");
    NSString *phoneNumber = self.phoneNumber.text;
    NSString *password = self.password.text;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:phoneNumber forKey:@"phoneNumber"];
    [params setObject:password forKey:@"password"];
    MKNetworkOperation *op = [ApplicationDelegate.httpEngine operationWithPath:@"/logIn" params:params httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSDictionary *responseData = [operation responseJSON];
        NSInteger status = [[responseData objectForKey:@"status"] integerValue];
        if (status == 1) {
            NSDictionary *detail = [responseData objectForKey:@"detail"];
            NSNumber *age = [detail objectForKey:@"age"];
            NSNumber *gender = [detail objectForKey:@"gender"];
            
            [UserInfo setUserInfoWithUid:phoneNumber password:password age:age gender:gender];
            [ScreenSwitch switchToScreenIn:@"Main" withStoryboardIdentifier:@"TabBarController" inView:self];
            
            //环信的登陆接口
            BOOL isAutoLogin = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
            if (!isAutoLogin) {
                [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:phoneNumber password:@"7474741" completion:^(NSDictionary *loginInfo, EMError *error) {
                    if (!error) {
                    // 设置自动登录
                        [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                        NSLog(@"登陆成功，设置自动登录");
                    }
                } onQueue:nil];
            }
        } else {
            NSString *msg = [responseData objectForKey:@"message"];
            if (msg == nil) msg = @"网络错误！10020";
            [UIAlertShow showAlertViewWithMsg:msg];
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError *err) {
        NSLog(@"MKNetwork请求错误:%@ 10021", [err localizedDescription]);
    }];
    [ApplicationDelegate.httpEngine enqueueOperation:op];
    
}


- (IBAction)registerOnClick:(id)sender {
   [ScreenSwitch switchToScreenIn:@"User" withStoryboardIdentifier:@"RegisterViewController" inView:self];
}

- (IBAction)backOnClick:(id)sender {
    [ScreenSwitch switchToScreenIn:@"Main" withStoryboardIdentifier:@"TabBarController" inView:self];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
