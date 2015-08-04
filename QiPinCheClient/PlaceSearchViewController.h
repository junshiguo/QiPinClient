//
//  PlaceSearchViewControllerTableViewController.h
//  QiPinCheClient
//
//  Created by Shijia on 15/8/3.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaiduAPIEngine.h"
#import "AppDelegate.h"
#import "ScreenSwitch.h"

@interface PlaceSearchViewController : UITableViewController<UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate> {
    NSString *lastScreen;
    NSString *initialPlace;
}


@property (strong, nonatomic) NSMutableArray *resultArray;

- (void) filterContentForSearchText:(NSString *)searchText;
@property (strong, nonatomic) IBOutlet UITableView *placeTable;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
