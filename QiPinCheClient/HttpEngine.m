//
//  HttpEngine.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/2.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "HttpEngine.h"

@implementation HttpEngine

-(id) initWithDefaultSettings {
    
    if(self = [super initWithHostName:@"www.baidu.com" customHeaderFields:@{@"x-client-identifier" : @"iOS"}]) {
        
    }
    
    return self;
}

@end
