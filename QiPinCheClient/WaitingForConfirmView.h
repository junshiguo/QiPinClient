//
//  WaitingForConfirm.h
//  QiPinCheClient
//
//  Created by Shijia on 15/8/7.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitingForConfirmView : UIView

+ (WaitingForConfirmView*) instanceView;
@property (weak, nonatomic) IBOutlet UIButton *nickname;
@property (weak, nonatomic) IBOutlet UILabel *srcLocationName;
@property (weak, nonatomic) IBOutlet UILabel *desLocationName;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
- (IBAction)confirmToMatch:(id)sender;
- (IBAction)cancelToMatch:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *confirmToMatch;
@property (weak, nonatomic) IBOutlet UIButton *cancelToMatch;
@property (weak, nonatomic) IBOutlet UILabel *savePercent;
@property (weak, nonatomic) IBOutlet UIButton *showRouteBtn;

@end
