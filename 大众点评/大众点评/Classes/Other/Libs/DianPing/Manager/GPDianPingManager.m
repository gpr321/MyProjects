//
//  GPDianPingManager.m
//  大众点评
//
//  Created by mac on 15-2-6.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "GPDianPingManager.h"
#import "DPAPI.h"

@interface GPDianPingManager ()<DPRequestDelegate>

@end

@implementation GPDianPingManager
singtonImplement(DianPingManager)

- (DPRequest *)requestWithURL:(NSString *)urlString params:(NSDictionary *)params success:(SuccessBlock)successBlock error:(ErrorBlock)errorBlock{
    DPRequest *request = [[[DPAPI alloc] init] requestWithURL:urlString params:params delegate:self];
    request.successBlock = successBlock;
    request.errorBlock = errorBlock;
    return request;
}

- (DPRequest *)requestWithURL:(NSString *)urlString paramsString:(NSString *)paramsString success:(SuccessBlock)successBlock error:(ErrorBlock)errorBlock{
    DPRequest *request = [[[DPAPI alloc] init] requestWithURL:urlString paramsString:paramsString delegate:self];
    request.successBlock = successBlock;
    request.errorBlock = errorBlock;
    return request;
}

#pragma mark - DPRequestDelegate
- (void)request:(DPRequest *)request didReceiveResponse:(NSURLResponse *)response{
    
}
- (void)request:(DPRequest *)request didReceiveRawData:(NSData *)data{
    
}
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error{
    if ( request.errorBlock ) {
        request.errorBlock(error);
    }
}
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result{
    if ( request.successBlock ) {
        request.successBlock(result);
    }
}

@end
