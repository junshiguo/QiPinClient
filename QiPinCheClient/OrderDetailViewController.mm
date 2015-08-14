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



@implementation OrderDetailViewController


@synthesize srcLocationName = _srcLocationName;
@synthesize desLocationName = _desLocationName;
@synthesize startTime = _startTime;
@synthesize orderTime = _orderTime;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 监听发布请求后订单的信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beforeShowOrderDetail:) name:@"BeforeShowOrderDetail" object:nil];
    
    // 注册环信的代理
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    
    // 监听从后台到前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    // 适配iphone4S
    if (UISCREEN_HEIGHT < 500) statusViewY = 230;
    else statusViewY = 275;
    
}


- (void) beforeShowOrderDetail:(NSNotification*)notification {
    NSDictionary *data = [notification object];
    
    NSString *isCurrent = [data objectForKey:@"isCurrent"];
    requestId = [data objectForKey:@"orderId"];
    
    if (isCurrent != nil) {
        // 刚发布完成请求后立即跳转可以立刻获得一些信息，不需要向服务器请求
        self.srcLocationName.text = [data objectForKey:@"srcLocation"];
        self.desLocationName.text = [data objectForKey:@"desLocation"];;
        self.startTime.text = [data objectForKey:@"startTime"];
        [self setWaitingForMatchView];
    } else {
        // 需要向服务器请求获得订单的状态,一般为从所有订单页面跳转至订单详情页面
        [self setOrderStatusView];
    }

}

- (void)willEnterForeground:(NSNotification*)notification {
    NSLog(@"enter foreground");
    [self setOrderStatusView];
}

- (void) setOrderStatusView {
    //[self setWaitingPartnerConfirmView];
    //[self setMatchSuccessView];
    //[self setWaitingForConfirmView];
    //[self setWaitingForConfirmView];
    NSDictionary *dic = [self setPostParams];
    MKNetworkOperation *op = [ApplicationDelegate.httpEngine operationWithPath:@"/queryRequest" params:dic httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSLog(@"%@", [operation responseJSON]);
        NSDictionary *response = [operation responseJSON];
        NSDictionary *detail = [response objectForKey:@"detail"];
        NSInteger statusCode = [[response objectForKey:@"status"] integerValue];
        self.srcLocationName.text = [detail objectForKey:@"mySrc"];
        self.desLocationName.text = [detail objectForKey:@"myDest"];
        self.startTime.text = [detail objectForKey:@"myTime"];
        [self setOrderStatusViewByStatus:statusCode andDetail:detail];
        
    } errorHandler:^(MKNetworkOperation *errOp, NSError *err) {
        [self setErrorView];
        
    }];
    [ApplicationDelegate.httpEngine enqueueOperation:op];
}

- (void) setOrderStatusViewByStatus:(NSInteger)statusCode andDetail:(NSDictionary*)detail {
    switch (statusCode) {
        case WAITING_WAITING:
            [self setWaitingForConfirmViewWithDetail:detail];
            break;
        case WAITING_CANCELLED:
            [self setPartnerCancelledView];
            break;
        case WAITING_CONFIRMED:
            break;
        case CONFIRMED_WAITING:
            [self setWaitingPartnerConfirmView];
            break;
        case CONFIRMED_REFUSED:
            [self setPartnerCancelledView];
            break;
        case CONFIRMED_CONFIRMED:
            [self setMatchSuccessViewWithDetail:detail];
        case WAITING_FOR_MATCH:
            [self setWaitingForMatchView];
        case ERROR_STATUS:
            
        default:
            break;
    }
    
}


- (void) setWaitingForMatchView {
    WaitingForMatchView *statusView = [WaitingForMatchView instanceView];
    statusView.frame = CGRectMake(0, statusViewY, UISCREEN_WIDTH, 400);
    [self.view addSubview:statusView];
    [statusView.cancelBtn addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
}

// 收到匹配的结果，等待确认
- (void) setWaitingForConfirmViewWithDetail:(NSDictionary*)detail {
    WaitingForConfirmView *statusView = [WaitingForConfirmView instanceView];
    statusView.frame = CGRectMake(0, statusViewY, UISCREEN_WIDTH, 400);
    [self.view addSubview:statusView];
    
    [statusView.confirmToMatch addTarget:self action:@selector(confirmToMatch) forControlEvents:UIControlEventTouchUpInside];
    [statusView.cancelToMatch addTarget:self action:@selector(cancelToMatch) forControlEvents:UIControlEventTouchUpInside];
    [statusView.nickname addTarget:self action:@selector(showPartnerDetailWithoutPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
    statusView.srcLocationName.text = [detail objectForKey:@"partnerSrc"];
    statusView.desLocationName.text = [detail objectForKey:@"partnerDest"];
    statusView.startTime.text = [detail objectForKey:@"partnerTime"];
    [statusView.nickname setTitle:[detail objectForKey:@"partnerNickName"] forState:UIControlStateNormal];
    partnerPhoneNumber = [detail objectForKey:@"partnerPhoneNumber"];
    
}

// 自己确认，等待对方确认
- (void) setWaitingPartnerConfirmView {
    WaitingForPartnerConfirmView *statusView = [WaitingForPartnerConfirmView instanceView];
    statusView.frame = CGRectMake(0, statusViewY, UISCREEN_WIDTH, 400);
    
    [self.view addSubview:statusView];
    [statusView.cancelWaiting addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
}

// 对方取消
- (void) setPartnerCancelledView {
    PartnerCancelledView *statusView = [PartnerCancelledView instanceView];
    statusView.frame = CGRectMake(0, statusViewY, UISCREEN_WIDTH, 400);
    
    [self.view addSubview:statusView];
    [statusView.cancelWaitingForMatch addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
    [statusView.rewaitingForMatch addTarget:self action:@selector(rewaitingForMatch) forControlEvents:UIControlEventTouchUpInside];

}

// 双方都确认，拼车成功
- (void) setMatchSuccessViewWithDetail:(NSDictionary*)detail {
    MatchSuccessView *statusView = [MatchSuccessView instanceView];
    statusView.frame = CGRectMake(0, statusViewY, UISCREEN_WIDTH, 400);
    
    [self.view addSubview:statusView];
    [statusView.finishOrder addTarget:self action:@selector(finishOrder) forControlEvents:UIControlEventTouchUpInside];
    [statusView.makecallBtn addTarget:self action:@selector(makeCall) forControlEvents:UIControlEventTouchUpInside];
    [statusView.nickName addTarget:self action:@selector(showPartenerDetailWithPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
    
    [statusView.nickName setTitle:[detail objectForKey:@"partnerNickName"] forState:UIControlStateNormal];
    partnerPhoneNumber = [detail objectForKey:@"partnerPhoneNumber"];
}

- (void) setErrorView {
    ErrorView *statusView = [ErrorView instanceView];
    statusView.frame = CGRectMake(0, statusViewY, UISCREEN_WIDTH, 400);
    
    [self.view addSubview:statusView];
    [statusView.cancelOrder addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
}

- (void) showPartenerDetailWithPhoneNumber {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"SHOW" forKey:@"ShowPhoneNumber"];
    [dic setObject:partnerPhoneNumber forKey:@"PartnerPhoneNumber"];
    [ScreenSwitch switchToScreenIn:@"Profile" withStoryboardIdentifier:@"PersonalInfoViewController" inView:self withNotificationName:@"ShowPartnerInfo" andObject:dic];
}

- (void) showPartnerDetailWithoutPhoneNumber {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:partnerPhoneNumber forKey:@"PartnerPhoneNumber"];
    [ScreenSwitch switchToScreenIn:@"Profile" withStoryboardIdentifier:@"PersonalInfoViewController" inView:self withNotificationName:@"ShowPartnerInfo" andObject:dic];
}

// 得到匹配结果后确认拼车
- (void) confirmToMatch {
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
            [UIAlertShow showAlertViewWithMsg:@"网络错误，请重试！"];
        }
        
    } errorHandler:^(MKNetworkOperation *errOp, NSError *err) {
        [UIAlertShow showAlertViewWithMsg:@"网络错误，请重试！"];
        
    }];
    [ApplicationDelegate.httpEngine enqueueOperation:op];
    NSLog(@"确认拼车");
}

// 得到匹配结果后放弃拼车
- (void) cancelToMatch {
    NSNumber *responseNumber = [NSNumber numberWithInt:0];
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
            [UIAlertShow showAlertViewWithMsg:@"网络错误，请重试！"];
        }
        
    } errorHandler:^(MKNetworkOperation *errOp, NSError *err) {
        [UIAlertShow showAlertViewWithMsg:@"网络错误，请重试！"];
        
    }];
    [ApplicationDelegate.httpEngine enqueueOperation:op];
    NSLog(@"放弃拼车");
}

// 对方放弃后重新等待匹配
- (void) rewaitingForMatch {
    [self setWaitingForMatchView];
    NSLog(@"重新匹配");
}

// 取消订单
- (void) cancelOrder {
    NSDictionary *dic = [self setPostParams];
    
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
            [UIAlertShow showAlertViewWithMsg:@"网络错误，请重试！"];
        }

    } errorHandler:^(MKNetworkOperation *errOp, NSError *err) {
        [UIAlertShow showAlertViewWithMsg:@"网络错误，请重试！"];
        
    }];
    [ApplicationDelegate.httpEngine enqueueOperation:op];
    NSLog(@"取消订单");

    
}

// 下车，完成拼单
- (void) finishOrder {
    NSDictionary *dic = [self setPostParams];
    
    MKNetworkOperation *op = [ApplicationDelegate.httpEngine operationWithPath:@"/finishOrder" params:dic httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSLog(@"%@", [operation responseJSON]);
        
    } errorHandler:^(MKNetworkOperation *errOp, NSError *err) {
        
    }];
    [ApplicationDelegate.httpEngine enqueueOperation:op];
    NSLog(@"完成拼单");
}


- (void) makeCall {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://18817361981"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self setOrderStatusView];
}



- (IBAction)backToHome:(id)sender {
    [ScreenSwitch switchToScreenIn:@"Main" withStoryboardIdentifier:@"TabBarController" inView:self];
}

// 收到环信信息的回调
- (void) didReceiveMessage:(EMMessage *)message {
    NSLog(@"message=%@", message);
    NSLog(@"收到消息");
    NSInteger msgStatus;
    
    id<IEMMessageBody> msgBody = message.messageBodies.firstObject;
    if (msgBody.messageBodyType == eMessageBodyType_Text) {
        NSString *txt = ((EMTextMessageBody*)msgBody).text;
        msgStatus = [txt integerValue];
    }
    NSLog(@"%li", msgStatus);
    switch (msgStatus) {
        case WAITING_WAITING:
            //收到匹配成功地结果
            //[self setWaitingForConfirmView];
            [self setOrderStatusView];
            break;
        case CONFIRMED_CONFIRMED:
            //收到对方的结果
            //[self setMatchSuccessView];
            [self setOrderStatusView];
            break;
        case WAITING_CANCELLED:
            //收到对方拒绝的结果
            [self setPartnerCancelledView];
            //[self setOrderStatusView];
            break;
        case CONFIRMED_REFUSED:
            [self setPartnerCancelledView];
            //[self setOrderStatusView];
            break;
        default:
            NSLog(@"非法环信消息");
            break;
    }
    

}

// 收到环信cmd信息的回调
- (void) didReceiveCmdMessage:(EMMessage *)cmdMessage {
    NSLog(@"%@", cmdMessage);
    NSLog(@"收到cmd消息");
}

- (void) didReceiveOfflineCmdMessages:(NSArray *)offlineCmdMessages {
    NSLog(@"收到离线消息");
}

- (NSMutableDictionary*) setPostParams {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[UserInfo getUid] forKey:@"phoneNumber"];
    [dic setObject:requestId forKey:@"requestId"];
    
    return dic;
}

@end

