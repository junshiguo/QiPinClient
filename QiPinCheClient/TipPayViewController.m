//
//  TipPayViewController.m
//  QiPinCheClient
//
//  Created by Shijia on 15/9/23.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "TipPayViewController.h"

@interface TipPayViewController ()

@end

@implementation TipPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTipInfo:) name:@"TipPayInfo" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.tipSelector.selectedSegmentIndex = 2;
}

- (void)getTipInfo:(NSNotification*)notification {
    NSDictionary *dic = [notification object];
    requestId = [dic objectForKey:@"requestId"];
}

- (IBAction)confirmPayTip:(id)sender {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:requestId forKey:@"requestId"];
    int tipAmount = [self getTipAmount];
    [dic setObject:[NSNumber numberWithInt:tipAmount] forKey:@"amount"];
    MKNetworkOperation *op = [ApplicationDelegate.httpEngine operationWithPath:@"/payForTip" params:dic httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSDictionary *dic = [operation responseJSON];
        NSInteger statusCode = [[dic objectForKey:@"status"] integerValue];
        if (statusCode == 1) {
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.mode = MBProgressHUDModeText;
            HUD.labelText = @"打赏成功！费用将会在您的押金中抵扣！";
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [HUD removeFromSuperview];
                NSDictionary *requestInfo = [self setRequestInfo];
                [ScreenSwitch switchToScreenIn:@"Order" withStoryboardIdentifier:@"FinishedOrderDetailViewController" inView:self withNotificationName:@"BeforeShowOrderDetail_finished" andObject:requestInfo];
            }];

            
        } else {
            [UIAlertShow showAlertViewWithMsg:@"获取支付信息失败！请稍后再试！"];
        }
        
        
    } errorHandler:^(MKNetworkOperation *errOp, NSError *err) {
        [UIAlertShow showAlertViewWithMsg:@"网络错误，获取支付信息失败！"];
        
    }];
    [ApplicationDelegate.httpEngine enqueueOperation:op];

    
}




- (IBAction)cancelTipOnClick:(id)sender {
    NSDictionary *dic = [self setRequestInfo];
    
    [ScreenSwitch switchToScreenIn:@"Order" withStoryboardIdentifier:@"FinishedOrderDetailViewController" inView:self withNotificationName:@"BeforeShowOrderDetail_finished" andObject:dic];
}

- (int) getTipAmount {
    switch ([self.tipSelector selectedSegmentIndex]) {
        case 0:
            return 100;
            break;
        case 1:
            return 200;
        case 2:
            return 500;
        default:
            return 1;
            break;
    }
}

- (NSDictionary*) setRequestInfo {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:requestId forKey:@"requestId"];
    [dic setObject:[UserInfo getUid] forKey:@"phoneNumber"];
    
    return dic;
}
@end
