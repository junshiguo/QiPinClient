//
//  AppDelegate.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/1.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize httpEngine = _httpEngine;
@synthesize baiduHttpEngine = _baiduHttpEngine;
@synthesize uid = _uid;
@synthesize password = _password;
@synthesize baiduAK = _baiduAK;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
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
        self.uid = [[dic allKeys] objectAtIndex:0];
        self.password = [dic objectForKey:self.uid];
        NSLog(@"%@,%@", self.uid, self.password);
    }
    //BMKMap
    _mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:@"Uxn99a5gZWXDQ33gRx9STwmz" generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed");
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
