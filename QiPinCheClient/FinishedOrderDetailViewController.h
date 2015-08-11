//
//  FinishedOrderDetailViewController.h
//  QiPinCheClient
//
//  Created by Shijia on 15/8/10.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStarRatingView.h"
#import "CommonHeader.h"

@interface FinishedOrderDetailViewController : UIViewController<StarRatingViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *srcLocation;
@property (weak, nonatomic) IBOutlet UILabel *desLocation;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UIButton *nickName;
@property (weak, nonatomic) IBOutlet UILabel *score;
- (IBAction)back:(id)sender;
- (IBAction)showPartenerDetail:(id)sender;

@end