//
//  PayViewController.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/17.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "PayViewController.h"
#import "Pingpp.h"

@interface PayViewController ()

@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRequestInfo:) name:@"RequestInfo" object:nil];
}

- (void) getRequestInfo:(NSNotification*) notification {
    requestInfo = [notification object];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}


- (IBAction)payOnClick:(id)sender {
    
}
@end
