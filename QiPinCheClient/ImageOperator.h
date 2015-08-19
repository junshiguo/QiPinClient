//
//  ImageOperator.h
//  QiPinCheClient
//
//  Created by Shijia on 15/8/19.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageOperator : NSObject

+ (void) setImageView:(UIImageView*)imageView withUrlString:(NSString*)urlString;
+ (void) setDefaultImageView:(UIImageView*)imageView;

@end
