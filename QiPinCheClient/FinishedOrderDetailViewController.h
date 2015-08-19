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

@interface FinishedOrderDetailViewController : UIViewController<StarRatingViewDelegate> {
    NSString* partnerPhoneNumber, *phoneNumber;
    NSString *orderId, *requestId;
    NSInteger rating;
}
@property (weak, nonatomic) IBOutlet UILabel *srcLocation;
@property (weak, nonatomic) IBOutlet UILabel *desLocation;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UIButton *nickName;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *cash;
@property (weak, nonatomic) IBOutlet UILabel *cashDescription;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)back:(id)sender;
- (IBAction)showPartenerDetail:(id)sender;
- (IBAction)startToRate:(id)sender;


@end
