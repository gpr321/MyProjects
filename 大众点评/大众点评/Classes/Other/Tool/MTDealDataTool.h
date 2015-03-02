//
//  MTDealDataTool.h
//  大众点评
//
//  Created by mac on 15-2-8.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MTDeal;
@interface MTDealDataTool : NSObject
/** 收藏一个 deal */
+ (void)collectedDeal:(MTDeal *)deal;
/** 取消收藏一个 deal */
+ (void)unCollectDeal:(MTDeal *)deal;
/** 取消收藏一个 deal */
+ (void)unCollectDeals:(NSArray *)deals;
/** 判断给定的deal是否被收藏 */
+ (BOOL)isDealCollected:(MTDeal *)deal;
/** 获取当前被收藏的deals */
+ (NSArray *)collectedDeals;

/** 获得历史浏览记录 */
+ (NSArray *)historyDeals;
/** 保存历史浏览记录 */
+ (void)saveHistoryDeal:(MTDeal *)deal;
/** 取消保存一些历史浏览记录 */
+ (void)unSaveHistoryDeals:(NSArray *)deals;
@end
