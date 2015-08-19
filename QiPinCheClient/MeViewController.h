//
//  SecondViewController.h
//  QiPinCheClient
//
//  Created by Shijia on 15/8/1.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"
#import <AVFoundation/AVFoundation.h>


@interface MeViewController : UIViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    AVCaptureSession*_AVSession;
    CGRect oldframe;
}
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *gender;
@property (weak, nonatomic) IBOutlet UILabel *job;
@property (weak, nonatomic) IBOutlet UILabel *age;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property(nonatomic,retain) AVCaptureSession * AVSession;

- (IBAction)logOff:(id)sender;
- (IBAction)modifyNickname:(id)sender;
- (IBAction)modifyJob:(id)sender;
- (IBAction)changeAvatar:(id)sender;

@end

