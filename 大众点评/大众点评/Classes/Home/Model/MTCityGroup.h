//
//  MTCityGroup.h
//  大众点评
//
//  Created by mac on 15-2-5.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTCityGroup : NSObject
@property (nonatomic,copy) NSString *title;
/** 省份的名称 class = NSString */
@property (nonatomic,strong) NSArray *cities;
@end
