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
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beforeShowOrderDetail:) name:@"BeforeShowOrderDetail" object:nil];
    
    float x = 31;
    float y = 320;
    TQStarRatingView *starRatingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(x, y, 200, 40) numberOfStar:5];
    
    starRatingView.delegate = self;
    [self.view addSubview:starRatingView];

    
}

- (void) beforeShowOrderDetail:(NSNotification*) notification {
    if ([UserInfo getUid] != nil) {
        // 判断处于登录状态
        NSMutableDictionary *dic = [notification object];
        [dic setObject:[UserInfo getUid] forKey:@"phoneNumber"];
        MKNetworkOperation *op = [ApplicationDelegate.httpEngine operationWithPath:@"/queryOrder" params:dic httpMethod:@"POST"];
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
                
                partnerPhoneNumber = [partner objectForKey:@"phoneNumber"];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)starRatingView:(TQStarRatingView *)view score:(float)score {
    self.score.text = [NSString stringWithFormat:@"%0.2f分",score * 5];
    
    //发送打分请求
}


- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)showPartenerDetail:(id)sender {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:partnerPhoneNumber forKey:@"partnerPhoneNumber"];
    
    [ScreenSwitch switchToScreenIn:@"Profile" withStoryboardIdentifier:@"PersonalInfoViewController" inView:self withNotificationName:@"ShowPartnerInfo" andObject:dic];
}
@end
