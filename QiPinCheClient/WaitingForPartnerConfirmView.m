//
//  WaitingForPartnerConfirm.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/10.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "WaitingForPartnerConfirmView.h"

@interface WaitingForPartnerConfirmView ()

@end

@implementation WaitingForPartnerConfirmView

+ (WaitingForPartnerConfirmView*) instanceView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"WaitingForPartnerConfirmView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
    
}


@end
