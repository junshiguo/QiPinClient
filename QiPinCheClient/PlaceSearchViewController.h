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

@interface PlaceSearchViewController : UIViewController<UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    NSString *lastScreen;
    NSString *initialPlace;
    BOOL keyboardVisible;
    float keyboardHeight;
}


@property (strong, nonatomic) NSMutableArray *resultArray;


@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITableView *placeTable;
@property (weak, nonatomic) IBOutlet UIScrollView *srollView;

- (IBAction)backClick:(id)sender;
- (void) filterContentForSearchText:(NSString *)searchText;

@end
