//
//  FirstViewController.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/1.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "HomeViewController.h"
#import "Pingpp.h"
#import "BaiduAPIEngine.h"
#import "AppDelegate.h"
#import "ScreenSwitch.h"



@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _locService = [[BMKLocationService alloc]init];
    [BMKLocationService setLocationDistanceFilter:100.f];
    _annotation = [[BMKPointAnnotation alloc] init];
    float x, y, width, height;;
    x = 0;
    y = self.expGender.frame.origin.y + self.expGender.frame.size.height + 30;
    width = UISCREEN_WIDTH;
    height = self.pinCheButton.frame.origin.y - y - 10;
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    //[self.view addSubview:_mapView];

    self.timePicker.minimumDate = [NSDate date];
    self.expGender.selectedSegmentIndex = 2;
    self.expAge.text = @"不限";
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.timePicker.backgroundColor = [UIColor whiteColor];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLoc:) name:@"LocNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [self initAgeArray];
    
    hasShowMapView = NO;
}

- (void)initAgeArray {
    ageArray = @[@"不限", @"70后", @"80后", @"90后", @"00后"];
}

// 当Home键退出后重新打开该页面需要重新加载视图信息
- (void)applicationDidBecomeActive:(NSNotification *)notification {
    [self refreshView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self.ageLower endShowList];
    [self.ageHigher endShowList];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"viewWillAppear");
    
    //_mapView.showsUserLocation = NO;
    float x, y, width, height;;
    x = 0;
    y = self.expGender.frame.origin.y + self.expGender.frame.size.height + 20;
    width = UISCREEN_WIDTH;
    height = self.pinCheButton.frame.origin.y - y -5;
    //if (_mapView != nil) _mapView.hidden = YES;
    _mapView.hidden = NO;
    
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

- (void)refreshView {
    _mapView.showsUserLocation = NO;
    [_locService startUserLocationService];
}

#pragma mark --- 百度地图定位
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    [_mapView setZoomLevel:15];
    CLLocationCoordinate2D coor;
    coor.latitude = userLocation.location.coordinate.latitude;
    coor.longitude = userLocation.location.coordinate.longitude;
    _annotation.coordinate = coor;
    [self getPlaceTitleByLat:coor.latitude andLon:coor.longitude];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSNumber *lat = [NSNumber numberWithDouble:coor.latitude];
    NSNumber *lon = [NSNumber numberWithDouble:coor.longitude];
    [dic setValue:lat forKey:@"lat"];
    [dic setValue:lon forKey:@"lng"];
    
    srcLocationDic = dic;
    if (hasShowMapView == NO) {
        [self.view addSubview:_mapView];
        hasShowMapView = YES;
    }
    
    _mapView.hidden = NO;
    [_locService stopUserLocationService];
}



// 时间选择器相关
- (IBAction)beginSelectTime:(id)sender {
    selectIndex = 0;
    self.timePicker.backgroundColor = [UIColor whiteColor];
    self.timePicker.hidden = false;
    self.toolBar.hidden = false;
    self.startTime.enabled = false;
    _mapView.hidden = true;
    [self.view bringSubviewToFront:self.timePicker];
    [self.view bringSubviewToFront:self.toolBar];
    self.pinCheButton.hidden = true;
}


- (IBAction)expAgeClick:(id)sender {
    selectIndex = 1;
    self.pickerView.hidden = false;
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.toolBar.hidden = false;
    self.expAge.enabled = false;
    _mapView.hidden = true;
    [self.view bringSubviewToFront:self.pickerView];
    [self.view bringSubviewToFront:self.toolBar];
    self.pinCheButton.hidden = true;
}

- (IBAction)startPinChe:(id)sender {
    
    if ([UserInfo getUid] == nil) {
        // 尚未登录
        [ScreenSwitch switchToScreenIn:@"User" withStoryboardIdentifier:@"LoginViewController" inView:self];
    } else {
        NSLog(@"拼车请求");
        if (![self checkPinCheInfo]) return;
        NSDictionary *dic = [self setPinCheParam];
        MKNetworkOperation *op = [ApplicationDelegate.httpEngine operationWithPath:@"/addRequest" params:dic httpMethod:@"POST"];
        NSLog(@"Request Info = %@", dic);
        [op addCompletionHandler:^(MKNetworkOperation *operation) {
            NSLog(@"%@", [operation responseJSON]);
            [self jumpToPayment:operation];
        
        } errorHandler:^(MKNetworkOperation *errOp, NSError *err) {
            [UIAlertShow showAlertViewWithMsg:@"请求创建失败！"];
        }];
        [ApplicationDelegate.httpEngine enqueueOperation:op];
    }
}



- (void)jumpToPayment:(MKNetworkOperation*) operation {
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.mode = MBProgressHUDModeText;
    NSDictionary *data = [operation responseJSON];
    NSInteger status = [[data objectForKey:@"status"] integerValue];
    if (status == 1) {
        NSDictionary *result = [data objectForKey:@"detail"];
        HUD.labelText = @"发布成功，正在跳转...";
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [HUD removeFromSuperview];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setValue:[result objectForKey:@"time"] forKey:@"orderTime"];
            [dic setObject:[result objectForKey:@"id"] forKey:@"requestId"];
            [dic setObject:self.srcLocation.text forKey:@"srcLocation"];
            [dic setObject:self.desLocation.text forKey:@"desLocation"];
            [dic setObject:[result objectForKey:@"deposit"] forKey:@"deposit"];
            [dic setObject:self.startTime.text forKey:@"startTime"];
            requestInfo = dic;
            [ScreenSwitch switchToScreenIn:@"Pay" withStoryboardIdentifier:@"PayViewController" inView:self withNotificationName:@"RequestInfo" andObject:requestInfo];
            
        }];
        
    } else {
        HUD.labelText = [data objectForKey:@"message"];
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [HUD removeFromSuperview];
        }];
    }
}

- (void)showAlertMessage:(NSString*)msg
{
    [UIAlertShow showAlertViewWithMsg:msg];
}


- (NSDictionary*)setPinCheParam {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:[srcLocationDic objectForKey:@"lat"] forKey:@"src_lat"];
    [dic setObject:[srcLocationDic objectForKey:@"lng"] forKey:@"src_lng"];
    
    [dic setObject:[desLocationDic objectForKey:@"lat"] forKey:@"dest_lat"];
    [dic setObject:[desLocationDic objectForKey:@"lng"] forKey:@"dest_lng"];
    
    [dic setObject:self.startTime.text forKey:@"expectTime"];
    [dic setObject:[NSNumber numberWithInteger:self.expGender.selectedSegmentIndex] forKey:@"expectGender"];

    NSInteger maxAge = [self getMaxAge];
    if (maxAge == 0) {
        // 不限年龄
        [dic setObject:[NSNumber numberWithInteger:0] forKey:@"expectAgeMin"];
        [dic setObject:[NSNumber numberWithInteger:100] forKey:@"expectAgeMax"];
    } else {
        [dic setObject:[NSNumber numberWithInteger:0] forKey:@"expectAgeMin"];
        [dic setObject:[NSNumber numberWithInteger:maxAge] forKey:@"expectAgeMax"];
    }

    [dic setObject:ApplicationDelegate.uid forKey:@"phoneNumber"];
    [dic setObject:ApplicationDelegate.age forKey:@"age"];
    [dic setObject:ApplicationDelegate.gender forKey:@"gender"];
    
    NSString *srcName = self.srcLocation.text;
    NSString *desName = self.desLocation.text;
    
    [dic setObject:srcName  forKey:@"src_name"];
    [dic setObject:desName forKey:@"dest_name"];
    
    NSLog(@"%@", dic);
    
    return dic;
    
}

// 根据选择的年龄段获取年龄范围
- (NSInteger)getMaxAge {

    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSInteger year = [[dateFormatter stringFromDate:now] integerValue];
    
    if ([self.expAge.text isEqualToString:@"不限"]) {
        return 0;
    } else if ([self.expAge.text isEqualToString:@"70后"]) {
        return year - 1970;
    } else if ([self.expAge.text isEqualToString:@"80后"]) {
        return year - 1980;
    } else if ([self.expAge.text isEqualToString:@"90后"]) {
        return year - 1990;
    } else if ([self.expAge.text isEqualToString:@"00后"]) {
        return year - 2000;
    }
    return 0;
}

- (BOOL)checkPinCheInfo {
    if ([self.srcLocation.text length] == 0 || [self.desLocation.text length] == 0 || [self.startTime.text length] == 0) {
        [UIAlertShow showAlertViewWithMsg:@"您输入的信息不完整！"];
        return false;
    }
    return true;
    
}

#pragma mark --- 跳至地点搜索页面
- (IBAction)srcLocOnClick:(id)sender {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"srcLoc" forKey:@"lastScreen"];
    [dic setObject:self.srcLocation.text forKey:@"initialPlace"];
    
    [ScreenSwitch switchToScreenIn:@"Main" withStoryboardIdentifier:@"PlaceSearchViewController" inView:self withNotificationName:@"SelectLocationNotification" andObject:dic withObserverRemoved:NO];
}

- (IBAction)desLocOnClick:(id)sender {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"desLoc" forKey:@"lastScreen"];
    [dic setObject:@"" forKey:@"initialPlace"];
    [dic setObject:@"1" forKey:@"isCurrent"];
    
    [ScreenSwitch switchToScreenIn:@"Main" withStoryboardIdentifier:@"PlaceSearchViewController" inView:self withNotificationName:@"SelectLocationNotification" andObject:dic withObserverRemoved:NO];
}



// 选择器toolbar
- (IBAction)toolBarBackClick:(id)sender {
    self.timePicker.hidden = true;
    self.pickerView.hidden = true;
    self.toolBar.hidden = true;
    self.startTime.enabled = true;
    self.pinCheButton.hidden = false;
    self.expAge.enabled = true;
    _mapView.hidden = false;
}
- (IBAction)toolBarSaveClick:(id)sender {
    self.toolBar.hidden = true;
    self.timePicker.hidden = true;
    self.pickerView.hidden = true;
    _mapView.hidden = false;
    if (selectIndex == 0) {
        // 时间选择器
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        self.startTime.text = [dateFormatter stringFromDate:self.timePicker.date];
        self.startTime.enabled = true;
    } else {
        // 年龄选择器
        self.expAge.enabled = true;
        self.expAge.text = [ageArray objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    }
    self.pinCheButton.hidden = false;
}


#pragma mark --- 年龄区间选择器
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
//每列对应多少行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [ageArray count];
}

//每列每行对应显示的数据是什么
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [ageArray objectAtIndex:row];
}


#pragma mark --- 键盘
// 关闭键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


// 根据经纬度获得地点名称
- (void)getPlaceTitleByLat:(float)lat andLon:(float)lon {
    
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

- (void)dealloc {
    
    //[super dealloc];  非ARC中需要调用此句
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
@end
