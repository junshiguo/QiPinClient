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
#import "Pingpp.h"

#define kUrlScheme      @"wx933665aaccea2b32" // 这个是你定义的 URL Scheme，支付宝、微信支付和测试模式需要。

@interface PinCheViewController ()

@end

@implementation PinCheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    float x, y, width, height;;
    x = 0;
    y = self.expGender.frame.origin.y + self.expGender.frame.size.height + 20;
    width = UISCREEN_WIDTH;
    height = self.pinCheButton.frame.origin.y - y -5;
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [_mapView setShowsUserLocation:NO];

    _locService = [[BMKLocationService alloc]init];
    [BMKLocationService setLocationDistanceFilter:100.f];
    _annotation = [[BMKPointAnnotation alloc] init];
    
    self.timePicker.minimumDate = [NSDate date];
    self.expGender.selectedSegmentIndex = 2;
    
    [self initAgeSelector];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLoc:) name:@"LocNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishPayment:) name:@"FinishPayment" object:nil];
}

- (void) finishPayment:(NSNotification*) notification {
    NSLog(@"finishPayment");
    NSString *msg = [notification object];
    if ([msg isEqualToString:@"success"]) {
        [ScreenSwitch switchToScreenIn:@"Order" withStoryboardIdentifier:@"OrderDetailViewController" inView:self withNotificationName:@"BeforeShowOrderDetail" andObject:requestInfo];
    } else {
        [UIAlertShow showAlertViewWithMsg:@"支付失败！"];
    }
}

// 当Home键退出后重新打开该页面需要重新加载视图信息
- (void) applicationDidBecomeActive:(NSNotification *)notification {
    [self refreshView];
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
    self.ageText1.keyboardType = self.ageText2.keyboardType = UIKeyboardTypeNumberPad;
    self.ageText1.text = @"0";
    self.ageText2.text = @"100";
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

- (void) refreshView {
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
    
    [self.view addSubview:_mapView];
    [_locService stopUserLocationService];
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
    
    NSLog(@"拼车请求");
    
    if (![self checkPinCheInfo]) return;
    
    NSDictionary *dic = [self setPinCheParam];
    MKNetworkOperation *op = [ApplicationDelegate.httpEngine operationWithPath:@"/addRequest" params:dic httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSLog(@"%@", [operation responseJSON]);
        [self jumpToOrderDetail:operation];
        //[self jumpToPayment:operation];
        
    } errorHandler:^(MKNetworkOperation *errOp, NSError *err) {
        
    }];
    [ApplicationDelegate.httpEngine enqueueOperation:op];
}

- (void) jumpToPayment:(MKNetworkOperation*) operation {
    NSDictionary *dic = [self setPinCheParam];
    [ScreenSwitch switchToScreenIn:@"Pay" withStoryboardIdentifier:@"PayViewController" inView:self withNotificationName:@"RequestInfo" andObject:dic];
}

- (void) jumpToOrderDetail:(MKNetworkOperation*) operation {
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.mode = MBProgressHUDModeText;
    PinCheViewController * __weak weakSelf = self;
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
            NSString *charge = [result objectForKey:@"charge"];
            [dic setObject:self.startTime.text forKey:@"startTime"];
            [dic setObject:@"1" forKey:@"isCurrent"];
            requestInfo = dic;
            dispatch_async(dispatch_get_main_queue(), ^{
                [Pingpp createPayment:charge viewController:weakSelf appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error) {
                    NSLog(@"completion block: %@", result);
                    if (error == nil) {
                        NSLog(@"PingppError is nil");
                        [ScreenSwitch switchToScreenIn:@"Order" withStoryboardIdentifier:@"OrderDetailViewController" inView:self withNotificationName:@"BeforeShowOrderDetail" andObject:dic];
                    } else {
                        NSLog(@"PingppError: code=%lu msg=%@", (unsigned  long)error.code, [error getMsg]);
                        [UIAlertShow showAlertViewWithMsg:@"支付失败！"];
                    }
                    //[weakSelf showAlertMessage:result];
                }];
            });
            
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


- (NSDictionary*) setPinCheParam {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:[srcLocationDic objectForKey:@"lat"] forKey:@"src_lat"];
    [dic setObject:[srcLocationDic objectForKey:@"lng"] forKey:@"src_lng"];
    
    [dic setObject:[desLocationDic objectForKey:@"lat"] forKey:@"dest_lat"];
    [dic setObject:[desLocationDic objectForKey:@"lng"] forKey:@"dest_lng"];
    
    [dic setObject:self.startTime.text forKey:@"expectTime"];
    [dic setObject:[NSNumber numberWithInteger:self.expGender.selectedSegmentIndex] forKey:@"expectGender"];
    [dic setObject:[NSNumber numberWithInteger:[self.ageText1.text integerValue]] forKey:@"expectAgeMin"];
    [dic setObject:[NSNumber numberWithInteger:[self.ageText2.text integerValue]] forKey:@"expectAgeMax"];
    
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

- (BOOL) checkPinCheInfo {
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
    
    [ScreenSwitch switchToScreenIn:@"Main" withStoryboardIdentifier:@"PlaceSearchViewController" inView:self withNotificationName:@"SelectLocationNotification" andObject:dic];
}

- (IBAction)desLocOnClick:(id)sender {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"desLoc" forKey:@"lastScreen"];
    [dic setObject:@"" forKey:@"initialPlace"];
    [dic setObject:@"1" forKey:@"isCurrent"];
    
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
