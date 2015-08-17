//
//  NewOrderCell.h
//  QiPinCheClient
//
//  Created by Shijia on 15/8/5.
//  Copyright (c) 2015年 QiPinChe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeText;
@property (weak, nonatomic) IBOutlet UILabel *srcLocation;
@property (weak, nonatomic) IBOutlet UILabel *desLocation;
@property (weak, nonatomic) IBOutlet UIButton *showMore;
@property (weak, nonatomic) NSString *orderId;

@end
