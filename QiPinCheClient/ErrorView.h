//
//  ErrorView.h
//  QiPinCheClient
//
//  Created by Shijia on 15/8/13.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ErrorView : UIView

+ (ErrorView*) instanceView;
@property (weak, nonatomic) IBOutlet UIButton *cancelOrder;

@end
