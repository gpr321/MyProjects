//
//  MTBusiness.m
//  大众点评
//
//  Created by mac on 15-2-6.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "MTBusiness.h"
#import <MJExtension.h>
#import "GPJSonModel.h"
@implementation MTBusiness
MJCodingImplementation
- (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

+ (NSDictionary *)gp_dictionaryKeysMatchToPropertyNames{
    return @{@"id" : @"ID"};
}
@end
