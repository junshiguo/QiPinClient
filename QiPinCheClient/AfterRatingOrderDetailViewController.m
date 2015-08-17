//
//  AfterRatingOrderDetailViewController.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/11.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "AfterRatingOrderDetailViewController.h"

@interface AfterRatingOrderDetailViewController ()

@end

@implementation AfterRatingOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beforeShowOrderDetail:) name:@"BeforeShowOrderDetail" object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) beforeShowOrderDetail:(NSNotification*) notification {
    if ([UserInfo getUid] != nil) {
        // 判断处于登录状态
        NSDictionary *dic = [notification object];
        MKNetworkOperation *op = [ApplicationDelegate.httpEngine operationWithPath:@"queryOrder" params:dic httpMethod:@"POST"];
        [op addCompletionHandler:^(MKNetworkOperation *operation) {
            NSDictionary *response = [operation responseJSON];
            NSInteger statusCode = [[response objectForKey:@"status"] integerValue];
            if (statusCode == 1) {
                NSDictionary *dic = [response objectForKey:@"detail"];
                NSDictionary *me = [dic objectForKey:@"me"];
                NSDictionary *partner = [dic objectForKey:@"partner"];
                
                self.srcLocation.text = [me objectForKey:@"sourceLocation"];
                self.desLocation.text = [me objectForKey:@"destinationLocation"];
                self.startTime.text = [me objectForKey:@"leavingTime"];
                self.score.text = [dic objectForKey:@"score"];
                
                partnerPhoneNumber = [partner objectForKey:@"partner"];
                self.nickName = [partner objectForKey:@"name"];
                
            } else {
                [UIAlertShow showAlertViewWithMsg:@"网络错误！"];
            }
            
            
        } errorHandler:^(MKNetworkOperation *errOp, NSError *err) {
            [UIAlertShow showAlertViewWithMsg:@"网络错误！"];
            
        }];
        [ApplicationDelegate.httpEngine enqueueOperation:op];
    }
    
}


- (IBAction)showPartnerDetail:(id)sender {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:partnerPhoneNumber forKey:@"partnerPhoneNumber"];
    
    [ScreenSwitch switchToScreenIn:@"Profile" withStoryboardIdentifier:@"PersonalInfoViewController" inView:self withNotificationName:@"ShowPartnerInfo" andObject:dic];
}
@end
