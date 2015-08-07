//
//  OrderDetailViewController.h
//  QiPinCheClient
//
//  Created by Shijia on 15/8/6.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"


@interface OrderDetailViewController : UIViewController<BMKRouteSearchDelegate, BMKMapViewDelegate> {
    NSString *orderId, *srcLocationName, *desLocationName, *orderTime, *startTime, *matchUid, *matchNickName;
    NSInteger orderType;
    IBOutlet BMKMapView* _mapView;
    IBOutlet UITextField* _startCityText;
    IBOutlet UITextField* _startAddrText;
    IBOutlet UITextField* _endCityText;
    IBOutlet UITextField* _endAddrText;
    BMKRouteSearch* _routesearch;
}
- (IBAction)backToHome:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *srcLocationName;
@property (weak, nonatomic) IBOutlet UILabel *desLocationName;
@property (weak, nonatomic) IBOutlet UILabel *startTime;


@end
