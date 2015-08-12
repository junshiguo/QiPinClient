//
//  ModifyNicknameViewController.h
//  QiPinCheClient
//
//  Created by Shijia on 15/8/9.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"

@interface ModifyNicknameViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nickName;
- (IBAction)back:(id)sender;
- (IBAction)save:(id)sender;

@end
