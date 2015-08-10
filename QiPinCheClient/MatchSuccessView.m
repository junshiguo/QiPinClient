//
//  MatchSuccessView.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/10.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "MatchSuccessView.h"

@implementation MatchSuccessView

- (IBAction)makeCall:(id)sender {
}

+ (MatchSuccessView*) instanceView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"MatchSuccessView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
    
}

@end
