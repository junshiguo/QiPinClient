//
//  WaitingForMatchView.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/6.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "WaitingForMatchView.h"

@implementation WaitingForMatchView

+ (WaitingForMatchView*) instanceView; {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"WaitingForMatchView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
    
}

- (IBAction)cancelTheOrder:(id)sender {
}


@end
