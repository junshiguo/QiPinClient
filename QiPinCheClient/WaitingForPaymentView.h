//
//  WaitingForPayment.h
//  QiPinCheClient
//
//  Created by Shijia on 15/9/13.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitingForPaymentView : UIView

+ (WaitingForPaymentView*) instanceView;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelRequest;

@end
