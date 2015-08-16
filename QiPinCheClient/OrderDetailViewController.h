//
//  OrderDetailViewController.h
//  QiPinCheClient
//
//  Created by Shijia on 15/8/6.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"

#define WAITING_WAITING 1 //处理成功：寻找到一起拼车的对象，而且对方没有确认
#define WAITING_CANCELLED 2 //处理成功：对方已经取消
#define WAITING_CONFIRMED 3 //处理成功：对方已经确认
#define CONFIRMED_WAITING 4 //处理成功：自己确认了，但是对方还没有确认
#define CONFIRMED_REFUSED 5 //处理成功：自己确认，但是对方已经拒绝
#define CONFIRMED_CONFIRMED 6 //处理成功：自己确认，而且对方已经确认
#define WAITING_FOR_MATCH 7 //正在处理：算法正在寻找匹配
#define ERROR_STATUS 8 //无此请求，应该是服务器出错啦！

@interface OrderDetailViewController : UIViewController<EMChatManagerDelegate, UIAlertViewDelegate> {
    NSString *requestId, *partnerPhoneNumber;
    NSInteger statusViewY, status;
    NSArray *route;
    NSInteger remainChance;
}
- (IBAction)backToHome:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *srcLocationName;
@property (weak, nonatomic) IBOutlet UILabel *desLocationName;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;


@end
