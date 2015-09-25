//
//  FinishedOrderDetailViewController.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/10.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "FinishedOrderDetailViewController.h"
#import "TQStarRatingView.h"

@implementation FinishedOrderDetailViewController

- (void)viewDidLoad {
    NSLog(@"FinishedOrderDetailViewController");
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beforeShowOrderDetail:) name:@"BeforeShowOrderDetail_finished" object:nil];
    
    float x = 31;
    float y = 335;
    TQStarRatingView *starRatingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(x, y, 200, 40) numberOfStar:5];
    
    starRatingView.delegate = self;
    [self.view addSubview:starRatingView];

    [self hideAllLabels];
    
    rating = 5;
    
}

- (void) beforeShowOrderDetail:(NSNotification*) notification {
    NSLog(@"FinishedOrderDetailViewController---beforeShowOrderDetail");
    if ([UserInfo getUid] != nil) {
        // 判断处于登录状态
        NSLog(@"beforeShowOrderDetail");
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        requestId = [[notification object] objectForKey:@"requestId"];
        [dic setObject:requestId forKey:@"myRequestId"];
        [dic setObject:[UserInfo getUid] forKey:@"phoneNumber"];
        NSLog(@"%@", dic);
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
                orderId = [dic objectForKey:@"orderId"];
                partnerPhoneNumber = [partner objectForKey:@"phoneNumber"];
                self.deposit.text = [NSString stringWithFormat:@"%.2f元", [[payment objectForKey:@"deposit"] floatValue]/100 - [[payment objectForKey:@"tip"] floatValue]/100];
                
                // 退还时间
                NSString *timeString = [payment objectForKey:@"expRefundTime"];
                self.depositDescription.text = [NSString stringWithFormat:@"%@ 退还", timeString];

                if ([partner objectForKey:@"photo"] != nil) {
                    [ImageOperator setImageView:self.imageView withUrlString:[partner objectForKey:@"photo"] inViewController:self];
                } else {
                    [ImageOperator setDefaultImageView:self.imageView];
                }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)starRatingView:(TQStarRatingView *)view score:(float)score {
    self.score.text = [NSString stringWithFormat:@"%i分", (int)score * 1];
    rating = (int)score;
}


- (IBAction)back:(id)sender {
    [ScreenSwitch switchToScreenIn:@"Main" withStoryboardIdentifier:@"TabBarController" inView:self];
}

- (IBAction)showPartenerDetail:(id)sender {
    NSLog(@"FinishedOrderDetailViewController---showPartnerDetail");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:partnerPhoneNumber forKey:@"partnerPhoneNumber"];
    [dic setObject:@"SHOW" forKey:@"ShowPhoneNumber"];
    
    [ScreenSwitch switchToScreenIn:@"Profile" withStoryboardIdentifier:@"PersonalInfoViewController" inView:self withNotificationName:@"ShowPartnerInfo" andObject:dic];
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

- (IBAction)startToRate:(id)sender {
    NSLog(@"startToRate");
    //发送打分请求
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[UserInfo getUid] forKey:@"myPhoneNumber"];
    [dic setObject:partnerPhoneNumber forKey:@"partnerPhoneNumber"];
    [dic setObject:orderId forKey:@"orderId"];
    [dic setObject:[NSNumber numberWithInteger:rating] forKey:@"rating"];
    
    MKNetworkOperation *op = [ApplicationDelegate.httpEngine operationWithPath:@"/addRating" params:dic httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSDictionary *response = [operation responseJSON];
        NSInteger statusCode = [[response objectForKey:@"status"] integerValue];
        if (statusCode == 1) {
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.mode = MBProgressHUDModeText;
            HUD.labelText = @"评价成功，正在跳转...";
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(1.5);
            } completionBlock:^{
                [HUD removeFromSuperview];
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setObject:requestId forKey:@"requestId"];
                [dic setObject:[UserInfo getUid] forKey:@"phoneNumber"];
                [ScreenSwitch switchToScreenIn:@"Order" withStoryboardIdentifier:@"AfterRatingOrderDetailViewController" inView:self withNotificationName:@"BeforeShowOrderDetail_after" andObject:dic];
            }];
        } else {
            [UIAlertShow showAlertViewWithMsg:@"网络错误！"];
        }
        
    } errorHandler:^(MKNetworkOperation *errOp, NSError *err) {
        [UIAlertShow showAlertViewWithMsg:@"网络错误"];
        
    }];
    [ApplicationDelegate.httpEngine enqueueOperation:op];

}

- (void)dealloc {
    
    //[super dealloc];  非ARC中需要调用此句
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
@end
