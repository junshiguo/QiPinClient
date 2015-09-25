//
//  TipPayViewController.h
//  QiPinCheClient
//
//  Created by Shijia on 15/9/23.
//  Copyright © 2015年 QiPinChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"
#import "Pingpp.h"

#define wxUrlScheme      @"wx933665aaccea2b32" //微信支付


@interface TipPayViewController : UIViewController {
    NSString *requestId;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipSelector;
- (IBAction)confirmPayTip:(id)sender;
- (IBAction)cancelTipOnClick:(id)sender;


@end
