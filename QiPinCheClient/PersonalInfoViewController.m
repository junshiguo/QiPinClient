//
//  PersonalInfoViewController.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/10.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "PersonalInfoViewController.h"

@interface PersonalInfoViewController ()

@end

@implementation PersonalInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getInfo:) name:@"ShowPartnerInfo" object:nil];
}

- (void) getInfo:(NSNotification*)notification {
    NSDictionary *dic = [notification object];
    NSLog(@"getInfo, dic=%@", dic);

    if ([dic objectForKey:@"ShowPhoneNumber"] != nil) showPhoneNumber = YES;
    else showPhoneNumber = NO;
    phoneNumber = [dic objectForKey:@"partnerPhoneNumber"];
    
    // 在双方未确认前不显示对方手机号
    if (!showPhoneNumber) self.phoneNumberLabel.hidden = YES;
    else self.phoneNumberLabel.text = [dic objectForKey:@"partnerPhoneNumber"];
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setObject:phoneNumber forKey:@"phoneNumber"];
    MKNetworkOperation *op = [ApplicationDelegate.httpEngine operationWithPath:@"/getUserInfo" params:data httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSDictionary *response = [operation responseJSON];
        
        NSInteger statusCode = [[response objectForKey:@"status"] integerValue];
        if (statusCode == 1) {
            NSDictionary *dic = [response objectForKey:@"detail"];
            self.phoneNumberLabel.text = [UserInfo getUid];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
