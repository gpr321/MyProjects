//
//  MTHomeNavigationController.m
//  大众点评
//
//  Created by mac on 15-2-4.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "MTNavigationController.h"

@interface MTNavigationController ()

@end

@implementation MTNavigationController

+ (void)initialize{
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"bg_navigationBar_normal"] forBarMetrics:UIBarMetricsDefault];
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:15],NSForegroundColorAttributeName : [UIColor blackColor]};
    bar.titleTextAttributes = attributes;
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    [barItem setTintColor:GPRGB(104, 187, 173)];
}

@end
