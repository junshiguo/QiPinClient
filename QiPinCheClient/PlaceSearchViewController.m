//
//  PlaceSearchViewControllerTableViewController.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/3.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "PlaceSearchViewController.h"

@interface PlaceSearchViewController ()

@end

@implementation PlaceSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lastScreen:) name:@"SelectLocationNotification" object:nil];
    self.searchBar.delegate = self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.placeTable.delegate = self;
    self.placeTable.dataSource = self;
}

- (void) viewWillDisappear:(BOOL)animated {
    /*self.tableView.delegate = nil;
    self.tableView.dataSource = nil;*/
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)lastScreen:(NSNotification*)notification {

    NSDictionary *dic = [notification object];
        NSLog(@"%@", dic);
    lastScreen = [dic objectForKey:@"lastScreen"];
    initialPlace = [dic objectForKey:@"initialPlace"];
    
    if (![[dic objectForKey:@"initialPlace"] isEqualToString:@""]) {
        self.searchBar.text = initialPlace;
    }
    NSLog(@"k111");
    
    [self filterContentForSearchText:initialPlace];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.resultArray count];
}

- (void) filterContentForSearchText:(NSString *)searchText {
    
    NSString *placeName = searchText;
    placeName = [placeName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *region = @"全国";
    region = [region stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *urlPath = [NSString stringWithFormat:@"/place/v2/suggestion?query=%@&region=%@&ak=%@&mcode=ios.QiPinCheClient&output=json", placeName, region, ApplicationDelegate.baiduAK];
    NSLog(@"%@", urlPath);
    MKNetworkOperation *op = [ApplicationDelegate.baiduHttpEngine operationWithPath:urlPath];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {

        
        NSDictionary *data = [operation responseJSON];
        
        NSArray *results = [data objectForKey:@"result"];
        NSMutableArray *_array = [[NSMutableArray alloc] initWithCapacity:[results count]];
        for (int i = 0; i < [results count]; i++) {
            NSMutableDictionary *dic = results[i];
            NSMutableDictionary *ans = [[NSMutableDictionary alloc] init];
            [ans setObject:[dic objectForKey:@"name"] forKey:@"name"];
            NSString *detail = [[NSString alloc] initWithFormat:@"%@ %@", [dic objectForKey:@"city"], [dic objectForKey:@"district"]];
            [ans setObject:detail forKey:@"detail"];
            NSDictionary *location = [dic objectForKey:@"location"];
            if (location != nil) {
                [ans setObject:[location objectForKey:@"lat"] forKey:@"lat"];
                [ans setObject:[location objectForKey:@"lng"] forKey:@"lng"];
                [_array addObject:ans];
            }
        }
        self.resultArray = _array;
        
        [self performSelectorOnMainThread:@selector(updateWithResults:) withObject:_array waitUntilDone:NO];
          //  [self reloadTable];
        
        
    } errorHandler:^(MKNetworkOperation *errOp, NSError *err) {
        NSLog(@"%@", [err localizedDescription]);
    }];
    [ApplicationDelegate.baiduHttpEngine enqueueOperation:op];
    
    
}

- (void)updateWithResults:(NSMutableArray*)theResults
{
    self.resultArray = theResults;
    NSLog(@"%li", [self.resultArray count]);
    [self.placeTable reloadData];
};



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterContentForSearchText:searchText];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchPlaceCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SearchPlaceCell"];
        
    }

    NSDictionary *dic = [self.resultArray objectAtIndex:[indexPath row]];
    cell.textLabel.text = [dic objectForKey:@"name"];
    cell.detailTextLabel.text = [dic objectForKey:@"detail"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", [self.resultArray objectAtIndex:[indexPath row]]);
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:lastScreen forKey:@"lastScreen"];
    [dic setValue:[self.resultArray objectAtIndex:[indexPath row]] forKey:@"locInfo"];
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LocNotification" object:dic];
    }];
}


- (IBAction)backClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
        [self.view endEditing:YES];
}


@end
