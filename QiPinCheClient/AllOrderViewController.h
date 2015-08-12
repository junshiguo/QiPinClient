//
//  AllOrderViewController.h
//  QiPinCheClient
//
//  Created by Shijia on 15/8/9.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"
#import "EGORefreshTableHeaderView.h"

@interface AllOrderViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate> {
    NSInteger btnIndex;
    
    EGORefreshTableHeaderView *_headView;
    CGPoint point;//判断是上拉还是下拉
    BOOL isRefresh;//下拉刷新
    int currentPage;//当前显示的页码
    int tag;//判断是上拉还是下拉加载
}
@property (weak, nonatomic) IBOutlet UIButton *doingBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UITableView *orderTable;
@property (weak, nonatomic) IBOutlet UINavigationItem *navTitle;

- (IBAction)queryDoing:(id)sender;
- (IBAction)queryFinish:(id)sender;

@end
