//
//  ScreenSwitch.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/1.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "ScreenSwitch.h"


@implementation ScreenSwitch


+ (void) switchToScreenIn:(NSString*)storyboardName withStoryboardIdentifier:(NSString*)storyboardIdentifier inView:(UIViewController *)view{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:storyboardIdentifier];
    //controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [[NSNotificationCenter defaultCenter] removeObserver:view];
    [view presentViewController:controller animated:YES completion:^{}];
}

+ (void) switchToScreenIn:(NSString *)storyboardName withStoryboardIdentifier:(NSString *)storyboardIdentifier inView:(UIViewController *)view withNotificationName:(NSString*)notificationName andObject:(NSObject*)object {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:storyboardIdentifier];
    [[NSNotificationCenter defaultCenter] removeObserver:view];
    [view presentViewController:controller animated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:object];
    }];
    
}

@end
