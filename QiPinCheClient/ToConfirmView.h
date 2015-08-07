//
//  ToConfirmView.h
//  QiPinCheClient
//
//  Created by Shijia on 15/8/6.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"

@interface ToConfirmView : UIView<BMKMapViewDelegate, BMKRouteSearchDelegate> {
    IBOutlet BMKMapView* _mapView;
    IBOutlet UITextField* _startCityText;
    IBOutlet UITextField* _startAddrText;
    IBOutlet UITextField* _endCityText;
    IBOutlet UITextField* _endAddrText;
    BMKRouteSearch* _routesearch;
    
}

+ (ToConfirmView*) instanceView;

@end
