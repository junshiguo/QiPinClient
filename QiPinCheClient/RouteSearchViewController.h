//
//  RouteSearchDemoController.h
//  BaiduMapApiDemo
//
//  Copyright 2011 Baidu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>
#import "CommonHeader.h"

@interface RouteSearchViewController : UIViewController<BMKMapViewDelegate, BMKRouteSearchDelegate> {
	IBOutlet BMKMapView* _mapView;
    BMKRouteSearch *_routesearch, *_routesearch1, *_routesearch2;
    NSInteger planPointCounts;
    NSMutableArray* planRoute;
    int index;
    NSArray *route;
}

- (IBAction)back:(id)sender;

@property (weak, nonatomic) IBOutlet UINavigationBar *naviBar;

@end