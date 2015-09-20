//
//  PersonalInfoViewController.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/10.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "PersonalInfoViewController.h"

@interface PersonalInfoViewController ()

@end

@implementation PersonalInfoViewController


- (void)viewDidLoad {
    NSLog(@"PersonalInfoViewController---viewDidLoad");
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getInfo:) name:@"ShowPartnerInfo" object:nil];
    [self hideAllLabels];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapped)];
    [self.imageView addGestureRecognizer:singleTap];
    self.imageView.userInteractionEnabled = YES;
}

- (void) getInfo:(NSNotification*)notification {
    NSLog(@"PersonalInfoViewController---getInfo");
    NSDictionary *dic = [notification object];
    NSLog(@"getInfo, dic=%@", dic);

    if ([dic objectForKey:@"ShowPhoneNumber"] != nil) showPhoneNumber = YES;
    else showPhoneNumber = NO;
    phoneNumber = [dic objectForKey:@"partnerPhoneNumber"];
    
    // 在双方未确认前不显示对方手机号
    if (!showPhoneNumber) self.phoneNumberLabel.text = @"XXXXXXXXXXX";
    else self.phoneNumberLabel.text = [dic objectForKey:@"partnerPhoneNumber"];
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setObject:phoneNumber forKey:@"phoneNumber"];
    MKNetworkOperation *op = [ApplicationDelegate.httpEngine operationWithPath:@"/getUserInfo" params:data httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSDictionary *response = [operation responseJSON];
        
        NSInteger statusCode = [[response objectForKey:@"status"] integerValue];
        if (statusCode == 1) {
            NSDictionary *dic = [response objectForKey:@"detail"];
            self.nickName.text = [dic objectForKey:@"name"];
            if ([[dic objectForKey:@"gender"] integerValue] == 0) {
                self.gender.text = @"男";
            } else {
                self.gender.text = @"女";
            }
            self.age.text = [NSString stringWithFormat:@"%li岁", [[dic objectForKey:@"age"] integerValue]];
            self.job.text = [dic objectForKey:@"job"];
            NSLog(@"dic=%@", dic);
            if ([[dic objectForKey:@"historyRating"] floatValue] >= 0) {
                NSString *scoreText = [NSString stringWithFormat:@"%.1f/5.0", [[dic objectForKey:@"historyRating"] floatValue]];
                self.score.text = scoreText;
                
            } else {
                self.score.text = @"XX";
            }
            if ([dic objectForKey:@"photo"] != nil) {
                [ImageOperator setImageView:self.imageView withUrlString:[dic objectForKey:@"photo"]];
            } else {
                [ImageOperator setDefaultImageView:self.imageView];
            }
            [self showAllLabels];
        } else {
            NSString *message = [response objectForKey:@"message"];
            if (message == nil) {
                message = @"网络异常 10060";
            }
            [UIAlertShow showAlertViewWithMsg:message];
        }
            } errorHandler:^(MKNetworkOperation *errOp, NSError *err) {
        [UIAlertShow showAlertViewWithMsg:@"网络异常 10061"];
        
    }];
    [ApplicationDelegate.httpEngine enqueueOperation:op];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void) hideAllLabels {
    self.nickName.hidden = YES;
    self.phoneNumberLabel.hidden = YES;
    self.age.hidden = YES;
    self.gender.hidden = YES;
    self.job.hidden = YES;
    self.score.hidden = YES;
}

- (void) showAllLabels {
    self.nickName.hidden = NO;
    self.phoneNumberLabel.hidden = NO;
    self.age.hidden = NO;
    self.gender.hidden = NO;
    self.job.hidden = NO;
    self.score.hidden = NO;
}

#pragma mark --- 头像相关
- (void) photoTapped {
    NSLog(@"PersonalInfoViewController---photoTapped");
    if (self.imageView.image) {
        UIImage *image = self.imageView.image;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
        oldframe = [self.imageView convertRect:self.imageView.bounds toView:window];
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:oldframe];
        imageView.image = image;
        imageView.tag = 1;
        [backgroundView addSubview:imageView];
        [window addSubview:backgroundView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
        [backgroundView addGestureRecognizer: tap];
        
        [UIView animateWithDuration:0.3 animations:^{
            imageView.frame = CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
            backgroundView.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }
}


- (void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView = tap.view;
    UIImageView *imageView = (UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = oldframe;
        backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

- (void)dealloc {
    
    //[super dealloc];  非ARC中需要调用此句
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
@end
