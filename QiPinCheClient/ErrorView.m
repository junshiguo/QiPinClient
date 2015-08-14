//
//  ErrorView.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/13.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "ErrorView.h"

@implementation ErrorView

+ (ErrorView*) instanceView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"ErrorView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

@end
