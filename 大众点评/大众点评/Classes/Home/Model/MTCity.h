//
//  MTCity.h
//  大众点评
//
//  Created by mac on 15-2-5.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MTDistrict;

@interface MTCity : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *pinYin;
@property (nonatomic,copy) NSString *pinYinHead;
/** 城市的小区域数据, class = MTDistrict */
@property (nonatomic,copy) NSArray *districts;
@end
