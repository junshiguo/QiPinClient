//
//  PersonalInfoViewController.h
//  QiPinCheClient
//
//  Created by Shijia on 15/8/10.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"

@interface PersonalInfoViewController : UIViewController {
    NSString *phoneNumber;
    BOOL showPhoneNumber;
    CGRect oldframe;
}
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *age;
@property (weak, nonatomic) IBOutlet UILabel *gender;
@property (weak, nonatomic) IBOutlet UILabel *job;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)back:(id)sender;

@end
