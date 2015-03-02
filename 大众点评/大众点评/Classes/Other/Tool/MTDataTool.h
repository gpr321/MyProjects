//
//  MTDataTool.h
//  大众点评
//
//  Created by mac on 15-2-4.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MTCity,MTFindDealParams,MTDealResponse,DPRequest;

@interface MTDataTool : NSObject
/** 分类数据 class = MTCategory */
+ (NSArray *)categoryData;
/** 排序数据 class = MTSort */
+ (NSArray *)sortData;
/** 城市的数据 class = MTCity */
+ (NSArray *)cititesData;
/** 城市群的数据 class = MTCityGroup */
+ (NSArray *)citiesGroupsData;
/** 根据名字查找对应的 city */
+ (MTCity *)cityWithName:(NSString *)name;
/** 根据传进来的参数获得数据模型, 返回值 class = MTDeal 注意,city为必选参数 */
+ (DPRequest *)findDealWithParams:(MTFindDealParams *)params success:(void (^)(MTDealResponse *response))success error:(void (^)(NSError *error))error;
@end
