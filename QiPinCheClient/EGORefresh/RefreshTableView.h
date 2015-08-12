//
//  RefreshTableView.h
//  RefreshTableview
//
//  Created by baxiang on 13-5-18.
//  Copyright (c) 2013年 巴翔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFootView.h"
#import "PagesEntity.h"

@protocol UITableViewRefresh
-(void) reloadRefreshDataSource:(int) pageIndex;
@end
@interface RefreshTableView : UITableView<EGORefreshTableFootDelegate,EGORefreshTableHeaderDelegate>
{
    

EGORefreshTableHeaderView *_refreshHeaderView;//下拉刷新的控件

EGORefreshTableFootView *_refreshFootView;//加载更多控件

//ImageView *ivConfirm;//提示用户操作

//  Reloading var should really be your tableviews datasource
//  Putting it here for demo purposes
BOOL _reloading;

id<UITableViewRefresh> refreshDelegate;
//PageLastRefreshTime lastRefreshTime;//用户标识哪个页面来刷新

CGPoint point;//判断是上拉还是下拉

NSMutableArray *tableArray;//列表的显示数据集

NSMutableDictionary *mutableArray;//多列表数据   这个对象有点怪异  需要在子页面去alloc  所以不用release

int currentPage;

BOOL added;

PagesEntity *pg;

//BaseController *target;
}
@property(retain) id<UITableViewRefresh> refreshDelegate;
@property(nonatomic,retain) NSMutableArray *tableArray;
@property(nonatomic,retain) NSMutableDictionary *mutableArray;
@property(readonly) int currentPage;
@property(nonatomic) BOOL added;
@property(nonatomic,retain) PagesEntity *pg;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

- (void)reloadTableViewDataSource1;
- (void)doneLoadingTableViewData1;

//-(void) setLastRefreshTime:(PageLastRefreshTime)pagetype;

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)showStateBar;

-(void) addRefreshView;
-(void) addMoreView;
-(void) modifyMoreFrame;

//-(void) addConfirmView:(TableViewConfirm)TableViewConfirm;
//-(void) delConfirmView;

-(void) reload:(int)rows;

- (int) getWidth;
- (int) getHeigth;
- (int) getX;
- (int) getY;

//- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;
//- (id)initWithFrame:(CGRect)frame;

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end
