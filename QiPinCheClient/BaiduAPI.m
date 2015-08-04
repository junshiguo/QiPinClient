//
//  BaiduAPI.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/3.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "BaiduAPI.h"
#import "AppDelegate.h"

@implementation BaiduAPI

+ (NSString*) getPlaceTitleByLat:(float) lat andLon:(float)lon {
    
    NSString *urlPath = [NSString stringWithFormat:@"/geocoder/v2/?ak=%@&callback=renderReverse&location=%f,%f&output=json&pois=0", ApplicationDelegate.baiduAK, lat, lon];
    MKNetworkOperation *op = [ApplicationDelegate.baiduHttpEngine operationWithPath:urlPath];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSLog(@"ResponseData-%@", [operation responseString]);
    }errorHandler:^(MKNetworkOperation *errOp, NSError *err) {
        NSLog(@"ERR-%@",[err localizedDescription]);
    }];
    return @"复旦大学";
}

@end
