//
//  AllOrderViewController.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/9.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "AllOrderViewController.h"
#import "NewOrderCell.h"

@interface AllOrderViewController ()

@end

@implementation AllOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.orderTable.dataSource = self;
    self.orderTable.delegate = self;
    btnIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewOrderCell"];
    
    cell.timeText.text = @"20150515";
    cell.srcLocation.text = @"复旦大学（张江校区）";
    cell.desLocation.text = @"复旦大学（邯郸校区）";
    cell.statusText.text = @"正在搜寻中";
    
    [cell.showMore addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [ScreenSwitch switchToScreenIn:@"Order" withStoryboardIdentifier:@"FinishedOrderDetailViewController" inView:self];
}

- (void) showMore {
    [ScreenSwitch switchToScreenIn:@"Order" withStoryboardIdentifier:@"FinishedOrderDetailViewController" inView:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)queryDoing:(id)sender {
    self.doingBtn.enabled = NO;
    self.finishBtn.enabled = YES;
    self.navTitle.title = @"进行中订单";
    btnIndex = 0;
}

- (IBAction)queryFinish:(id)sender {
    self.doingBtn.enabled = YES;
    self.finishBtn.enabled = NO;
    self.navTitle.title = @"已完成订单";
    btnIndex = 1;
}
@end
