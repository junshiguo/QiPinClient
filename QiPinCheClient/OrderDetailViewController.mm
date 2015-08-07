//

//  OrderDetailViewController.m

//  QiPinCheClient

//

//  Created by Shijia on 15/8/6.

//  Copyright (c) 2015年 QiPinChe. All rights reserved.

//



#import "OrderDetailViewController.h"

#import "WaitingForMatchView.h"



@implementation OrderDetailViewController



@synthesize srcLocationName = _srcLocationName;

@synthesize desLocationName = _desLocationName;

@synthesize startTime = _startTime;



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beforeShowOrderDetail:) name:@"BeforeShowOrderDetail" object:nil];
    
}



- (void) beforeShowOrderDetail:(NSNotification*)notification {
    
    NSDictionary *data = [notification object];
    
    orderId = [data objectForKey:@"orderId"];
    
    orderType = [[data objectForKey:@"orderType"] integerValue];
    
    srcLocationName = [data objectForKey:@"srcLocation"];
    
    desLocationName = [data objectForKey:@"desLocation"];
    
    startTime = [data objectForKey:@"startTime"];
    
    
    
    
    
    self.srcLocationName.text = srcLocationName;
    
    self.desLocationName.text = desLocationName;
    
    self.startTime.text = startTime;
    
}



- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    
    
     WaitingForMatchView *statusView = [WaitingForMatchView instanceView];
     
     statusView.frame = CGRectMake(0, 250, 375, 400);
     
     
     
     [self.view addSubview:statusView];
     
     [statusView.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    

    
    
    
    
    
}



- (void) cancelBtnClick {
    
    NSLog(@"HAHA");
    
}



- (IBAction)backToHome:(id)sender {
    
    [ScreenSwitch switchToScreenIn:@"Main" withStoryboardIdentifier:@"TabBarController" inView:self];
    
}

@end

