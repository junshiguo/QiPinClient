//
//  UserInfo.h
//  QiPinCheClient
//
//  Created by Shijia on 15/8/2.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface UserInfo : NSObject

+ (void)setUserInfoWithUid:(NSString*)uid password:(NSString*)password;
+ (NSString *)getUid;
+ (NSString *)getPassword;
+ (void)clearUserInfo;
+ (BOOL)hasUserInfo;

@end
