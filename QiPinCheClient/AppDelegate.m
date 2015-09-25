//
//  AppDelegate.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/1.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "AppDelegate.h"
#import "Pingpp.h"
#import "PinCheViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize httpEngine = _httpEngine;
@synthesize baiduHttpEngine = _baiduHttpEngine;
@synthesize uid = _uid;
@synthesize password = _password;
@synthesize baiduAK = _baiduAK;
@synthesize age = _age;
@synthesize gender = _gender;
@synthesize route = _route;
@synthesize partnerPhotoUrl = _partnerPhotoUrl;
@synthesize partnerImageData = _partnerImageData;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"didFinishLaunchingWithOptions");
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    self.baiduAK = @"Uxn99a5gZWXDQ33gRx9STwmz";
    
    //HttpEngine
    self.httpEngine = [[HttpEngine alloc] initWithDefaultSettings];
    [self.httpEngine useCache];
    
    self.baiduHttpEngine = [[BaiduAPIEngine alloc] initWithDefaultSettings];
    [self.baiduHttpEngine useCache];
    
    //UserAccount
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"account.plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:filename];
    if (array == nil || [array count] == 0) {
        self.uid = nil;
        self.password = nil;
    } else {
        NSDictionary *dic = [array objectAtIndex:0];
        self.uid = [dic objectForKey:@"uid"];
        self.password = [dic objectForKey:@"password"];
        self.age = [dic objectForKey:@"age"];
        self.gender = [dic objectForKey:@"gender"];
        NSLog(@"%@,%@,%@,%@", self.uid, self.password, self.age, self.gender);
    }
    
    //BMKMap
    _mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:@"Uxn99a5gZWXDQ33gRx9STwmz" generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed");
    }
    
    //环信
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"qipin#qipinche" apnsCertName:nil];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
        
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [BMKMapView willBackGround];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[EaseMob sharedInstance] applicationDidEnterBackground:application]; 
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [BMKMapView didForeGround];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}

void uncaughtExceptionHandler(NSException*exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@",[exception callStackSymbols]);
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"sourceApplication annotation");
    [Pingpp handleOpenURL:url withCompletion:^(NSString *result, PingppError *error) {
        // result : success, fail, cancel, invalid
        NSString *msg;
        if (error == nil) {
            NSLog(@"PingppError is nil11111");
            msg = result;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FinishPayment" object:@"success"];
        } else {
            NSLog(@"PingppError: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
            msg = [NSString stringWithFormat:@"result=%@ PingppError: code=%lu msg=%@", result, (unsigned long)error.code, [error getMsg]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FinishPayment" object:@"fail"];
        }
    }];
    return  YES;
}

// 禁止横屏
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}




@end
