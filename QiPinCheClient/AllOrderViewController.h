//
//  AllOrderViewController.h
//  QiPinCheClient
//
//  Created by Shijia on 15/8/9.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"

@interface AllOrderViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *orderTable;

@end
