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

+ (void)setUserInfoWithUid:(NSString*)uid password:(NSString*)password age:(NSNumber*)age gender:(NSNumber*)gender;
+ (NSString *)getUid;
+ (NSString *)getPassword;
+ (NSNumber *)getAge;
+ (NSNumber *)getGender;
+ (void)clearUserInfo;
+ (BOOL)hasUserInfo;

@end
