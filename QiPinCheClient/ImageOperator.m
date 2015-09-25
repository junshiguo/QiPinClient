//
//  ImageOperator.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/19.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "ImageOperator.h"
#import "AppDelegate.h"

@implementation ImageOperator

+ (void) setImageView:(UIImageView*)imageView withUrlString:(NSString*)urlString inViewController:(UIViewController*)viewController{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:imageView forKey:@"imageView"];
    [dic setObject:urlString forKey:@"urlString"];
    
    if ([urlString isEqualToString:ApplicationDelegate.partnerPhotoUrl]) {
        @try {
            imageView.image =  [UIImage imageWithData:ApplicationDelegate.partnerImageData];
        }
        @catch (NSException *exception) {
            [self setDefaultImageView:imageView];
        }
    } else {
        [self performSelectorInBackground:@selector(setImage:) withObject:dic];
    }

}


+ (void) setDefaultImageView:(UIImageView*)imageView{
    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"noimage.png"]);
    imageView.image = [UIImage imageWithData:imageData];
}

+ (void)setImage:(NSDictionary*)dic {
    UIImageView *imageView = [dic objectForKey:@"imageView"];
    NSString *urlString = [dic objectForKey:@"urlString"];
    
    @try {
        NSLog(@"%@", urlString);
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        imageView.image =  [UIImage imageWithData:data];
    }
    @catch (NSException *exception) {
        [ImageOperator setDefaultImageView:imageView];
    }
    

}

@end
