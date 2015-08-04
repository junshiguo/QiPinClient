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
    [super viewDidLoad];
    
    self.phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginOnClick:(id)sender {
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
            [UserInfo setUserInfoWithUid:phoneNumber password:password];
            [ScreenSwitch switchToScreenIn:@"Main" withStoryboardIdentifier:@"TabBarController" inView:self];
        } else {
            NSString *msg = [responseData objectForKey:@"result"];
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alter show];
        }
    } errorHandler:^(MKNetworkOperation *errorOp, NSError *err) {
        NSLog(@"MKNetwork请求错误:%@", [err localizedDescription]);
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
