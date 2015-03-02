//
//  MTCitySearchController.m
//  大众点评
//
//  Created by mac on 15-2-5.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "MTCitySearchController.h"
#import "MTCity.h"
#import "MTDataTool.h"

static NSString *const ID = @"cityCell";

@interface MTCitySearchController ()
@property (nonatomic,strong) NSArray *cities;
@end

@implementation MTCitySearchController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
}

- (void)setSearchText:(NSString *)searchText{
    searchText = [searchText lowercaseString];
    _searchText = searchText;
    NSPredicate *predit = [NSPredicate predicateWithFormat:@"name contains %@ or pinYin contains %@ or pinYinHead contains %@",searchText,searchText,searchText];
    self.cities = [[MTDataTool cititesData] filteredArrayUsingPredicate:predit];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.textLabel.text = [self.cities[indexPath.row] name];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    NSDictionary *userInfo = @{MTRegionDidChangedKey : self.cities[indexPath.row]};
    [MTNotficationCenter postNotificationName:MTRegionDidChangedNotification object:nil userInfo:userInfo];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"共搜索到 %zd 条结果",self.cities.count];
}

@end
