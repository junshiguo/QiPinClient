//
//  ModifyJobViewController.h
//  QiPinCheClient
//
//  Created by Shijia on 15/8/9.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"

@interface ModifyJobViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *job;

- (IBAction)back:(id)sender;
- (IBAction)save:(id)sender;
@end
