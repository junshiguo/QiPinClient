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
    
    // APP从后台进入前台的监听
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    btnIndex = 0;
    currentPage = 1;
    [self addHeadRefreshView];
}

/*- (void) willEnterForeground:(NSNotification*) notification {
    [self prepareData];
}*/

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (![UserInfo hasUserInfo]) {
        [ScreenSwitch switchToScreenIn:@"User" withStoryboardIdentifier:@"LoginViewController" inView:self];
    }

    
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
    
    /*cell.timeText.text = @"20150515";
    cell.srcLocation.text = @"复旦大学（张江校区）";
    cell.desLocation.text = @"复旦大学（邯郸校区）";
    cell.statusText.text = @"正在搜寻中";*/
    NSDictionary *dic;
    if (btnIndex == 0) {
        dic = [onGoingOrders objectAtIndex:[indexPath row]];
    } else {
        dic = [finishedOrders objectAtIndex:[indexPath row]];
    }
    cell.timeText = [dic objectForKey:@"orderTime"];
    cell.srcLocation.text = [dic objectForKey:@"src_location"];
    cell.desLocation.text = [dic objectForKey:@"dest_location"];
    cell.statusText.text = [dic objectForKey:@"status"];
    cell.tag = [indexPath row];

    [cell.showMore addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (btnIndex == 0) {
        return [onGoingOrders count];
    } else {
        return [finishedOrders count];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (btnIndex == 0) {
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        NSString *requestId = [[onGoingOrders objectAtIndex:[indexPath row]] objectForKey:@"id"];
        [dic setObject:requestId forKey:@"orderId"];
        [ScreenSwitch switchToScreenIn:@"Order" withStoryboardIdentifier:@"OrderDetailViewController" inView:self withNotificationName:@"BeforeShowOrderDetail" andObject:dic];
    } else {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        NSDictionary *order = [finishedOrders objectAtIndex:[indexPath row]];
        NSString *orderId = [order objectForKey:@"id"];
        [dic setObject:orderId forKey:@"orderId"];
        if ([[order objectForKey:@"score"] floatValue] < 0.1) {
            // 尚未评分
            [ScreenSwitch switchToScreenIn:@"Order" withStoryboardIdentifier:@"FinishedOrderDetailViewController" inView:self withNotificationName:@"BeforeShowOrderDetail" andObject:dic];
        } else {
            // 已评分
            [ScreenSwitch switchToScreenIn:@"Order" withStoryboardIdentifier:@"AfterRatingOrderDetailViewController" inView:self withNotificationName:@"BeforeShowOrderDetail" andObject:dic];
        }
    }
    
    
    //[ScreenSwitch switchToScreenIn:@"Order" withStoryboardIdentifier:@"FinishedOrderDetailViewController" inView:self];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void) showMore {
    [ScreenSwitch switchToScreenIn:@"Order" withStoryboardIdentifier:@"FinishedOrderDetailViewController" inView:self];
}


#pragma mark - 两种订单切换

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

#pragma mark - 下拉刷新相关
//添加头部刷新
-(void) addHeadRefreshView{
    if (_headView == nil) {
        _headView =  [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
        _headView.delegate = self;
        
    }
    [self.orderTable addSubview:_headView];
    //显示刷新条 并且即将要执行刷新的动作
    [_headView egoRefreshScrollViewDidEndDragging:self.orderTable isFirstTime:YES];
}

//下拉刷新的触发事件
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    isRefresh=YES;
    //在后台刷新数据
    [NSThread detachNewThreadSelector:@selector(loadingNewsData) toTarget:self withObject:nil];
    
}
//判断当前的刷新状态
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return isRefresh;
    
}
//返回当前刷新的时间
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date];
    
}
//刷新数据
-(void) loadingNewsData{
    
    NSLog(@"数据刷新获取");
    currentPage=1;
    tag = 101;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[UserInfo getUid] forKey:@"phoneNumber"];
    //这里写下载数据的接口，并进行连接下载
    MKNetworkOperation *op = [ApplicationDelegate.httpEngine operationWithPath:@"/getAllOrders" params:dic httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation* operation) {
        NSDictionary *response = [operation responseJSON];
        NSInteger statusCode = [[response objectForKey:@"status"] integerValue];
        if (statusCode == 1) {
            NSMutableArray *array;
            NSDictionary *detail = [response objectForKey:@"detail"];
            NSDictionary *onGoingDic = [detail objectForKey:@"onGoingOrders"];
            NSDictionary *finishedDic = [detail objectForKey:@"finishedOrders"];
            NSArray *onGoingIds = [onGoingDic allKeys];
            for (int i = 0; i < [onGoingIds count]; i ++) {
                NSString *orderId = onGoingIds[i];
                NSDictionary *dic = [onGoingDic objectForKey:orderId];
                [array addObject:dic];
            }
            onGoingOrders = array;
            [array removeAllObjects];
            
            NSArray *finishedIds = [finishedDic allKeys];
            for (int i = 0; i < [finishedIds count]; i++) {
                NSString *orderId = finishedIds[i];
                NSDictionary *dic = [finishedDic objectForKey:orderId];
                [array addObject:dic];
            }
            finishedOrders = array;
            [self requestFinished];
            
        } else {
            [self requestFailed];
        }
    } errorHandler:^(MKNetworkOperation *errOp, NSError *err) {
        [self requestFailed];
        
    }];
    [ApplicationDelegate.httpEngine enqueueOperation:op];
    
    //[self requestFailed];//下载成功进行的操作
    //[self requestFinished];//下载结束
    
}

//刷新结束，更改刷新状态，更新主线程
-(void) doneNewsData{
    isRefresh = NO;
    NSLog(@"doneNewsData");
    [_headView egoRefreshScrollViewDataSourceDidFinishedLoading:self.orderTable];
    [self.orderTable reloadData];
    
}

-(void)requestFailed
{
    NSLog(@"获取数据失败");
    [self performSelectorOnMainThread:@selector(doneNewsData) withObject:nil waitUntilDone:YES];
}

-(void)requestFinished
{
    //刷新数据，行数不变
    if (tag == 101) {
        
        //下拉刷新下载数据的解析和保存
        [self.orderTable reloadData];
        self.orderTable.hidden = NO;
        [self performSelectorOnMainThread:@selector(doneNewsData) withObject:nil waitUntilDone: YES];
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_headView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_headView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

@end
