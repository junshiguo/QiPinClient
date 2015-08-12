//
//  UIAlertShow.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/12.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "UIAlertShow.h"

@implementation UIAlertShow

+ (void) showAlertViewWithMsg:(NSString*)msg {
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alter show];
}

@end
