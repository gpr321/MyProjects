//
//  MTCity.m
//  大众点评
//
//  Created by mac on 15-2-5.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "MTCity.h"
#import "MTDistrict.h"
@implementation MTCity

+ (NSDictionary *)objectClassInArray{
    return @{@"districts" : [MTDistrict class]};
}

@end
