//
//  OrderDetailViewController.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/6.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//


#import "OrderDetailViewController.h"
#import "WaitingForMatchView.h"
#import "WaitingForConfirmView.h"
#import "WaitingForPartnerConfirmView.h"
#import "PartnerCancelledView.h"
#import "MatchSuccessView.h"
#import "ErrorView.h"
#import "WaitingForPaymentView.h"
#import "OutOfDateView.h"


@implementation OrderDetailViewController


@synthesize srcLocationName = _srcLocationName;
@synthesize desLocationName = _desLocationName;
@synthesize startTime = _startTime;
@synthesize orderTime = _orderTime;

- (void)viewDidLoad {
    NSLog(@"OrderDetailViewController---viewDidLoad");
    [super viewDidLoad];
    
    // 监听发布请求后订单的信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beforeShowOrderDetail:) name:@"BeforeShowOrderDetail" object:nil];
    
    // 注册环信的代理
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    
    // 监听从后台到前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    statusViewY = 230;
    
    [self hideAllLabels];
    
    requestId = nil;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}


- (void) beforeShowOrderDetail:(NSNotification*)notification {
    NSLog(@"OrderDetailViewController---beforeShowOrderDetail");
    NSLog(@"111 = %@", [notification object]);
    
    NSDictionary *data = [notification object];
    requestId = [data objectForKey:@"requestId"];
    // 需要向服务器请求获得订单的状态,一般为从所有订单页面跳转至订单详情页面
    [self setOrderStatusView];

}

- (void)willEnterForeground:(NSNotification*)notification {
    NSLog(@"enter foreground");
    [self setOrderStatusView];
}

- (void) setOrderStatusView {
    NSLog(@"setOrderStatusView");
    NSDictionary *dic = [self setPostParams];
    NSLog(@"setOrderStatusView");
    NSLog(@"dic = %@", dic);
    NSLog(@"begin query status");
    MKNetworkOperation *op = [ApplicationDelegate.httpEngine operationWithPath:@"/queryRequest" params:dic httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSLog(@"%@", [operation responseJSON]);
        NSDictionary *response = [operation responseJSON];
        NSDictionary *detail = [response objectForKey:@"detail"];
        NSInteger statusCode = [[response objectForKey:@"status"] integerValue];
        if (statusCode == -1) {
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.mode = MBProgressHUDModeText;
            HUD.labelText = @"订单已取消，正在跳转...";
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [HUD removeFromSuperview];
                [self dismissViewControllerAnimated:YES completion:^{}];
            }];

        
        } else if (statusCode != ERROR_STATUS) {
            [self setOrderStatusViewByStatus:statusCode andDetail:detail];
        } else {
            [self setErrorView];
        }
        
    } errorHandler:^(MKNetworkOperation *errOp, NSError *err) {
        [self setErrorView];
        
    }];
    [ApplicationDelegate.httpEngine enqueueOperation:op];
}

- (void) setOrderStatusViewByStatus:(NSInteger)statusCode andDetail:(NSDictionary*)detail {
    NSLog(@"setOrderStatusViewByStatus");
    NSDictionary *partner, *me;
    if ([detail objectForKey:@"partner"] != nil) {
        partner = [detail objectForKey:@"partner"];
    }
    if ([detail objectForKey:@"me"] != nil) {
        me = [detail objectForKey:@"me"];
    } else if (statusCode == WAITING_FOR_PAYMENT || statusCode == OUT_OF_DATE || statusCode == ERROR_STATUS) {
        // 后端在这里直接在detail中返回me的信息，这里hack一下。
        me = detail;
    }
    NSLog(@"me=%@", me);

    if (me != nil) {
        self.srcLocationName.text = [me objectForKey:@"sourceName"];
        self.desLocationName.text = [me objectForKey:@"destinationName"];
        self.startTime.text = [me objectForKey:@"leavingTime"];
        remainChance = [[me objectForKey:@"remainChance"] integerValue];
    }    if ([detail objectForKey:@"orderTime"] != nil) {
        self.orderTime.text = [detail objectForKey:@"orderTime"];
    } else {
        self.orderTime.hidden = YES;
    }
    if ([detail objectForKey:@"route"] != nil) {
        route = [self getRouteWithDetail:detail];
        ApplicationDelegate.route = route;
    }
    [self showAllLabels];
    switch (statusCode) {
        case WAITING_WAITING:
            [self setWaitingForConfirmViewWithDetail:partner andSavePercent:[[detail objectForKey:@"savePercent"] floatValue]];
            break;
        case WAITING_CANCELLED:
            [self setPartnerCancelledView];
            break;
        case WAITING_CONFIRMED:
            [self setWaitingForConfirmViewWithDetail:partner andSavePercent:[[detail objectForKey:@"savePercent"] floatValue]];
            break;
        case CONFIRMED_WAITING:
            [self setWaitingPartnerConfirmView];
            break;
        case CONFIRMED_REFUSED:
            [self setPartnerCancelledView];
            break;
        case CONFIRMED_CONFIRMED:
            [self setMatchSuccessViewWithDetail:partner];
            break;
        case WAITING_FOR_MATCH:
            [self setWaitingForMatchView];
            break;
        case ERROR_STATUS:
            [self setErrorView];
            break;
        case WAITING_FOR_PAYMENT:
            deposit = [[detail objectForKey:@"deposit"] floatValue];
            [self setWaitingForPaymentView];
            break;
        case OUT_OF_DATE:
            [self setOutOfDateView];
            break;
        default:
            break;
    }
    
}


// 等待匹配
- (void) setWaitingForMatchView {
    NSLog(@"setWaitingForMatchView");
    WaitingForMatchView *statusView = [WaitingForMatchView instanceView];
    statusView.frame = CGRectMake(0, statusViewY, UISCREEN_WIDTH, 400);
    [self.view addSubview:statusView];
    [statusView.cancelBtn addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
}

// 收到匹配的结果，等待确认
- (void) setWaitingForConfirmViewWithDetail:(NSDictionary*)detail andSavePercent:(float)savePercent {
    NSLog(@"setWaitingForConfirmViewWithDetail");
    WaitingForConfirmView *statusView = [WaitingForConfirmView instanceView];
    statusView.frame = CGRectMake(0, statusViewY, UISCREEN_WIDTH, 400);
    [self.view addSubview:statusView];
    
    [statusView.confirmToMatch addTarget:self action:@selector(confirmToMatch) forControlEvents:UIControlEventTouchUpInside];
    [statusView.cancelToMatch addTarget:self action:@selector(cancelToMatch) forControlEvents:UIControlEventTouchUpInside];
    [statusView.nickname addTarget:self action:@selector(showPartnerDetailWithoutPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
    [statusView.showRouteBtn addTarget:self action:@selector(showRoute) forControlEvents:UIControlEventTouchUpInside];
    statusView.srcLocationName.text = [detail objectForKey:@"sourceName"];
    statusView.desLocationName.text = [detail objectForKey:@"destinationName"];
    statusView.startTime.text = [detail objectForKey:@"leavingTime"];
    [statusView.nickname setTitle:[detail objectForKey:@"name"] forState:UIControlStateNormal];
    partnerPhoneNumber = [detail objectForKey:@"phoneNumber"];
    statusView.savePercent.text = [NSString stringWithFormat:@"%.2f%%" ,savePercent * 100];
    if ([detail objectForKey:@"photo"] != nil) {
        [ImageOperator setImageView:statusView.imageView withUrlString:[detail objectForKey:@"photo"] inViewController:self];
    } else {
        [ImageOperator setDefaultImageView:statusView.imageView];
    }
}

// 自己确认，等待对方确认
- (void) setWaitingPartnerConfirmView {
    NSLog(@"setWaitingPartnerConfirmView");
    WaitingForPartnerConfirmView *statusView = [WaitingForPartnerConfirmView instanceView];
    statusView.frame = CGRectMake(0, statusViewY, UISCREEN_WIDTH, 400);
    
    [self.view addSubview:statusView];
    [statusView.cancelWaiting addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
}

// 对方取消
- (void) setPartnerCancelledView {
    NSLog(@"setPartnerCancelledView");
    PartnerCancelledView *statusView = [PartnerCancelledView instanceView];
    statusView.frame = CGRectMake(0, statusViewY, UISCREEN_WIDTH, 400);
    
    [self.view addSubview:statusView];
    [statusView.cancelWaitingForMatch addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
    [statusView.rewaitingForMatch addTarget:self action:@selector(rewaitingForMatch) forControlEvents:UIControlEventTouchUpInside];

}

// 双方都确认，拼车成功
- (void) setMatchSuccessViewWithDetail:(NSDictionary*)detail {
    NSLog(@"setMatchSuccessViewWithDetail");
    MatchSuccessView *statusView = [MatchSuccessView instanceView];
    statusView.frame = CGRectMake(0, statusViewY, UISCREEN_WIDTH, 400);
    
    [self.view addSubview:statusView];
    [statusView.finishOrder addTarget:self action:@selector(finishOrder) forControlEvents:UIControlEventTouchUpInside];
    [statusView.makecallBtn addTarget:self action:@selector(makeCall) forControlEvents:UIControlEventTouchUpInside];
    [statusView.nickName addTarget:self action:@selector(showPartenerDetailWithPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
    
    [statusView.nickName setTitle:[detail objectForKey:@"name"] forState:UIControlStateNormal];
    partnerPhoneNumber = [detail objectForKey:@"phoneNumber"];
    
    if ([detail objectForKey:@"photo"] != nil) {
        [ImageOperator setImageView:statusView.imageView withUrlString:[detail objectForKey:@"photo"] inViewController:self];
    } else {
        [ImageOperator setDefaultImageView:statusView.imageView];
    }
}

- (void) setErrorView {
    NSLog(@"setErrorView");
    ErrorView *statusView = [ErrorView instanceView];
    statusView.frame = CGRectMake(0, statusViewY, UISCREEN_WIDTH, 400);
    
    [self.view addSubview:statusView];
    [statusView.cancelOrder addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
}

- (void) setWaitingForPaymentView {
    NSLog(@"setWaitingForPaymentView");
    WaitingForPaymentView *statusView = [WaitingForPaymentView instanceView];
    statusView.frame = CGRectMake(0, statusViewY, UISCREEN_WIDTH, 400);
    [self.view addSubview:statusView];
    [statusView.payBtn addTarget:self action:@selector(payOrder) forControlEvents:UIControlEventTouchUpInside];
    [statusView.cancelRequest addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
}

- (void) setOutOfDateView {
    NSLog(@"setOutOfDateView");
    OutOfDateView *statusView = [OutOfDateView instanceView];
    statusView.frame = CGRectMake(0, statusViewY, UISCREEN_WIDTH, 400);
    [self.view addSubview:statusView];
    [statusView.backToHome addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
}

- (void) showPartenerDetailWithPhoneNumber {
    NSLog(@"showPartnerDetailWithPhoneNumber");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"SHOW" forKey:@"ShowPhoneNumber"];
    [dic setObject:partnerPhoneNumber forKey:@"partnerPhoneNumber"];
    [ScreenSwitch switchToScreenIn:@"Profile" withStoryboardIdentifier:@"PersonalInfoViewController" inView:self withNotificationName:@"ShowPartnerInfo" andObject:dic];
}

- (void) showPartnerDetailWithoutPhoneNumber {
    NSLog(@"showPartnerDetailWithoutPhoneNumber");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:partnerPhoneNumber forKey:@"partnerPhoneNumber"];
    [ScreenSwitch switchToScreenIn:@"Profile" withStoryboardIdentifier:@"PersonalInfoViewController" inView:self withNotificationName:@"ShowPartnerInfo" andObject:dic];
}

// 得到匹配结果后确认拼车
- (void) confirmToMatch {
    NSLog(@"confirmToMatch");
    NSNumber *responseNumber = [NSNumber numberWithInt:1];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:responseNumber forKey:@"response"];
    [dic setObject:requestId forKey:@"myRequestId"];
    MKNetworkOperation *op = [ApplicationDelegate.httpEngine operationWithPath:@"/responseToOpposite" params:dic httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSLog(@"%@", [operation responseJSON]);
        NSInteger statusCode = [[[operation responseJSON] objectForKey:@"status"] integerValue];
        if (statusCode == 1) {
            [self setOrderStatusView];
        } else {
            [UIAlertShow showAlertViewWithMsg:@"网络错误，请重试！10070"];
        }
        
    } errorHandler:^(MKNetworkOperation *errOp, NSError *err) {
        [UIAlertShow showAlertViewWithMsg:@"网络错误，请重试！10071"];
        
    }];
    [ApplicationDelegate.httpEngine enqueueOperation:op];
    NSLog(@"确认拼车");
}

// 得到匹配结果后放弃拼车,弹出对话框
- (void) cancelToMatch {
    NSLog(@"cancelToMatch");
    NSString *message = [NSString stringWithFormat:@"您共有%li次放弃的机会，是否确认放弃？", remainChance];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认放弃匹配？" message:message delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
    alert.tag = 0;
    [alert show];
}

// 在对话框中选择确认要放弃这个匹配
- (void) confirmCancelToMatch {
    NSLog(@"confirmCancelToMatch");
    NSNumber *responseNumber = [NSNumber numberWithInt:0];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:responseNumber forKey:@"response"];
    [dic setObject:requestId forKey:@"myRequestId"];
    
    MKNetworkOperation *op = [ApplicationDelegate.httpEngine operationWithPath:@"/responseToOpposite" params:dic httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSLog(@"%@", [operation responseJSON]);
        NSInteger statusCode = [[[operation responseJSON] objectForKey:@"status"] integerValue];
        if (statusCode == 1) {
            NSInteger remain = [[[operation responseJSON] objectForKey:@"detail"] integerValue];
            if (remain > 0) {
                NSString *message = @"是否重新等待匹配？";
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否重新等待匹配？" message:message delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
                alert.tag = 1;
                [alert show];

            } else {
                // 回到首页
                [ScreenSwitch switchToScreenIn:@"Main" withStoryboardIdentifier:@"TabBarController" inView:self];
            }
           
        } else {
            [UIAlertShow showAlertViewWithMsg:@"网络错误，请重试！10080"];
        }
        
    } errorHandler:^(MKNetworkOperation *errOp, NSError *err) {
        [UIAlertShow showAlertViewWithMsg:@"网络错误，请重试！10081"];
        
    }];
    [ApplicationDelegate.httpEngine enqueueOperation:op];
    NSLog(@"放弃拼车");
}

// 对方放弃后重新等待匹配
- (void) rewaitingForMatch {
    NSLog(@"rewaitingForMatch");
    NSDictionary *dic = [self setPostParams];
    MKNetworkOperation *op = [ApplicationDelegate.httpEngine operationWithPath:@"/rematch" params:dic httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSDictionary *response = [operation responseJSON];
        NSInteger statusCode = [[response objectForKey:@"status"] integerValue];
        if (statusCode == 1) {
            [self setWaitingForMatchView];
        } else {
            [UIAlertShow showAlertViewWithMsg:@"网络错误，请重试！10090"];
        }
        
    } errorHandler:^(MKNetworkOperation *errOp, NSError *err) {
        [UIAlertShow showAlertViewWithMsg:@"网络错误，请重试！10091"];
    }];
    [ApplicationDelegate.httpEngine enqueueOperation:op];
    NSLog(@"重新匹配");
}

// 取消订单
- (void) cancelOrder {
    NSLog(@"cancelOrder");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[UserInfo getUid] forKey:@"phoneNumber"];
    [dic setObject:requestId forKey:@"myRequestId"];

    
    MKNetworkOperation *op = [ApplicationDelegate.httpEngine operationWithPath:@"/cancelRequest" params:dic httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSLog(@"%@", [operation responseJSON]);
        NSInteger statusCode = [[[operation responseJSON] objectForKey:@"status"] integerValue];
        if (statusCode == 1) {
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.mode = MBProgressHUDModeText;
            HUD.labelText = @"取消成功...";
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2);
            } completionBlock:^{
                [HUD removeFromSuperview];
                [ScreenSwitch switchToScreenIn:@"Main" withStoryboardIdentifier:@"TabBarController" inView:self];
            }];
            
        } else {
            [UIAlertShow showAlertViewWithMsg:@"网络错误，请重试！10100"];
        }

    } errorHandler:^(MKNetworkOperation *errOp, NSError *err) {
        [UIAlertShow showAlertViewWithMsg:@"网络错误，请重试！10101"];
        
    }];
    [ApplicationDelegate.httpEngine enqueueOperation:op];
    NSLog(@"取消订单");

    
}

// 下车，完成拼单
- (void) finishOrder {
    NSLog(@"finishOrder");
    NSDictionary *dic = [self setPostParams];
    
    MKNetworkOperation *op = [ApplicationDelegate.httpEngine operationWithPath:@"/confirmOffBoard" params:dic httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSLog(@"%@", [operation responseJSON]);
        NSDictionary *response = [operation responseJSON];
        NSInteger statusCode = [[response objectForKey:@"status"] integerValue];
        if (statusCode == 1) {
            NSString *orderId = [response objectForKey:@"detail"];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:orderId forKey:@"requestId"];
            [dic setObject:[UserInfo getUid] forKey:@"phoneNumber"];
            [ScreenSwitch switchToScreenIn:@"Order" withStoryboardIdentifier:@"FinishedOrderDetailViewController" inView:self withNotificationName:@"BeforeShowOrderDetail_finished" andObject:dic];
        } else {
            [UIAlertShow showAlertViewWithMsg:@"网络错误！10110"];
        }
        
    } errorHandler:^(MKNetworkOperation *errOp, NSError *err) {
        [UIAlertShow showAlertViewWithMsg:@"网络错误！10111"];
    }];
    [ApplicationDelegate.httpEngine enqueueOperation:op];
    NSLog(@"完成拼单");
}

- (void)payOrder {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:requestId forKey:@"requestId"];
    [dic setObject:[NSNumber numberWithFloat:deposit] forKey:@"deposit"];
        [ScreenSwitch switchToScreenIn:@"Pay" withStoryboardIdentifier:@"PayViewController" inView:self withNotificationName:@"RequestInfo" andObject:dic];
}

- (void) makeCall {
    NSLog(@"makeCall");
    if (partnerPhoneNumber != nil) {
        NSString *phoneUrl = [NSString stringWithFormat:@"%@%@", @"tel://", partnerPhoneNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneUrl]];
        NSLog(@"calling %@", partnerPhoneNumber);
    } else {
        NSLog(@"Can't call");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backToHome:(id)sender {
    [ScreenSwitch switchToScreenIn:@"Main" withStoryboardIdentifier:@"TabBarController" inView:self];
}

// 显示路线信息
- (void) showRoute {
    [ScreenSwitch switchToScreenIn:@"Order" withStoryboardIdentifier:@"RouteSearchViewController" inView:self];
}

// 收到环信信息的回调
- (void) didReceiveMessage:(EMMessage *)message {
    NSLog(@"OrderDetailViewController---didReceiveMessage");
    NSLog(@"message=%@", message);
    NSLog(@"收到消息");
    NSInteger msgStatus;
    
    id<IEMMessageBody> msgBody = message.messageBodies.firstObject;
    if (msgBody.messageBodyType == eMessageBodyType_Text) {
        NSString *txt = ((EMTextMessageBody*)msgBody).text;
        msgStatus = [txt integerValue];
    }
    NSLog(@"%li", msgStatus);
    [self setOrderStatusView];
    

}

- (NSMutableDictionary*) setPostParams {
    NSLog(@"OrderDetailViewController---setPostParams");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[UserInfo getUid] forKey:@"phoneNumber"];
    [dic setObject:requestId forKey:@"myRequestId"];
    
    return dic;
}

// 根据后台路径规划得到的路线字符串获取路线信息，共有四个点
- (NSArray*) getRouteWithDetail:(NSDictionary*)detail{
    NSLog(@"getRouteWithDetail");
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *string = [detail objectForKey:@"route"];
    NSString *nameString = [detail objectForKey:@"routeNames"];
    NSArray *temp = [string componentsSeparatedByString:@","];
    NSArray *names = [nameString componentsSeparatedByString:@","];
    for (int i = 0; i < 4; i ++) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:temp[i * 2] forKey:@"lat"];
        [dic setObject:temp[i * 2 + 1] forKey:@"lng"];
        [dic setObject:names[i] forKey:@"name"];
        [array addObject:dic];
    }
    
    
    return array;
}

// 回到首页
- (void) backToHome {
    [ScreenSwitch switchToScreenIn:@"Main" withStoryboardIdentifier:@"TabBarController" inView:self];
    //[self dismissViewControllerAnimated:YES completion:^{}];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0) {
        if (buttonIndex == 0) {
            [self confirmCancelToMatch];
        }
    } else if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            [self rewaitingForMatch];
        } else {
            [ScreenSwitch switchToScreenIn:@"Main" withStoryboardIdentifier:@"TabBarController" inView:self];
        }
        
        
    }
}

- (void) hideAllLabels {
    self.srcLocationName.hidden = YES;
    self.desLocationName.hidden = YES;
    self.startTime.hidden = YES;
}

- (void) showAllLabels {
    self.srcLocationName.hidden = NO;
    self.desLocationName.hidden = NO;
    self.startTime.hidden = NO;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


@end

