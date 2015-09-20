//
//  ImageOperator.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/19.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "ImageOperator.h"

@implementation ImageOperator

+ (void) setImageView:(UIImageView*)imageView withUrlString:(NSString*)urlString {
    /*@try {
        NSLog(@"%@", urlString);
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        imageView.image =  [UIImage imageWithData:data];
    }
    @catch (NSException *exception) {
        [self setDefaultImageView:imageView];
    }*/
    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"noimage.png"]);
    imageView.image = [UIImage imageWithData:imageData];
}


+ (void) setDefaultImageView:(UIImageView*)imageView {
    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"noimage.png"]);
    imageView.image = [UIImage imageWithData:imageData];
}

@end
