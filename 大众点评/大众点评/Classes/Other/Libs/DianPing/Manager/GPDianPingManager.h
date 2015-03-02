//
//  GPDianPingManager.h
//  大众点评
//
//  Created by mac on 15-2-6.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPSingleTon.h"
#import "DPAPI.h"

@interface GPDianPingManager : NSObject<NSCopying>

singtonInterface(DianPingManager)

- (DPRequest *)requestWithURL:(NSString *)urlString paramsString:(NSString *)paramsString success:(SuccessBlock)successBlock error:(ErrorBlock)errorBlock;

- (DPRequest *)requestWithURL:(NSString *)urlString params:(NSDictionary *)params success:(SuccessBlock)successBlock error:(ErrorBlock)errorBlock;


@end
