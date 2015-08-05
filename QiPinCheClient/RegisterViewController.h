//
//  RegisterViewController.h
//  QiPinCheClient
//
//  Created by Shijia on 15/8/1.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"

@interface RegisterViewController : UIViewController<UITextFieldDelegate> {
    NSString* receivedVerifiedCode;
}

@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *verifyCode;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UITextField *username;

@property (weak, nonatomic) IBOutlet UISegmentedControl *gender;
@property (weak, nonatomic) IBOutlet UITextField *job;

@property (strong, nonatomic) Commbox* ageSelector;


- (IBAction)backOnClick:(id)sender;
- (IBAction)registerOnClick:(id)sender;
- (IBAction)getVerifyCode:(id)sender;


@end
