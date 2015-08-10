//
//  PartnerCancelledView.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/10.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "PartnerCancelledView.h"

@implementation PartnerCancelledView

+ (PartnerCancelledView*) instanceView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"PartnerCancelledView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
    
}

@end
