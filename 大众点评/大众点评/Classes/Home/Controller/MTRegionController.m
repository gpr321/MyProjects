//
//  MTAreaController.m
//  大众点评
//
//  Created by mac on 15-2-4.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "MTRegionController.h"
#import "MTCityGroupViewController.h"
#import "MTNavigationController.h"
#import "MTCity.h"
#import "MTDistrict.h"
#import "MTDropDownViewRightCell.h"
#import "MTDropDownViewLeftCell.h"

static NSString *const leftCellID = @"leftCellID";
static NSString *const rightCellID = @"rightCellID";

@interface MTRegionController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

@end

@implementation MTRegionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
}

#pragma mark - tableView 设置数据源 和 代理
- (void)setUpTableView{
    self.leftTableView.dataSource = self;
    self.leftTableView.delegate = self;
    self.rightTableView.dataSource = self;
    self.rightTableView.delegate = self;
//    [self.leftTableView registerClass:[MTDropDownViewRightCell class] forCellReuseIdentifier:leftCellID];
//    [self.rightTableView registerClass:[MTDropDownViewRightCell class] forCellReuseIdentifier:rightCellID];
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - 当前选中的city
- (void)setCurrSelectedCity:(MTCity *)currSelectedCity{
    _currSelectedCity = currSelectedCity;
    [self.leftTableView reloadData];
}

#pragma mark - 切换城市
- (IBAction)changCity:(id)sender {
    // 销毁当前控制器
    [self dismissViewControllerAnimated:YES completion:nil];
    // modal 一个控制器出来(使用根控制器)
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    MTCityGroupViewController *cityVC = [[MTCityGroupViewController alloc] init];
    MTNavigationController *nav = [[MTNavigationController alloc] initWithRootViewController:cityVC];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [rootVC presentViewController:nav animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MTCity *city = self.currSelectedCity;
    if ( tableView == self.leftTableView ) {
      return city.districts.count;
    } else {
        NSInteger row = [self.leftTableView indexPathForSelectedRow].row;
        MTDistrict *district = city.districts[row];
        return  district.subdistricts.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    NSString *text = nil;
    if ( tableView == self.leftTableView ) {
        cell = [MTDropDownViewLeftCell dropDownViewLeftCellWithTableView:tableView];
        MTDistrict *district = self.currSelectedCity.districts[indexPath.row];
        text = [district name];
        if ( district.subdistricts.count > 0 ) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    } else {
        cell = [MTDropDownViewRightCell dropDownViewRightCellWithTableView:tableView];
        NSInteger row = [self.leftTableView indexPathForSelectedRow].row;
        MTDistrict *district = self.currSelectedCity.districts[row];
        text = district.subdistricts[indexPath.row];
    }
    cell.textLabel.text = text;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 发送通知 MTDistrict index
    // 让当前控制器销毁
    if ( tableView == self.leftTableView ) { // 左边
        MTDistrict *district = self.currSelectedCity.districts[indexPath.row];
        if ( district.subdistricts.count == 0 ) {
            [self postNotificationWith:district selectIndex:nil];
            return;
        }
        [self.rightTableView reloadData];
    } else {
        MTDistrict *district = self.currSelectedCity.districts[[self.leftTableView indexPathForSelectedRow].row];
        [self postNotificationWith:district selectIndex:@(indexPath.row)];
    }
    
}

- (void)postNotificationWith:(MTDistrict *)district selectIndex:(NSNumber *)selectedIndex{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    if ( selectedIndex != nil ) {
        userInfo[MTDistrictDidSelectedKey] = selectedIndex;
    }
    userInfo[MTDistrictDidChangeKey] = district;
    [MTNotficationCenter postNotificationName:MTDistrictDidChangeNotification object:nil userInfo:userInfo];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
