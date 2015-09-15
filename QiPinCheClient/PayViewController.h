//
//  PayViewController.h
//  QiPinCheClient
//
//  Created by Shijia on 15/8/17.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayViewController : UIViewController {
    NSDictionary *requestInfo;
    NSDictionary *chargeInfo;
}
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *money;
- (IBAction)wxPayOnClick:(id)sender;
- (IBAction)aliPayOnClick:(id)sender;

@end
