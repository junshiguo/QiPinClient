//
//  NewOrderViewController.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/5.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "NewOrderViewController.h"

@interface NewOrderViewController ()

@end

@implementation NewOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
