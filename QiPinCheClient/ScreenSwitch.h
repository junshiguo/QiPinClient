//
//  ScreenSwitch.h
//  QiPinCheClient
//
//  Created by Shijia on 15/8/1.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreenSwitch : NSObject

+ (void) switchToScreenIn:(NSString*)storyboardName withStoryboardIdentifier: (NSString*)storyboardIdentifier inView:(UIViewController*) view;


@end
