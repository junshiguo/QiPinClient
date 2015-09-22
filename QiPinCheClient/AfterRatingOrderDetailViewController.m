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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beforeShowOrderDetail:) name:@"BeforeShowOrderDetail_after" object:nil];
    
    [self hideAllLabels];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) beforeShowOrderDetail:(NSNotification*) notification {
    NSLog(@"beforeShowOrderDetail");
    if ([UserInfo getUid] != nil) {
        // 判断处于登录状态
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[[notification object] objectForKey:@"requestId"] forKey:@"myRequestId"];
        [dic setObject:[UserInfo getUid] forKey:@"phoneNumber"];
        MKNetworkOperation *op = [ApplicationDelegate.httpEngine operationWithPath:@"/queryRequest" params:dic httpMethod:@"POST"];
        [op addCompletionHandler:^(MKNetworkOperation *operation) {
            NSDictionary *response = [operation responseJSON];
            NSLog(@"%@", response);
            NSInteger statusCode = [[response objectForKey:@"status"] integerValue];
            if (statusCode != -1) {
                NSDictionary *dic = [response objectForKey:@"detail"];
                NSDictionary *me = [dic objectForKey:@"me"];
                NSDictionary *partner = [dic objectForKey:@"partner"];
                NSDictionary *payment = [dic objectForKey:@"payment"];
                
                self.srcLocation.text = [me objectForKey:@"sourceName"];
                self.desLocation.text = [me objectForKey:@"destinationName"];
                self.startTime.text = [me objectForKey:@"leavingTime"];
                int rating = [[dic objectForKey:@"rating"] intValue];
                NSString *scoreText = [NSString stringWithFormat:@"%i.0", rating];
                self.score.text = scoreText;
                self.deposit.text = [NSString stringWithFormat:@"%.2f元", [[payment objectForKey:@"deposit"] floatValue]/100];
                self.depositDescription.text = [NSString stringWithFormat:@"%@ 退还", [payment objectForKey:@"expRefundTime"]];
                partnerPhoneNumber = [partner objectForKey:@"phoneNumber"];
                
                if ([partner objectForKey:@"photo"] != nil) {
                    [ImageOperator setImageView:self.imageView withUrlString:[partner objectForKey:@"photo"] inViewController:self];
                } else {
                    [ImageOperator setDefaultImageView:self.imageView];
                }
                [self.nickName setTitle:[partner objectForKey:@"name"] forState:UIControlStateNormal];
                
                
                [self showAllLabels];
                
            } else {
                [UIAlertShow showAlertViewWithMsg:@"网络错误！10010"];
            }
            
            
        } errorHandler:^(MKNetworkOperation *errOp, NSError *err) {
            [UIAlertShow showAlertViewWithMsg:@"网络错误！10011"];
            
        }];
        [ApplicationDelegate.httpEngine enqueueOperation:op];
    }
    
}


- (IBAction)showPartnerDetail:(id)sender {
    NSLog(@"showPartnerDetail");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:partnerPhoneNumber forKey:@"partnerPhoneNumber"];
    [dic setObject:@"SHOW" forKey:@"ShowPhoneNumber"];
    [ScreenSwitch switchToScreenIn:@"Profile" withStoryboardIdentifier:@"PersonalInfoViewController" inView:self withNotificationName:@"ShowPartnerInfo" andObject:dic];
}

- (IBAction)back:(id)sender {
    [ScreenSwitch switchToScreenIn:@"Main" withStoryboardIdentifier:@"TabBarController" inView:self];

}

- (void) hideAllLabels {
    self.srcLocation.hidden = YES;
    self.desLocation.hidden = YES;
    self.startTime.hidden = YES;
    self.deposit.hidden = YES;
    self.depositDescription.hidden = YES;
    self.score.hidden = YES;
}

- (void) showAllLabels {
    self.srcLocation.hidden = NO;
    self.desLocation.hidden = NO;
    self.startTime.hidden = NO;
    self.deposit.hidden = NO;
    self.depositDescription.hidden = NO;
    self.score.hidden = NO;
}

- (void)dealloc {
    
    //[super dealloc];  非ARC中需要调用此句
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end
