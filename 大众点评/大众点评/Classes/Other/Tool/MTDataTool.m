//
//  MTDataTool.m
//  大众点评
//
//  Created by mac on 15-2-4.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "MTDataTool.h"
#import <MJExtension/MJExtension.h>
#import "MTCategory.h"
#import "MTSort.h"
#import "MTCity.h"
#import "MTCityGroup.h"
#import "MTFindDealParams.h"
#import "GPDianPingManager.h"
#import "MTDeal.h"
#import "MTDealResponse.h"
#import "DPRequest.h"
#import "GPJSonModel.h"

@implementation MTDataTool

+ (DPRequest *)findDealWithParams:(MTFindDealParams *)params success:(void (^)(MTDealResponse *))success error:(void (^)(NSError *))errorBlock{
    return [[GPDianPingManager shareDianPingManager] requestWithURL:[MTFindDealParams urlString] params:[params paramsDictionaries] success:^(id result) {
         MTDealResponse *response = [MTDealResponse objectWithKeyValues:result];
//        MTDealResponse *response = [MTDealResponse gp_objectWithDictionary:result];
        success(response);
    } error:^(NSError *error) {
        errorBlock(error);
    }];
}

+ (NSArray *)categoryData{
    static id categorys = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"categories.plist" ofType:nil];
        categorys = [MTCategory objectArrayWithFile:filePath];
        
    });
    return categorys;
}

+ (NSArray *)sortData{
    static id sortData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sorts.plist" ofType:nil];
        sortData = [MTSort objectArrayWithFile:filePath];
    });
    return sortData;
}

+ (NSArray *)cititesData{
    static id cititesData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"cities.plist" ofType:nil];
        cititesData = [MTCity objectArrayWithFile:filePath];
    });
    return cititesData;
}

+ (NSArray *)citiesGroupsData{
    static id citiesGroupsData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"cityGroups.plist" ofType:nil];
        citiesGroupsData = [MTCityGroup objectArrayWithFile:filePath];
    });
    return citiesGroupsData;
}

+ (MTCity *)cityWithName:(NSString *)name{
    if ( name.length == 0 )return nil;
    return [[[self cititesData] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@",name]] lastObject];
}

@end
