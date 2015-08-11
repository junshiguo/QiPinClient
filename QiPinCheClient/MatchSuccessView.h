//
//  MatchSuccessView.h
//  QiPinCheClient
//
//  Created by Shijia on 15/8/10.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchSuccessView : UIView
@property (weak, nonatomic) IBOutlet UIButton *makecallBtn;

+ (MatchSuccessView*) instanceView;
@property (weak, nonatomic) IBOutlet UIButton *finishOrder;
@property (weak, nonatomic) IBOutlet UIButton *nickName;

@end
