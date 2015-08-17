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
    int index;
    NSArray *route;
    BMKPlanNode *start, *end, *start1, *end1, *start2, *end2;
}

- (IBAction)back:(id)sender;

@property (weak, nonatomic) IBOutlet UINavigationBar *naviBar;

@end