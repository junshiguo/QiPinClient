//
//  WaitingForMatchView.h
//  QiPinCheClient
//
//  Created by Shijia on 15/8/6.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitingForMatchView : UIView


+ (WaitingForMatchView*) instanceView;
- (IBAction)cancelTheOrder:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end
