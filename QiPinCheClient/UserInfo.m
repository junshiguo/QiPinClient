//
//  UserInfo.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/2.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

// 与用户个人信息相关的一些类

#import "UserInfo.h"

@implementation UserInfo

+ (void)setUserInfoWithUid:(NSString*)uid password:(NSString*)password age:(NSNumber*)age gender:(NSNumber*) gender {
    //NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:password, uid, nil];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:uid forKey:@"uid"];
    [dic setObject:password forKey:@"password"];
    [dic setObject:age forKey:@"age"];
    [dic setObject:gender forKey:@"gender"];
    NSMutableArray *array = [NSMutableArray arrayWithObjects:dic, nil];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filename = [path stringByAppendingPathComponent:@"account.plist"];
    NSLog(@"%@", filename);
    [array writeToFile:filename atomically:YES];
    ApplicationDelegate.uid = uid;
    ApplicationDelegate.password = password;
    ApplicationDelegate.age = age;
    ApplicationDelegate.gender = gender;
    
    NSLog(@"saved!!%@", dic);
}

+ (NSString *)getUid {
    return ApplicationDelegate.uid;
}

+ (NSString *)getPassword {
    return ApplicationDelegate.password;
}

+ (void)clearUserInfo {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filename = [path stringByAppendingPathComponent:@"account.plist"];
    [array writeToFile:filename atomically:YES];
    NSLog(@"cleared!!");
    ApplicationDelegate.uid = nil;
    ApplicationDelegate.password = nil;
    ApplicationDelegate.age = nil;
    ApplicationDelegate.gender = nil;
}

+ (BOOL)hasUserInfo {
    if (ApplicationDelegate.uid == nil) {
        return false;
    }
    return true;
}

+ (NSNumber *)getAge {
    return ApplicationDelegate.age;
}


+ (NSNumber *)getGender {
    return ApplicationDelegate.gender;
}

+ (NSData*)getUserAvatar {
    NSString *string = [NSString stringWithFormat:@"%@%@", [self getUid], @"avatar"];
    NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:string];
    if (imageData != nil) {
        return imageData;
    } else {
        return UIImagePNGRepresentation([UIImage imageNamed:@"noimage.png"]);
    }
    
}

+ (void)setUserAvatar:(UIImage*)image {
    NSString *string = [NSString stringWithFormat:@"%@%@", [self getUid], @"avatar"];
    NSData *imageData = UIImagePNGRepresentation(image);
    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:string];
}

+ (void)resetUserAvatar {
    NSString *string = [NSString stringWithFormat:@"%@%@", [self getUid], @"avatar"];
    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"noimage.png"]);
    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:string];
}

@end
