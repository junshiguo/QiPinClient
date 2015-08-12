//
//  OrderDetailViewController.h
//  QiPinCheClient
//
//  Created by Shijia on 15/8/6.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"

#define MATCH_ANSWER_MSG 0
#define PARTNER_CONFIRM 1
#define PARTNER_CANCELLED 2

@interface OrderDetailViewController : UIViewController<EMChatManagerDelegate> {
    NSString *orderId, *srcLocationName, *desLocationName, *orderTime, *startTime, *matchUid, *matchNickName;
    NSInteger orderType;
    NSInteger statusViewY;
}
- (IBAction)backToHome:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *srcLocationName;
@property (weak, nonatomic) IBOutlet UILabel *desLocationName;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;


@end
