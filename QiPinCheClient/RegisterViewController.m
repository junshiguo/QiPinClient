//
//  RegisterViewController.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/1.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "RegisterViewController.h"

@implementation RegisterViewController

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)backOnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)registerOnClick:(id)sender {
}
@end
