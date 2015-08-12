//
//  PagesEntity.h
//  RefreshTableview
//
//  Created by baxiang on 13-5-18.
//  Copyright (c) 2013年 巴翔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PagesEntity : NSObject{
    
	int pageSize;//每页多少条
	long rowCount;//总记录数
	
	long current;//当前页
	long pageCount;//总页数
	BOOL isEnd;
}
@property(nonatomic) int pageSize;
@property(nonatomic) long rowCount;//总记录数
@property(nonatomic) long current;//当前页
@property(nonatomic) long pageCount;//总页数
@property(nonatomic) BOOL isEnd;
@end


