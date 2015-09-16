//
//  OutOfDateView.h
//  QiPinCheClient
//
//  Created by Shijia on 15/9/16.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OutOfDateView : UIView

+ (OutOfDateView*) instanceView;
@property (weak, nonatomic) IBOutlet UIButton *backToHome;

@end
