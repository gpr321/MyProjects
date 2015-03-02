//
//  MTCityViewController.m
//  大众点评
//
//  Created by mac on 15-2-5.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "MTCityGroupViewController.h"
#import "MTCityGroup.h"
#import "MTDataTool.h"
#import "MTCitySearchController.h"
#import <UIView+AutoLayout.h>

@interface MTCityGroupViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,weak) UIButton *cover;
@property (nonatomic,strong) NSArray *citiesGroup;
@property (nonatomic,weak) MTCitySearchController *searchVC;
@end

@implementation MTCityGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.showsCancelButton = YES;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MTCityGroup"];
}

- (MTCitySearchController *)searchVC{
    if ( _searchVC == nil ) {
        MTCitySearchController *searchVC = [[MTCitySearchController alloc] init];
        [self addChildViewController:searchVC];
        [self.view addSubview:searchVC.view];
        _searchVC = searchVC;
        // 添加约束
        [searchVC.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTop];
        [searchVC.view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.searchBar];
        // 默认为隐藏
        searchVC.view.hidden = YES;
    }
    return _searchVC;
}

#pragma mark - 城市群的数据
- (NSArray *)citiesGroup{
    if (_citiesGroup == nil) {
        _citiesGroup = [MTDataTool citiesGroupsData];
    }
    return _citiesGroup;
}

- (UIButton *)cover{
    if ( _cover == nil ) {
        UIButton *cover = [[UIButton alloc] init];
        cover.frame = CGRectMake(100, 100, 100, 100);
        cover.backgroundColor = [UIColor blackColor];
        [cover addTarget:self action:@selector(coverDidClick) forControlEvents:UIControlEventTouchUpInside];
        cover.alpha = 0.5;
        // 默认隐藏
        cover.hidden = YES;
        // 添加约束
        [self.view addSubview:cover];
        [cover autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(self.tableView.y, 0, 0, 0)];
        _cover = cover;
    }
    return _cover;
}

#pragma mark - 处理搜索城市
- (void)dealWithSearchText:(NSString *)searchText{
    if ( searchText.length == 0 ){
        self.searchVC.view.hidden = YES;
        return;
    }
    self.searchVC.view.hidden = NO;
    self.searchVC.searchText = searchText;
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    // 搜索城市
    [self dealWithSearchText:searchText];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar endEditing:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    // 显示蒙版
    self.cover.hidden = NO;
    // 更换searchBar背景
    self.searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield_hl"];
    // 隐藏导航条
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    // 让蒙版消失
    self.cover.hidden = YES;
    // 更换背景图片
    self.searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
    // 显示导航条
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.searchVC.view.hidden = YES;
}

#pragma mark - 蒙版按钮被点击了
- (void)coverDidClick{
    // searBar 结束编辑
    [self.searchBar endEditing:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.citiesGroup.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MTCityGroup *group = self.citiesGroup[section];
    return group.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"MTCityGroup";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    MTCityGroup *group = self.citiesGroup[indexPath.section];
    cell.textLabel.text = group.cities[indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    MTCityGroup *group = self.citiesGroup[section];
    return group.title;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MTCityGroup *group = self.citiesGroup[indexPath.section];
    NSString *name = group.cities[indexPath.row];
    MTCity *city = [MTDataTool cityWithName:name];
    NSDictionary *useInfo = @{MTRegionDidChangedKey : city};
    [MTNotficationCenter postNotificationName:MTRegionDidChangedNotification object:nil userInfo:useInfo];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
