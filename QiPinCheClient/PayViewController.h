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
}
- (IBAction)back:(id)sender;
- (IBAction)payOnClick:(id)sender;

@end
