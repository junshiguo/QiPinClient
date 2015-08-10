//
//  BaiduAPIEngine.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/3.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "BaiduAPIEngine.h"

@implementation BaiduAPIEngine

-(id) initWithDefaultSettings {
    if(self = [super initWithHostName:@"api.map.baidu.com" customHeaderFields:@{@"x-client-identifier" : @"iOS"}]) {
        
    }
    
    return self;
    
}

@end
