//
//  ModifyJobViewController.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/9.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "ModifyJobViewController.h"

@interface ModifyJobViewController ()

@end

@implementation ModifyJobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)save:(id)sender {
    if (self.job.text.length == 0) {
        [UIAlertShow showAlertViewWithMsg:@"职业不能为空！"];
    } else {
        NSString *phoneNumber = [UserInfo getUid];
        NSString *newNickName = self.job.text;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:phoneNumber forKey:@"phoneNumber"];
        [dic setObject:newNickName forKey:@"job"];
        
        MKNetworkOperation *op = [ApplicationDelegate.httpEngine operationWithPath:@"/changeJob" params:dic httpMethod:@"POST"];
        [op addCompletionHandler:^(MKNetworkOperation *opeartion){
            NSDictionary *responseData = [opeartion responseJSON];
            NSInteger statusCode = [[responseData objectForKey:@"status"] integerValue];
            NSLog(@"%@", responseData);
            if (statusCode == 1) {
                MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:HUD];
                HUD.mode = MBProgressHUDModeText;
                HUD.labelText = @"修改成功！";
                [HUD showAnimated:YES whileExecutingBlock:^{
                    sleep(2);
                } completionBlock:^{
                    [HUD removeFromSuperview];
                    [self dismissViewControllerAnimated:YES completion:^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangedJob" object:self.job.text];
                    }];
                    
                }];
                
                
                
            } else {
                [UIAlertShow showAlertViewWithMsg:[responseData objectForKey:@"message"]];
            }
            
        } errorHandler:^(MKNetworkOperation *errOp, NSError *err){
            [UIAlertShow showAlertViewWithMsg:@"网络异常！"];
        }];
        [ApplicationDelegate.httpEngine enqueueOperation:op];
    }

}
@end
