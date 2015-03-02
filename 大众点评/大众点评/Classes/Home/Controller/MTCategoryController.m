//
//  MTCategoryController.m
//  大众点评
//
//  Created by mac on 15-2-4.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "MTCategoryController.h"
#import "MTCategory.h"
#import "MTDataTool.h"
#import "MTDropDownViewLeftCell.h"
#import "MTDropDownViewRightCell.h"

@interface MTCategoryController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *leftTableView;

@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

@property (nonatomic,strong) NSArray *categories;


@end

@implementation MTCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSArray *)categories{
    if ( _categories == nil ) {
        _categories = [MTDataTool categoryData];
    }
    return _categories;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ( tableView == self.leftTableView ) {
        return self.categories.count;
    } else {
        NSInteger selectRow = [self.leftTableView indexPathForSelectedRow].row;

        MTCategory *category = self.categories[selectRow];
        return category.subcategories.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if ( tableView == self.leftTableView ) {
        cell = [MTDropDownViewLeftCell dropDownViewLeftCellWithTableView:tableView];
        MTCategory *category = self.categories[indexPath.row];
        cell.textLabel.text = category.name;
        if ( category.subcategories.count > 0 ) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else {
        cell = [MTDropDownViewRightCell dropDownViewRightCellWithTableView:tableView];
        MTCategory *category = self.categories[[self.leftTableView indexPathForSelectedRow].row];
        cell.textLabel.text = category.subcategories[indexPath.row];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MTCategory *category = self.categories[[self.leftTableView indexPathForSelectedRow].row];
    if ( tableView == self.leftTableView ) { // 左边item处理
        [self.rightTableView reloadData];
        if ( category.subcategories.count == 0 ) {
            [MTNotficationCenter postNotificationName:MTCategoryItemDidClickedNotification object:nil userInfo:@{MTCategoryItemDidClickedNotificationKey:category}];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else { // 右边item处理
        [MTNotficationCenter postNotificationName:MTCategoryItemDidClickedNotification object:nil userInfo:@{MTCategoryItemDidClickedNotificationKey:category,MTCategoryItemDidClickedNotificationSubIndexKey:@([self.rightTableView indexPathForSelectedRow].row)}];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
