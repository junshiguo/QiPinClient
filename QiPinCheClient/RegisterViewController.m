//
//  RegisterViewController.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/1.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "RegisterViewController.h"

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    receivedVerifiedCode = nil;
    
    // 插入年龄选择按钮
    float width = self.username.frame.size.width;
    float height = self.username.frame.size.height;
    float x = self.username.frame.origin.x;
    float y = self.gender.frame.origin.y + 20 + self.gender.frame.size.height;
    self.ageSelector = [[Commbox alloc] initWithFrame:CGRectMake(x, y, width, height)];
    self.ageSelector.textField.placeholder = @"请输入年龄年龄";
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:100];
    for (int i = 0; i < 100; i++) {
        arr[i] = [NSString stringWithFormat:@"%i岁", i];
    }
    
    self.ageSelector.tableArray = arr;
    [self.view addSubview:self.ageSelector];
    
    
    self.phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    self.verifyCode.keyboardType = UIKeyboardTypeNumberPad;
    self.job.keyboardType = self.username.keyboardType = UIKeyboardTypeDefault;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    [self.view endEditing:YES];
    [self.ageSelector endShowList];
}

- (IBAction)backOnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)registerOnClick:(id)sender {
    NSString *phoneNumber = self.phoneNumber.text;
    NSString *verifyCode = self.verifyCode.text;
    NSString *password = self.password.text;
    NSString *confirmedPassword = self.confirmPassword.text;
    NSString *username = self.username.text;
    NSNumber *gender = [NSNumber numberWithInteger:self.gender.selectedSegmentIndex];
    NSNumber *age = [NSNumber numberWithInteger:[self.ageSelector.textField.text integerValue]];
    NSString *job = self.job.text;
    if (receivedVerifiedCode == nil) {
        [UIAlertShow showAlertViewWithMsg:@"请先获取验证码"];

    } else if ([phoneNumber length] == 0 || [verifyCode length] == 0 || [password length] == 0 || [confirmedPassword length] == 0
        || [username length] == 0 || [age integerValue]== 0 || [job length] == 0) {
        [UIAlertShow showAlertViewWithMsg:@"您输入的信息不完整"];
    } else if (![password isEqualToString:confirmedPassword]){
        [UIAlertShow showAlertViewWithMsg:@"您输入的密码不一致"];
    } else if (![verifyCode isEqualToString:receivedVerifiedCode]) {
        [UIAlertShow showAlertViewWithMsg:@"验证码错误！"];
    }else if(![self isPhoneNumber:phoneNumber]) {
        [UIAlertShow showAlertViewWithMsg:@"非法手机号！"];
    } else {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:phoneNumber forKey:@"phoneNumber"];
        [params setObject:verifyCode forKey:@"verifyCode"];
        [params setObject:password forKey:@"password"];
        [params setObject:username forKey:@"username"];
        [params setObject:gender forKey:@"gender"];
        [params setObject:age forKey:@"age"];
        [params setObject:job forKey:@"job"];
        
        MKNetworkOperation *op = [ApplicationDelegate.httpEngine operationWithPath:@"/register" params:params httpMethod:@"POST"];
        [op addCompletionHandler:^(MKNetworkOperation *operation) {
            NSDictionary *responseData = [operation responseJSON];
            NSLog(@"%@", responseData);
            NSInteger statusCode = [[responseData objectForKey:@"status"] integerValue];
            if (statusCode == 1) {
                NSLog(@"gender=%@", gender);
                [UserInfo setUserInfoWithUid:phoneNumber password:password age:age gender:gender];
                [ScreenSwitch switchToScreenIn:@"Main" withStoryboardIdentifier:@"TabBarController" inView:self];
            } else {
                NSString *msg = [responseData objectForKey:@"message"];
                if (msg == nil) {
                    msg = @"未知原因注册失败！";
                }

                [UIAlertShow showAlertViewWithMsg:msg];
            } 
            
        } errorHandler:^(MKNetworkOperation *errorOp, NSError *err) {
            [UIAlertShow showAlertViewWithMsg:@"网络好像有问题哦，稍后再试 10071"];
        }];
        [ApplicationDelegate.httpEngine enqueueOperation:op];
        
    }
    
}

- (IBAction)getVerifyCode:(id)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:self.phoneNumber.text forKey:@"phoneNumber"];
    MKNetworkOperation *op = [ApplicationDelegate.httpEngine operationWithPath:@"/send_verify_code" params:params httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSDictionary *responseData = [operation responseJSON];
        NSLog(@"%@", responseData);
        NSInteger statusCode = [[responseData objectForKey:@"status"] integerValue];
        if (statusCode == 1) {
            receivedVerifiedCode = [responseData objectForKey:@"detail"];
            [UIAlertShow showAlertViewWithMsg:@"短信验证码已发至您的手机！"];
        } else {
            NSString *msg = [responseData objectForKey:@"message"];
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alter show];
        }
        NSLog(@"%@", receivedVerifiedCode);
    } errorHandler:^(MKNetworkOperation *errOp, NSError *err) {
        NSLog(@"Fail-%@", [err localizedDescription]);
    }];
    [ApplicationDelegate.httpEngine enqueueOperation:op];
}

- (BOOL)isPhoneNumber:(NSString*)phoneNumber {
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:phoneNumber];
}

@end
