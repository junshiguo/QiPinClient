//
//  FinishedOrderDetailViewController.m
//  QiPinCheClient
//
//  Created by Shijia on 15/8/10.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import "FinishedOrderDetailViewController.h"
#import "TQStarRatingView.h"

@implementation FinishedOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    
    float x = 31;
    float y = 290;
    
    
    TQStarRatingView *starRatingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(x, y, 250, 50) numberOfStar:5];

    starRatingView.delegate = self;
    [self.view addSubview:starRatingView];
    NSLog(@"111");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)starRatingView:(TQStarRatingView *)view score:(float)score {
    self.score.text = [NSString stringWithFormat:@"%0.2f分",score * 5];
}


- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)showPartenerDetail:(id)sender {
    [ScreenSwitch switchToScreenIn:@"Profile" withStoryboardIdentifier:@"PersonalInfoViewController" inView:self];
}
@end
