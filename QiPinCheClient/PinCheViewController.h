//
//  PinCheViewController.h
//  QiPinCheClient
//
//  Created by Shijia on 15/8/3.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>
#import "Commbox.h"

@interface PinCheViewController : UIViewController<BMKMapViewDelegate, BMKLocationServiceDelegate, UITextFieldDelegate, BMKPoiSearchDelegate> {
    IBOutlet BMKMapView* _mapView;
    BMKLocationService* _locService;
    BMKPointAnnotation *_annotation;
    NSDictionary *srcLocationDic, *desLocationDic;
}

@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (weak, nonatomic) IBOutlet UITextField *srcLocation;
@property (weak, nonatomic) IBOutlet UITextField *desLocation;
@property (weak, nonatomic) IBOutlet UITextField *startTime;
@property (weak, nonatomic) IBOutlet UISegmentedControl *expAge;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *expGender;
@property (weak, nonatomic) IBOutlet UIButton *pinCheButton;
@property (strong, nonatomic) IBOutlet Commbox *ageLower, *ageHigher;

- (IBAction)toolBarBackClick:(id)sender;
- (IBAction)toolBarSaveClick:(id)sender;
- (IBAction)beginSelectTime:(id)sender;
- (IBAction)startPinChe:(id)sender;
- (IBAction)srcLocOnClick:(id)sender;
- (IBAction)desLocOnClick:(id)sender;
- (IBAction)backOnClick:(id)sender;


@end
