//
//  MTDealResponse.h
//  大众点评
//
//  Created by mac on 15-2-6.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTResponse : NSObject
/** 相应地状态信息 */
@property (nonatomic,copy) NSString *status;
/** 团购总数 */
@property (nonatomic,assign) NSInteger total_count;
/** 当前返回数量 */
@property (nonatomic,assign) NSInteger count;
@end
