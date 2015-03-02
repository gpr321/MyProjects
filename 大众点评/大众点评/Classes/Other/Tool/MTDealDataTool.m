//
//  MTDealDataTool.m
//  大众点评
//
//  Created by mac on 15-2-8.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#define MTCollectedFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"collected_data.arc"]

#define MTHistoryFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"history_data.arc"]

#import "MTDealDataTool.h"

@implementation MTDealDataTool
static NSMutableArray *_histories = nil;
static NSMutableArray *_deals = nil;
+ (void)initialize{
    _deals = [NSKeyedUnarchiver unarchiveObjectWithFile:MTCollectedFilePath];
    _histories = [NSKeyedUnarchiver unarchiveObjectWithFile:MTHistoryFilePath];
    if ( _deals == nil ) {
        _deals = [NSMutableArray array];
    }
    if ( _histories == nil ) {
        _histories = [NSMutableArray array];
    }
}

#pragma mark - 历史浏览记录
+ (NSArray *)historyDeals{
    return _histories;
}

+ (void)saveHistoryDeal:(MTDeal *)deal{
    [_histories removeObject:deal];
    [_histories insertObject:deal atIndex:0];
    [NSKeyedArchiver archiveRootObject:_histories toFile:MTHistoryFilePath];
}

+ (void)unSaveHistoryDeals:(NSArray *)deals{
    [_histories removeObjectsInArray:deals];
    [NSKeyedArchiver archiveRootObject:_histories toFile:MTHistoryFilePath];
}

#pragma mark - 收藏记录
+ (void)unCollectDeals:(NSArray *)deals{
    [_deals removeObjectsInArray:deals];
    [NSKeyedArchiver archiveRootObject:_deals toFile:MTCollectedFilePath];
}

+ (void)collectedDeal:(MTDeal *)deal{
    [_deals insertObject:deal atIndex:0];
    NSString *filePath = MTCollectedFilePath;
    [NSKeyedArchiver archiveRootObject:_deals toFile:filePath];
}

+ (void)unCollectDeal:(MTDeal *)deal{
    [_deals removeObject:deal];
    [NSKeyedArchiver archiveRootObject:_deals toFile:MTCollectedFilePath];
}

+ (BOOL)isDealCollected:(MTDeal *)deal{
    return  [_deals containsObject:deal];
}

+ (NSArray *)collectedDeals{
    return _deals;
}

@end
