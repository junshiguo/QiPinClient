//
//  WaitingForConfirm.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/7.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "WaitingForConfirmView.h"

@implementation WaitingForConfirmView

+ (WaitingForConfirmView*) instanceView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"WaitingForConfirmView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (IBAction)confirmToMatch:(id)sender {
}

- (IBAction)cancelToMatch:(id)sender {
}
@end
