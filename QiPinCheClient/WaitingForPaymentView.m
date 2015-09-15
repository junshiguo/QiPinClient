//
//  WaitingForPayment.m
//  QiPinCheClient
//
//  Created by Shijia on 15/9/13.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "WaitingForPaymentView.h"

@implementation WaitingForPaymentView

+ (WaitingForPaymentView*) instanceView; {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"WaitingForPaymentView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
    
}
@end
