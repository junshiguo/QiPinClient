//
//  BaiduAPI.h
//  QiPinCheClient
//
//  Created by Shijia on 15/8/3.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaiduAPIEngine.h"

@interface BaiduAPI : NSObject

+ (NSString*) getPlaceTitleByLat:(float) lat andLon:(float)lon;

@end
