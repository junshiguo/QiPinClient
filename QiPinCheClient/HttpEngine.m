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
    //10.171.5.228:8080
    
    if(self = [super initWithHostName:@"10.171.5.228:8080" customHeaderFields:@{@"x-client-identifier" : @"iOS"}]) {
        
    }
    
    return self;
}

@end
