//
//  PartnerCancelledView.h
//  QiPinCheClient
//
//  Created by Shijia on 15/8/10.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartnerCancelledView : UIView

+ (PartnerCancelledView*) instanceView;
@property (weak, nonatomic) IBOutlet UIButton *rewaitingForMatch;
@property (weak, nonatomic) IBOutlet UIButton *cancelWaitingForMatch;

@end
