//
//  MTDropDownViewLeftCell.m
//  大众点评
//
//  Created by mac on 15-2-4.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "MTDropDownViewLeftCell.h"

@implementation MTDropDownViewLeftCell

+ (instancetype)dropDownViewLeftCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"MTDropDownViewLeftCell";
    MTDropDownViewLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if ( cell == nil ) {
        cell = [[MTDropDownViewLeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_leftpart"]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_left_selected"]];
    }
    return cell;
}

@end
