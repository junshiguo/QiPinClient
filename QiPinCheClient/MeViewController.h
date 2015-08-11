//
//  SecondViewController.h
//  QiPinCheClient
//
//  Created by Shijia on 15/8/1.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"

@interface MeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *gender;
@property (weak, nonatomic) IBOutlet UIButton *age;

- (IBAction)logOff:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *job;
- (IBAction)modifyNickname:(id)sender;
- (IBAction)modifyJob:(id)sender;

@end

