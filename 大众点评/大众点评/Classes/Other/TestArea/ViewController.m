//
//  ViewController.m
//  大众点评
//
//  Created by mac on 15-2-2.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "ViewController.h"
#import "GPDianPingManager.h"
#import "Person.h"
#import "MTFindDealParams.h"
#import <MJExtension.h>
#import "MTDeal.h"
#import "MTDealResponse.h"
#import "MTDataTool.h"
#import "NSString+Regex.h"
#import "GPDianPingManager.h"
#import "GPJSonModel.h"
#import "MTDeal.h"

@interface ViewController ()

@end

@implementation ViewController

/**
 NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
 NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES  %@", emailRegex];
 return [emailTest evaluateWithObject:email];
 */

- (void)viewDidLoad {
    [super viewDidLoad];
 
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSDictionary *params = @{
                             @"deal_id" : @"1-5097286"
                             };
    
    [[GPDianPingManager shareDianPingManager] requestWithURL:@"v1/deal/get_single_deal" params:params success:^(id result) {
         NSLog(@"请求成功---%@",result);
        MTDealResponse *response = [MTDealResponse gp_objectWithDictionary:result];
        MTDeal *deal = [response.deals lastObject];
        NSLog(@"%@",deal);
        // 支持过期退 需要请求服务器
    } error:^(NSError *error) {
        MTLog(@"出错了--%@",error);
    }];
}


@end
