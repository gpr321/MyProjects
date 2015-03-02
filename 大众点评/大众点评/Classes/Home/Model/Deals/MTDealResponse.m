//
//  MTMTDealResponse.m
//  大众点评
//
//  Created by mac on 15-2-6.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "MTDealResponse.h"
#import "MTDeal.h"
#import "GPJSonModel.h"

@implementation MTDealResponse

+ (NSDictionary *)gp_objectClassesInArryProperties{
    return @{@"deals" : [MTDeal class]};
}


+ (NSDictionary *)objectClassInArray{
    return @{@"deals" : [MTDeal class]};
}

@end
