//
//  MTFindDealParams.m
//  大众点评
//
//  Created by mac on 15-2-6.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "MTFindDealParams.h"
#import <MJExtension.h>

@implementation MTFindDealParams

- (NSDictionary *)paramsDictionaries{
    return [[MTFindDealParams keyValuesArrayWithObjectArray:@[self]] lastObject];
}

- (NSNumber *)sort{
    if ( _sort.integerValue > 7 || _sort.integerValue < 1 ) {
        return @1;
    }
    return _sort;
}

+ (NSString *)urlString{
    return @"v1/deal/find_deals";
}

@end
