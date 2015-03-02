//
//  MTOriginalPriceLabel.m
//  大众点评
//
//  Created by mac on 15-2-7.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "MTLineLabel.h"

@implementation MTLineLabel

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGFloat x = 0 + rect.origin.x;
    CGFloat y = rect.size.height * 0.5 + rect.origin.y;
    UIRectFill(CGRectMake(x, y, rect.size.width, 1));
}


@end
