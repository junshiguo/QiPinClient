//
//  AllOrderViewController.h
//  QiPinCheClient
//
//  Created by Shijia on 15/8/9.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"

@interface AllOrderViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    NSInteger btnIndex;
}
@property (weak, nonatomic) IBOutlet UIButton *doingBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UITableView *orderTable;
@property (weak, nonatomic) IBOutlet UINavigationItem *navTitle;

- (IBAction)queryDoing:(id)sender;
- (IBAction)queryFinish:(id)sender;

@end
