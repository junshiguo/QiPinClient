//
//  PayViewController.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/17.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "PayViewController.h"
#import "Pingpp.h"
#import "CommonHeader.h"

#define wxUrlScheme      @"wx933665aaccea2b32" //微信支付


@interface PayViewController ()

@end

@implementation PayViewController

- (void)viewDidLoad {
    NSLog(@"PayViewController---viewDidLoad");
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRequestInfo:) name:@"RequestInfo" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishPayment:) name:@"FinishPayment" object:nil];

}

- (void) getRequestInfo:(NSNotification*) notification {
    requestInfo = [notification object];
    float depositFen = [[requestInfo objectForKey:@"deposit"] floatValue];
    self.money.text = [NSString stringWithFormat:@"%.2f", depositFen/100];
}

- (void) finishPayment:(NSNotification*) notification {
    NSLog(@"finishPayment");
    NSString *msg = [notification object];
    if ([msg isEqualToString:@"success"]) {
        
        [self sendFinishPayment];
        [ScreenSwitch switchToScreenIn:@"Order" withStoryboardIdentifier:@"OrderDetailViewController" inView:self withNotificationName:@"BeforeShowOrderDetail" andObject:requestInfo];
    } else {
        [UIAlertShow showAlertViewWithMsg:@"支付失败！"];
    }
}

- (void) sendFinishPayment {
    NSLog(@"now sendFinishPayment");
    NSLog(@"paymentRequestId=%@", [requestInfo objectForKey:@"requestId"]);
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[requestInfo objectForKey:@"requestId"] forKey:@"requestId"];
    [dic setObject:[chargeInfo objectForKey:@"id"] forKey:@"chargeId"];
    [dic setObject:[UserInfo getUid] forKey:@"userId"];
    [dic setObject:[requestInfo objectForKey:@"deposit"] forKey:@"deposit"];
    NSLog(@"payInfo=%@", dic);
    MKNetworkOperation *op = [ApplicationDelegate.httpEngine operationWithPath:@"/confirmPayment" params:dic httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        
    } errorHandler:^(MKNetworkOperation *errOp, NSError *errMsg) {
        NSLog(@"%@", errMsg);
        [UIAlertShow showAlertViewWithMsg:@"网络失败！10301"];
    }];
    [ApplicationDelegate.httpEngine enqueueOperation:op];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)wxPayOnClick:(id)sender {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[requestInfo objectForKey:@"requestId"] forKey:@"requestId"];
    [dic setObject:[requestInfo objectForKey:@"deposit"] forKey:@"amount"];
    [dic setObject:@"wx" forKey:@"payMethod"];
    MKNetworkOperation *op = [ApplicationDelegate.httpEngine operationWithPath:@"/getCharge" params:dic httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSLog(@"%@", [operation responseJSON]);
        NSDictionary *responseData = [operation responseJSON];
        NSInteger statusCode = [[responseData objectForKey:@"status"] integerValue];
        NSDictionary *charge = [responseData objectForKey:@"detail"];
        chargeInfo = charge;
        NSLog(@"charge dic = %@", chargeInfo);
        if (statusCode == 1) {
            PayViewController * __weak weakSelf = self;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [Pingpp createPayment:charge viewController:weakSelf appURLScheme:wxUrlScheme withCompletion:^(NSString *result, PingppError *error) {
                    NSLog(@"completion block: %@", result);
                    if (error == nil) {
                        NSLog(@"PingppError is nil");
                        [self sendFinishPayment];
                        [ScreenSwitch switchToScreenIn:@"Order" withStoryboardIdentifier:@"OrderDetailViewController" inView:self withNotificationName:@"BeforeShowOrderDetail" andObject:requestInfo];
                    } else {
                        NSLog(@"PingppError: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
                        [UIAlertShow showAlertViewWithMsg:@"支付失败！"];
                    }
                    
                }];
            });
            
        } else {
            [UIAlertShow showAlertViewWithMsg:@"网络失败！10200"];
        }
        
    } errorHandler:^(MKNetworkOperation *errOp, NSError *err) {
        [UIAlertShow showAlertViewWithMsg:@"网络失败！10201"];
    }];
    [ApplicationDelegate.httpEngine enqueueOperation:op];
}

- (IBAction)aliPayOnClick:(id)sender {
}

- (void)dealloc {
    
    //[super dealloc];  非ARC中需要调用此句
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end
