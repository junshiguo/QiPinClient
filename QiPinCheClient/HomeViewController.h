//
//  FirstViewController.h
//  QiPinCheClient
//
//  Created by Shijia on 15/8/1.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"

@interface HomeViewController : UIViewController <BMKMapViewDelegate, BMKLocationServiceDelegate, UITextFieldDelegate, BMKPoiSearchDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    IBOutlet BMKMapView* _mapView;
    BMKLocationService* _locService;
    BMKPointAnnotation *_annotation;
    NSDictionary *srcLocationDic, *desLocationDic;
    NSDictionary *requestInfo;
    NSInteger selectIndex;
    NSArray *ageArray;
    BOOL hasShowMapView;
}

@property (weak, nonatomic) IBOutlet UITextField *expAge;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (weak, nonatomic) IBOutlet UITextField *srcLocation;
@property (weak, nonatomic) IBOutlet UITextField *desLocation;
@property (weak, nonatomic) IBOutlet UITextField *startTime;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *expGender;
@property (weak, nonatomic) IBOutlet UIButton *pinCheButton;
@property (strong, nonatomic) IBOutlet Commbox *ageLower, *ageHigher;
@property (strong, nonatomic) Commbox* ageSelector;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;


- (IBAction)toolBarBackClick:(id)sender;
- (IBAction)toolBarSaveClick:(id)sender;
- (IBAction)beginSelectTime:(id)sender;
- (IBAction)startPinChe:(id)sender;
- (IBAction)srcLocOnClick:(id)sender;
- (IBAction)desLocOnClick:(id)sender;
- (IBAction)expAgeClick:(id)sender;




@end

