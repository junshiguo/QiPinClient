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
    
    [self hideAllLabels];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) beforeShowOrderDetail:(NSNotification*) notification {
    if ([UserInfo getUid] != nil) {
        // 判断处于登录状态
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[[notification object] objectForKey:@"requestId"] forKey:@"requestId"];
        [dic setObject:[UserInfo getUid] forKey:@"phoneNumber"];
        MKNetworkOperation *op = [ApplicationDelegate.httpEngine operationWithPath:@"/queryOrder" params:dic httpMethod:@"POST"];
        [op addCompletionHandler:^(MKNetworkOperation *operation) {
            NSDictionary *response = [operation responseJSON];
            NSInteger statusCode = [[response objectForKey:@"status"] integerValue];
            if (statusCode == 1) {
                NSDictionary *dic = [response objectForKey:@"detail"];
                NSDictionary *me = [dic objectForKey:@"me"];
                NSDictionary *partner = [dic objectForKey:@"partner"];
                
                self.srcLocation.text = [me objectForKey:@"sourceName"];
                self.desLocation.text = [me objectForKey:@"destinationName"];
                self.startTime.text = [me objectForKey:@"leavingTime"];
                NSLog(@"%@", dic);
                NSString *scoreText = [NSString stringWithFormat:@"%li.0", [[dic objectForKey:@"rating"] integerValue]];
                NSLog(@"score=%@", scoreText);
                self.score.text = scoreText;
                
                partnerPhoneNumber = [partner objectForKey:@"phoneNumber"];
                [self.nickName setTitle:[partner objectForKey:@"name"] forState:UIControlStateNormal];
                [self showAllLabels];
                
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
    [dic setObject:@"SHOW" forKey:@"ShowPhoneNumber"];
    [ScreenSwitch switchToScreenIn:@"Profile" withStoryboardIdentifier:@"PersonalInfoViewController" inView:self withNotificationName:@"ShowPartnerInfo" andObject:dic];
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void) hideAllLabels {
    self.srcLocation.hidden = YES;
    self.desLocation.hidden = YES;
    self.startTime.hidden = YES;
    self.cash.hidden = YES;
    self.cashDescription.hidden = YES;
    self.score.hidden = YES;
}

- (void) showAllLabels {
    self.srcLocation.hidden = NO;
    self.desLocation.hidden = NO;
    self.startTime.hidden = NO;
    self.cash.hidden = NO;
    self.cashDescription.hidden = NO;
    self.score.hidden = NO;
}

@end
