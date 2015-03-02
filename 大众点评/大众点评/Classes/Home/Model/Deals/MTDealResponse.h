//
//  MTMTDealResponse.h
//  大众点评
//
//  Created by mac on 15-2-6.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "MTResponse.h"

@interface MTDealResponse : MTResponse
/** 团购总数 class = MTDeals */
@property (nonatomic,strong) NSArray *deals;
@end
