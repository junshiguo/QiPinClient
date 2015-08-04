//
//  FirstViewController.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/1.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "HomeViewController.h"
#import "Commbox.h"
#import "UserInfo.h"
#import "ScreenSwitch.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    
}

- (void)viewWillAppear:(BOOL)animated {
   /* KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc]initWithIdentifier:@"Account" accessGroup:nil];
    NSLog(@"username=%@", [wrapper objectForKey:@"phoneNumber"]);*/


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)beginPinChe:(id)sender {
    [ScreenSwitch switchToScreenIn:@"Main" withStoryboardIdentifier:@"PinCheViewController" inView:self];
    /*if (![UserInfo hasUserInfo]) {
        [ScreenSwitch switchToScreenIn:@"Main" withStoryboardIdentifier:@"PinCheViewController" inView:self];
    } else {
        [ScreenSwitch switchToScreenIn:@"User" withStoryboardIdentifier:@"LoginViewController" inView:self];
        NSLog(@"11111");
    }*/
}
@end
