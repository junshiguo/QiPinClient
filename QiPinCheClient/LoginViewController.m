//
//  LoginViewController.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/1.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController

- (IBAction)loginOnClick:(id)sender {
    NSString *path = @"10.171.5.228";
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:path customHeaderFields:nil];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@"18817361981" forKey:@"phoneNumber"];
    
    MKNetworkOperation *op = [engine operationWithURLString:@"http://10.171.5.228:8080/register/" params:params httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSLog(@"responseData : %@", [operation responseString]);
    
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* err) {
        NSLog(@"MKNetwork请求错误 : %@", [err localizedDescription]); }];
    [engine enqueueOperation:op];
}


- (IBAction)registerOnClick:(id)sender {
   // UIStoryboard* userStoryboard = [UI]
    [ScreenSwitch switchToScreenIn:@"User" withStoryboardIdentifier:@"RegisterViewController" inView:self];
}

- (IBAction)backOnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
