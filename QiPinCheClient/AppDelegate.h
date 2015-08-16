//
//  AppDelegate.h
//  QiPinCheClient
//
//  Created by Shijia on 15/8/1.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpEngine.h"
#import "UserInfo.h"
#import <BaiduMapAPI/BMapKit.h>
#import "BaiduAPIEngine.h"
#import "CommonHeader.h"

#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define UISCREEN_WIDTH [UIScreen mainScreen].applicationFrame.size.width
#define UISCREEN_HEIGHT [UIScreen mainScreen].applicationFrame.size.height

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    BMKMapManager *_mapManager;
    NSArray *orderObjs;
    NSArray *route;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HttpEngine *httpEngine;
@property (strong, nonatomic) BaiduAPIEngine *baiduHttpEngine;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *baiduAK;
@property (strong, nonatomic) NSNumber *age;
@property (strong, nonatomic) NSNumber *gender;
@property (strong, nonatomic) NSArray *route;


@end

