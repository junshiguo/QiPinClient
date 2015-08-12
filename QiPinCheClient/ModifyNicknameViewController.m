//
//  ModifyNicknameViewController.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/9.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "ModifyNicknameViewController.h"

@interface ModifyNicknameViewController ()

@end

@implementation ModifyNicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)save:(id)sender {
    if (self.nickName.text.length == 0) {
        [UIAlertShow showAlertViewWithMsg:@"昵称不能为空！"];
    } else {
        NSString *phoneNumber = [UserInfo getUid];
        NSString *newNickName = self.nickName.text;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:phoneNumber forKey:@"phoneNumber"];
        [dic setObject:newNickName forKey:@"newNickName"];
    
        MKNetworkOperation *op = [ApplicationDelegate.httpEngine operationWithPath:@"changeNickName" params:dic httpMethod:@"POST"];
        [op addCompletionHandler:^(MKNetworkOperation *opeartion){
            NSDictionary *responseData = [opeartion responseJSON];
            NSInteger statusCode = [[responseData objectForKey:@"status"] integerValue];
            if (statusCode == 1) {
                MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:HUD];
                HUD.labelText = @"修改成功！";
                HUD.mode = MBProgressHUDModeText;
                [HUD showAnimated:YES whileExecutingBlock:^{
                    sleep(2);
                } completionBlock:^{
                    [HUD removeFromSuperview];
                    [self dismissViewControllerAnimated:YES completion:^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangedNickName" object:self.nickName.text];
                    }];
                    
                }];
            } else {
                [UIAlertShow showAlertViewWithMsg:[responseData objectForKey:@"message"]];
            }
            
            } errorHandler:^(MKNetworkOperation *errOp, NSError *err){
                [UIAlertShow showAlertViewWithMsg:@"网络异常"];
        }];
        [ApplicationDelegate.httpEngine enqueueOperation:op];
    }
}
@end
