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
    
    if (UISCREEN_HEIGHT < 500) statusViewY = 230;
    else statusViewY = 275;
    
}


- (void) beforeShowOrderDetail:(NSNotification*)notification {
    NSDictionary *data = [notification object];
    
    NSString *isCurrent = [data objectForKey:@"isCurrent"];
    orderId = [data objectForKey:@"orderId"];
    
    if (isCurrent != nil) {
        // 刚发布完成请求后立即跳转可以立刻获得一些信息，不需要向服务器请求
        orderType = [[data objectForKey:@"orderType"] integerValue];
        srcLocationName = [data objectForKey:@"srcLocation"];
        desLocationName = [data objectForKey:@"desLocation"];
        startTime = [data objectForKey:@"startTime"];
    
        self.srcLocationName.text = srcLocationName;
        self.desLocationName.text = desLocationName;
        self.startTime.text = startTime;
        self.orderTime.text = orderTime;
    } else {
        // 需要向服务器请求获得订单的状态,一般为从所有订单页面跳转至订单详情页面
        [self setOrderStatusView];
    }

}

- (void)willEnterForeground:(NSNotification*)notification {
    NSLog(@"enter for");
    [self setOrderStatusView];
}

- (void) setOrderStatusView {
    //[self setWaitingPartnerConfirmView];
    //[self setMatchSuccessView];
    //[self setWaitingForConfirmView];
    [self setWaitingForConfirmView];
}

- (void) setWaitingForMatchView {
    WaitingForMatchView *statusView = [WaitingForMatchView instanceView];
    statusView.frame = CGRectMake(0, statusViewY, UISCREEN_WIDTH, 400);
    [self.view addSubview:statusView];
    [statusView.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

// 收到匹配的结果，等待确认
- (void) setWaitingForConfirmView {
    WaitingForConfirmView *statusView = [WaitingForConfirmView instanceView];
    statusView.frame = CGRectMake(0, statusViewY, UISCREEN_WIDTH, 400);
    [self.view addSubview:statusView];
    
    [statusView.confirmToMatch addTarget:self action:@selector(confirmToMatch) forControlEvents:UIControlEventTouchUpInside];
    [statusView.cancelToMatch addTarget:self action:@selector(cancelToMatch) forControlEvents:UIControlEventTouchUpInside];
    [statusView.nickname addTarget:self action:@selector(showPartenerDetail) forControlEvents:UIControlEventTouchUpInside];
    
    // 发送请求
}

// 自己确认，等待对方确认
- (void) setWaitingPartnerConfirmView {
    WaitingForPartnerConfirmView *statusView = [WaitingForPartnerConfirmView instanceView];
    statusView.frame = CGRectMake(0, statusViewY, UISCREEN_WIDTH, 400);
    
    [self.view addSubview:statusView];
    [statusView.cancelWaiting addTarget:self action:@selector(cancelWaitingPartner) forControlEvents:UIControlEventTouchUpInside];
}

// 对方取消
- (void) setPartnerCancelledView {
    PartnerCancelledView *statusView = [PartnerCancelledView instanceView];
    statusView.frame = CGRectMake(0, statusViewY, UISCREEN_WIDTH, 400);
    
    [self.view addSubview:statusView];
    [statusView.cancelWaitingForMatch addTarget:self action:@selector(cancelWaitingForMatch) forControlEvents:UIControlEventTouchUpInside];
    [statusView.rewaitingForMatch addTarget:self action:@selector(rewaitingForMatch) forControlEvents:UIControlEventTouchUpInside];

}

// 双方都确认，拼车成功
- (void) setMatchSuccessView {
    MatchSuccessView *statusView = [MatchSuccessView instanceView];
    statusView.frame = CGRectMake(0, statusViewY, UISCREEN_WIDTH, 400);
    
    [self.view addSubview:statusView];
    [statusView.finishOrder addTarget:self action:@selector(finishOrder) forControlEvents:UIControlEventTouchUpInside];
    [statusView.makecallBtn addTarget:self action:@selector(makeCall) forControlEvents:UIControlEventTouchUpInside];
    [statusView.nickName addTarget:self action:@selector(showPartenerDetail) forControlEvents:UIControlEventTouchUpInside];
}

- (void) showPartenerDetail {
    [ScreenSwitch switchToScreenIn:@"Profile" withStoryboardIdentifier:@"PersonalInfoViewController" inView:self];
}

// 在等待对方确认的页面取消拼车
- (void) cancelWaitingPartner {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:orderId forKey:@"orderId"];
    [dic setObject:[UserInfo getUid] forKey:@"phoneNumber"];
    

    MKNetworkOperation *op = [ApplicationDelegate.httpEngine operationWithPath:@"/cancelOrder" params:dic httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        
    } errorHandler:^(MKNetworkOperation *errOp, NSError *err) {
        
    }];
    NSLog(@"不等了");
}

// 得到匹配结果后确认拼车
- (void) confirmToMatch {
    
    NSLog(@"确认拼车");
}

// 得到匹配结果后放弃拼车
- (void) cancelToMatch {
    NSLog(@"放弃拼车");
}

// 对方放弃后放弃拼单
- (void) cancelWaitingForMatch {
    NSLog(@"不重新等待了");
}

// 对方放弃后重新等待匹配
- (void) rewaitingForMatch {
    NSLog(@"重新匹配");
}

// 下车，完成拼单
- (void) finishOrder {
    NSLog(@"完成拼单");
}

// 在未得到匹配结果的时候取消订单
- (void) cancelBtnClick {
    NSLog(@"HAHA");
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
        case MATCH_ANSWER_MSG:
            //收到匹配成功地结果
            [self setWaitingForConfirmView];
            break;
        case PARTNER_CONFIRM:
            //收到对方的结果
            [self setMatchSuccessView];
            break;
        case PARTNER_CANCELLED:
            //收到对方拒绝的结果
            [self setPartnerCancelledView];
            break;
        default:
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

@end

