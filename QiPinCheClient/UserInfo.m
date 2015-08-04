//
//  UserInfo.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/2.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

+ (void)setUserInfoWithUid:(NSString*)uid password:(NSString*)password {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:password, uid, nil];
    NSMutableArray *array = [NSMutableArray arrayWithObjects:dic, nil];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filename = [path stringByAppendingPathComponent:@"account.plist"];
    NSLog(@"%@", filename);
    [array writeToFile:filename atomically:YES];
    ApplicationDelegate.uid = uid;
    ApplicationDelegate.password = password;
    NSLog(@"saved!!");
}

+ (NSString *)getUid {
    return ApplicationDelegate.uid;
}

+ (NSString *)getPassword {
    return ApplicationDelegate.password;
}

+ (void)clearUserInfo {
    NSArray *array = [[NSArray alloc] initWithObjects:nil, nil, nil];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filename = [path stringByAppendingPathComponent:@"account.plist"];
    [array writeToFile:filename atomically:YES];
    NSLog(@"cleared!!");
    ApplicationDelegate.uid = nil;
    ApplicationDelegate.password = nil;
}

+ (BOOL)hasUserInfo {
    if (ApplicationDelegate.uid == nil) {
        return false;
    }
    return true;
}


@end
