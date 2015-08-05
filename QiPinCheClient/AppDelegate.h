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

#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    BMKMapManager *_mapManager;
    NSArray *orderObjs;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HttpEngine *httpEngine;
@property (strong, nonatomic) BaiduAPIEngine *baiduHttpEngine;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *baiduAK;


@end

