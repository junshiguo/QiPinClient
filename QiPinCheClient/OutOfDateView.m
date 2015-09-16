//
//  OutOfDateView.m
//  QiPinCheClient
//
//  Created by Shijia on 15/9/16.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "OutOfDateView.h"

@implementation OutOfDateView

+ (OutOfDateView*) instanceView; {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"OutOfDateView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}


@end
