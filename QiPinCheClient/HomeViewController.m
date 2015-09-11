//
//  FirstViewController.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/1.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "HomeViewController.h"
#import "Pingpp.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)beginPinChe:(id)sender {
    //[ScreenSwitch switchToScreenIn:@"Main" withStoryboardIdentifier:@"PinCheViewController" inView:self];
    NSLog(@"beginPinChe");
   /* if ([UserInfo getUid] != nil) {
        [ScreenSwitch switchToScreenIn:@"Main" withStoryboardIdentifier:@"PinCheViewController" inView:self];
    } else {
        [ScreenSwitch switchToScreenIn:@"User" withStoryboardIdentifier:@"LoginViewController" inView:self];
    }*/
    [ScreenSwitch switchToScreenIn:@"Main" withStoryboardIdentifier:@"PinCheViewController" inView:self];

    

}
@end
