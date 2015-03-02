//
//  MTDropDownViewRightCell.m
//  大众点评
//
//  Created by mac on 15-2-4.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "MTDropDownViewRightCell.h"

@implementation MTDropDownViewRightCell

+ (instancetype)dropDownViewRightCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"MTDropDownViewRightCell";
    MTDropDownViewRightCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if ( cell == nil ) {
        cell = [[MTDropDownViewRightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_rightpart"]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_right_selected"]];
    }
    
    return cell;
}

@end
