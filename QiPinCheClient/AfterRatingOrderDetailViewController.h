//
//  AfterRatingOrderDetailViewController.h
//  QiPinCheClient
//
//  Created by Shijia on 15/8/11.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"

@interface AfterRatingOrderDetailViewController : UIViewController {
    NSString *partnerPhoneNumber;
}
@property (weak, nonatomic) IBOutlet UILabel *srcLocation;
@property (weak, nonatomic) IBOutlet UILabel *desLocation;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *cash;
@property (weak, nonatomic) IBOutlet UILabel *cashDescription;
@property (weak, nonatomic) IBOutlet UIButton *nickName;
- (IBAction)showPartnerDetail:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *score;
- (IBAction)back:(id)sender;

@end
