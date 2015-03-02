//
//  MTBusinesses.h
//  大众点评
//
//  Created by mac on 15-2-6.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTBusinesses : NSObject

/** 状态信息,成功为 OK */
@property (nonatomic,copy) NSString *status;

/** 团购总数 */
@property (nonatomic,strong) NSNumber *total_count;

/** 当前返回的条数 */
@property (nonatomic,strong) NSNumber *count;

/** 团购模型集合                                             */
@property (nonatomic,strong) NSArray *businesses;

@end
