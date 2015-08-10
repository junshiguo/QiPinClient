//
//  WaitingForPartnerConfirm.h
//  QiPinCheClient
//
//  Created by Shijia on 15/8/10.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitingForPartnerConfirmView : UIView

+ (WaitingForPartnerConfirmView*) instanceView;
@property (weak, nonatomic) IBOutlet UIButton *cancelWaiting;

@end
