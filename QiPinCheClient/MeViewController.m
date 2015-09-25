//
//  SecondViewController.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/1.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "MeViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define PHOTO_MAX_LENGTH 1048576


@interface MeViewController ()

@end

@implementation MeViewController


- (void)viewDidLoad {
    NSLog(@"MeViewController---viewDidLoad");
    [super viewDidLoad];
    
    if ([UserInfo getUid] == nil) {
        [ScreenSwitch switchToScreenIn:@"User" withStoryboardIdentifier:@"LoginViewController" inView:self];
    } else {
        NSData *imageData = [UserInfo getUserAvatar];
        self.imageView.image = [UIImage imageWithData:imageData];
        self.phoneNumber.text = [UserInfo getUid];
        
        
        
        // 修改用户名和昵称的监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nickNameChanged:) name:@"ChangedNickName" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jobChanged:) name:@"ChangedJob" object:nil];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapped)];
        [self.imageView addGestureRecognizer:singleTap];
        self.imageView.userInteractionEnabled = YES;
        
        // 获取个人信息
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[UserInfo getUid] forKey:@"phoneNumber"];
        MKNetworkOperation *op = [ApplicationDelegate.httpEngine operationWithPath:@"/getUserInfo" params:dic httpMethod:@"POST"];
        [op addCompletionHandler:^(MKNetworkOperation *operation) {
            NSDictionary *response = [operation responseJSON];
            NSLog(@"%@", response);
            NSInteger statusCode = [[response objectForKey:@"status"] integerValue];
            if (statusCode == 1) {
                NSDictionary *dic = [response objectForKey:@"detail"];
                self.phoneNumber.text = [UserInfo getUid];
                self.nickName.text = [dic objectForKey:@"name"];
                
                if ([[dic objectForKey:@"gender"] integerValue]== 0) {
                    self.gender.text = @"男";
                } else {
                    self.gender.text = @"女";
                }
                self.age.text = [NSString stringWithFormat:@"%i", [[dic objectForKey:@"age"] intValue]];
                self.job.text = [dic objectForKey:@"job"];
            } else {
                [UIAlertShow showAlertViewWithMsg:@"网络异常 10030"];
            }
            
        } errorHandler:^(MKNetworkOperation *errOp, NSError *err) {
            [UIAlertShow showAlertViewWithMsg:@"网络异常 10031"];
        }];
        [ApplicationDelegate.httpEngine enqueueOperation:op];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --- 头像相关
- (void)photoTapped {
    NSLog(@"MeViewController---photoTapped");
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
    NSLog(@"MeViewController---hideImage");
    UIView *backgroundView = tap.view;
    UIImageView *imageView = (UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = oldframe;
        backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}


#pragma mark --- 修改个人信息
- (void)nickNameChanged:(NSNotification*)notification {
    self.nickName.text = [notification object];
}

- (void)jobChanged:(NSNotification*)notification {
    self.job.text = [notification object];
}


// 注销登录
- (IBAction)logOff:(id)sender {
    NSLog(@"logOff");
    [UserInfo clearUserInfo];
    [ScreenSwitch switchToScreenIn:@"Main" withStoryboardIdentifier:@"TabBarController" inView:self];
    
    // 环信退出登陆地接口
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        if (!error) {
            NSLog(@"退出成功");
        }
    } onQueue:nil];
    
}
- (IBAction)modifyNickname:(id)sender {
    [ScreenSwitch switchToScreenIn:@"Profile" withStoryboardIdentifier:@"ModifyNicknameViewController" inView:self withObserverRemoved:NO];
}

- (IBAction)modifyJob:(id)sender {
    [ScreenSwitch switchToScreenIn:@"Profile" withStoryboardIdentifier:@"ModifyJobViewController" inView:self withObserverRemoved:NO];
}

- (void)snapImage{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        if(authStatus == AVAuthorizationStatusAuthorized)
        {
            NSLog(@"允许状态");
            UIImagePickerController * picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.allowsEditing = NO;
            //打开相册选择照片
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
            
        }
        else if (authStatus == AVAuthorizationStatusDenied)
        {
            NSLog(@"不允许状态，可以弹出一个alertview提示用户在隐私设置中开启权限");
            [UIAlertShow showAlertViewWithMsg:@"没有访问您相机的权限，请在隐私设置中打开相机的权限"];
        }
        else if (authStatus == AVAuthorizationStatusNotDetermined)
        {
            NSLog(@"系统还未知是否访问，第一次开启相机时");
        }

        
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
        [alert show];
    }
    
}
//从相册里找
- (void)pickImage{
    //相册是可以用模拟器打开的
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        
        //打开相册选择照片
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self uploadImage:info];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 上传头像
- (void)uploadImage:(NSDictionary*) info {
    NSLog(@"info~~%@",info);
    NSLog(@"uploadImage");
    UIImage* image=[info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData;
    NSString *photoType, *photoMimiType;
    
    if (UIImagePNGRepresentation(image)) {
        //返回为png图像。
        imageData = UIImagePNGRepresentation(image);
        photoType = @"PNG";
        photoMimiType=@"application/x-png";
        NSLog(@" +++++++++ is png");
    } else {
        //返回为JPEG图像。
        imageData = UIImageJPEGRepresentation(image, 1.0);
        photoType=@"JPG";
        photoMimiType=@"application/x-jpg";
        NSLog(@" +++++++++ is jpg");
    }
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    
    
    while ([imageData length] > PHOTO_MAX_LENGTH && compression > maxCompression)
    {
        compression -= 0.10;
        imageData = UIImageJPEGRepresentation(image, compression);
        photoType = @"JPG";
        NSLog(@"Compress");
    }

    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[UserInfo getUid] forKey:@"phoneNumber"];
    [dic setValue:photoType forKey:@"photoType"];
    MKNetworkOperation *op = [ApplicationDelegate.httpEngine operationWithPath:@"/uploadImage" params:dic httpMethod:@"POST"];
    [op addData:imageData forKey:@"image" mimeType:photoMimiType fileName:[NSString stringWithFormat:@"%@.%@", [UserInfo getUid], photoType]];
    [op addCompletionHandler:^(MKNetworkOperation *operation) {
        NSInteger statusCode = [[[operation responseJSON] objectForKey:@"status"] integerValue];
        if (statusCode == 1) {
            self.imageView.image = image;
            //读取用户隐私，包含经纬度 创建时间
            NSURL*url = [info objectForKey:UIImagePickerControllerReferenceURL];
            //添加一个系统库
            ALAssetsLibrary *ass = [[ALAssetsLibrary alloc]init];
            [ass assetForURL:url resultBlock:^(ALAsset *asset) {
                NSLog(@"头像上传成功");
               // NSLog(@"%@",[asset valueForKey:ALAssetPropertyAssetURL]);
                
            } failureBlock:nil];
            [UserInfo setUserAvatar:image];
        } else {
            [self failToUpload];
        }
    }errorHandler:^(MKNetworkOperation *completedOperation,NSError *error) {
        NSLog(@"mknetwork error : %@", error.debugDescription);
        [self failToUpload];
    }];
    [ApplicationDelegate.httpEngine enqueueOperation:op];
    
    
}


- (void)failToUpload {
    NSLog(@"failToUpload");
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = @"头像上传失败";
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [HUD removeFromSuperview];
        [UserInfo resetUserAvatar];
        [ImageOperator setDefaultImageView:self.imageView];
    }];
    
}

//取消
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

// 更换头像菜单
- (IBAction)changeAvatar:(id)sender {
    UIActionSheet *menu=[[UIActionSheet alloc] initWithTitle:@"上传图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"从相册上传", nil];
    menu.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [menu showInView:self.view];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self snapImage];
    } else if (buttonIndex == 1) {
        [self pickImage];
    }
}

@end
