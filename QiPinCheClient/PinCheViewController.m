//
//  PinCheViewController.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/3.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "PinCheViewController.h"
#import "BaiduAPIEngine.h"
#import "AppDelegate.h"
#import "ScreenSwitch.h"

@interface PinCheViewController ()

@end

@implementation PinCheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    float x, y, width, height;;
    x = 0;
    y = self.expGender.frame.origin.y + self.expGender.frame.size.height + 20;
    width = [UIScreen mainScreen].applicationFrame.size.width;
    height = self.pinCheButton.frame.origin.y - y -5;
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [_mapView setShowsUserLocation:NO];

    _locService = [[BMKLocationService alloc]init];
    [BMKLocationService setLocationDistanceFilter:100.f];
    _annotation = [[BMKPointAnnotation alloc] init];
    
    self.timePicker.minimumDate = [NSDate date];
    
    [self initAgeSelector];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLoc:) name:@"LocNotification" object:nil];

}

- (void)receiveLoc:(NSNotification*)notification {
    NSDictionary *dic = [notification object];
    if ([[dic objectForKey:@"lastScreen"] isEqualToString:@"srcLoc"]) {
        srcLocationDic = [dic objectForKey:@"locInfo"];
        self.srcLocation.text = [srcLocationDic objectForKey:@"name"];
    } else {
        desLocationDic = [dic objectForKey:@"locInfo"];
        self.desLocation.text = [desLocationDic objectForKey:@"name"];
    }
    
    
}

- (void) initAgeSelector {
    /*float x1 = self.startTime.frame.origin.x;
    float y = self.startTime.frame.origin.y + self.desLocation.frame.origin.y - self.srcLocation.frame.origin.y;
    float width = (self.startTime.frame.size.width / 2);
    float height = self.startTime.frame.size.height;
    float x2 = x1 + width + 17;*/
    
    /*CGRect r1 = self.ageText1.frame;
    CGRect r2 = self.ageText2.frame;
    
    NSLog(@"%f", self.startTime.frame.size.width);
    NSLog(@"%f", r2.origin.x);
    self.ageLower = [[Commbox alloc] initWithFrame:r1];
    self.ageHigher = [[Commbox alloc] initWithFrame:r2];
    NSLog(@"%f", self.ageHigher.frame.origin.x);
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:100];
    for (int i = 0; i < 100; i++) {
        arr[i] = [NSString stringWithFormat:@"%i", i];
    }
    
    self.ageLower.tableArray = arr;
    self.ageHigher.tableArray = arr;*/
    //[self.view addSubview:self.ageLower];
    //[self.view addSubview:self.ageHigher];
    self.ageText1.keyboardType = self.ageText2.keyboardType = UIKeyboardTypeNumberPad;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self.ageLower endShowList];
    [self.ageHigher endShowList];
}

- (void)viewWillAppear:(BOOL)animated {
    _mapView.showsUserLocation = NO;
    [_mapView viewWillAppear];
    [_locService startUserLocationService];
    _mapView.delegate = self;
    _locService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _locService.delegate = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    [_mapView setZoomLevel:15];
    CLLocationCoordinate2D coor;
    coor.latitude = userLocation.location.coordinate.latitude;
    coor.longitude = userLocation.location.coordinate.longitude;
    _annotation.coordinate = coor;
    [self getPlaceTitleByLat:coor.latitude andLon:coor.longitude];
    [self.view addSubview:_mapView];
}



// 时间选择器相关
- (IBAction)beginSelectTime:(id)sender {
    self.timePicker.hidden = false;
    self.toolBar.hidden = false;
    self.startTime.enabled = false;
    [self.view bringSubviewToFront:self.timePicker];
    [self.view bringSubviewToFront:self.toolBar];
    self.pinCheButton.hidden = true;
    _mapView.hidden = true;
}

- (IBAction)startPinChe:(id)sender {
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.labelText = @"发布成功，您可以在未完成订单中查看";
    HUD.mode = MBProgressHUDModeText;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [HUD removeFromSuperview];
        [ScreenSwitch switchToScreenIn:@"Order" withStoryboardIdentifier:@"TabBarController" inView:self];
    }];
    
}

- (IBAction)srcLocOnClick:(id)sender {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"srcLoc" forKey:@"lastScreen"];
    [dic setObject:self.srcLocation.text forKey:@"initialPlace"];
    
    [ScreenSwitch switchToScreenIn:@"Main" withStoryboardIdentifier:@"PlaceSearchViewController" inView:self withNotificationName:@"SelectLocationNotification" andObject:dic];
}

- (IBAction)desLocOnClick:(id)sender {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"desLoc" forKey:@"lastScreen"];
    [dic setObject:@"" forKey:@"initialPlace"];
    
    [ScreenSwitch switchToScreenIn:@"Main" withStoryboardIdentifier:@"PlaceSearchViewController" inView:self withNotificationName:@"SelectLocationNotification" andObject:dic];
}

- (IBAction)backOnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}


// 时间选择器toolbar
- (IBAction)toolBarBackClick:(id)sender {
    self.timePicker.hidden = true;
    self.toolBar.hidden = true;
    self.startTime.enabled = true;
    self.pinCheButton.hidden = false;
    _mapView.hidden = false;
}
- (IBAction)toolBarSaveClick:(id)sender {
    self.toolBar.hidden = true;
    self.timePicker.hidden = true;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.startTime.text = [dateFormatter stringFromDate:self.timePicker.date];
    self.startTime.enabled = true;
    self.pinCheButton.hidden = false;
    _mapView.hidden = false;
}



// 关闭键盘
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


// 根据经纬度获得地点名称
- (void) getPlaceTitleByLat:(float)lat andLon:(float)lon {
    
    NSString *urlPath = [NSString stringWithFormat:@"/geocoder/v2/?ak=%@&mcode=ios.QiPinCheClient&location=%f,%f&output=json&pois=0", ApplicationDelegate.baiduAK, lat, lon];
    NSLog(@"%@", urlPath);
    MKNetworkOperation *op = [ApplicationDelegate.baiduHttpEngine operationWithPath:urlPath];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSLog(@"ResponseData-%@", [operation responseString]);
        NSError *err;
        NSData *data = [[operation responseString] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
        NSInteger status = [[jsonData objectForKey:@"status"] integerValue];
        NSString *title;
        if (status == 0) {
            NSDictionary *result = [jsonData objectForKey:@"result"];
            title = [result objectForKey:@"sematic_description"];
            NSRange range = [title rangeOfString:@","];
            if (range.length != 0) {
                title = [title substringToIndex:range.location - 1];
            }
            self.srcLocation.text = title;
        } else {
            title = @"定位失败！";
        }
        _annotation.title = title;
        NSLog(@"%@", _annotation.title);
        [_mapView addAnnotation:_annotation];
        [_mapView selectAnnotation:_annotation animated:YES];

    }errorHandler:^(MKNetworkOperation *errOp, NSError *err) {
        NSLog(@"ERR-%@",[err localizedDescription]);
    }];
    [ApplicationDelegate.baiduHttpEngine enqueueOperation:op];
    
}


@end
