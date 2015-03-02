//
//  MTSearchViewController.m
//  大众点评
//
//  Created by mac on 15-2-4.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "MTSearchViewController.h"
#import "UIBarButtonItem+Button.h"
#import "MTHomeTopItem.h"
#import "MTDataTool.h"
#import "MTSortViewController.h"
#import "MTCategoryController.h"
#import "MTRegionController.h"
#import "MTSort.h"
#import "MTCategory.h"
#import "MTCity.h"
#import "MTDistrict.h"
#import "MTHomeCell.h"
#import "MTDeal.h"
#import "MTHomeCell.h"
#import "MTFindDealParams.h"
#import <MBProgressHUD.h>
#import "MBProgressHUD+GP.h"
#import <MJRefresh.h>
#import "MTDealResponse.h"
#import "DPRequest.h"
#import "MTHomeDetailController.h"
#import <UIView+AutoLayout.h>
#import "AwesomeMenu.h"
#import "MTCollectedViewController.h"
#import "MTNavigationController.h"
#import "MTHistroyViewController.h"
#import "MTSearchViewController.h"

static CGFloat const horizonalColumnCount = 4;
static CGFloat const verticalColumnCount = 2;
static CGFloat const margin = 50;

@interface MTSearchViewController ()<UISearchBarDelegate>

@property (nonatomic,strong) NSMutableArray *deals;
/** 记录当前刷新到那一页 */
@property (nonatomic,assign) NSInteger currPage;
/** 记录当前请求 */
@property (nonatomic,weak) DPRequest *currRequest;

@property (nonatomic,weak) UIImageView *noDealsImageView;
/** 搜索框 */
@property (nonatomic,strong) UISearchBar *searchBar;

@end

@implementation MTSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpCollectionView];
    self.collectionView.backgroundColor = GPRGB(230, 230, 230);

}

- (void)dealloc{
    [self.currRequest disconnect];
}

#pragma mark - 当前没有数据使用此 View 来显示
- (UIImageView *)noDealsImageView{
    if (_noDealsImageView == nil) {
        // icon_deals_empty
        UIImageView *noDealsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_deals_empty"]];
        noDealsImageView.contentMode = UIViewContentModeCenter;
        [self.view addSubview:noDealsImageView];
        [noDealsImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        _noDealsImageView = noDealsImageView;
    }
    return _noDealsImageView;
}

- (NSMutableArray *)deals{
    if (_deals == nil) {
        _deals = [[NSMutableArray alloc]init];
    }
    return _deals;
}

#pragma mark - 搜索框懒加载
- (UISearchBar *)searchBar{
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
        _searchBar.delegate = self;
    }
    return _searchBar;
}

#pragma mark - 适配初始化屏幕的尺寸
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGFloat column = 0;
    if ( MTHorizonalScreen ) {
        column = horizonalColumnCount;
    } else {
        column = verticalColumnCount;
    }
    [self setUpCellSizeWithSize:[UIScreen mainScreen].bounds.size margin:margin columnCount:column];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    CGFloat column = 0;
    if ( size.width > 768 ) {
        column = horizonalColumnCount;
    } else {
        column = verticalColumnCount;
    }
    [self setUpCellSizeWithSize:size margin:margin columnCount:column];
}

- (void)setUpCellSizeWithSize:(CGSize)size margin:(CGFloat)margin columnCount:(NSInteger)columns{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.minimumLineSpacing = margin;
    layout.minimumInteritemSpacing = margin;
    layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    CGFloat width = size.width;
    CGFloat precent = 1 / (CGFloat)columns;
    CGFloat itemWidth = precent * width -margin - 0.5 * margin;
    CGFloat itemHeight = precent * width - margin;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [MBProgressHUD showMessage:@"正在帮你检索中请稍等..."];
    [self.searchBar endEditing:YES];
    [self loadNewRequest];
}

#pragma mark - 发送请求到服务器
- (void)loadNewRequest{
    if ( self.currSelectedCity == nil || self.searchBar.text.length == 0 ){
        [self.collectionView headerEndRefreshing];
        [MBProgressHUD showError:@"请输入搜索关键字"];
        return;
    }
    [self.currRequest disconnect];
    MTFindDealParams *params = [[MTFindDealParams alloc] init];
    // 城市名
    params.city = self.currSelectedCity.name;
    // 排序
    params.sort = @(1);
    // 区域
    if ( self.currSelectedDistrict != nil && ![self.currSelectedDistrict.name containsString:@"全部"] ) {
        params.region = self.currSelectedDistrict.name;
    }
    // 分类 category
    params.keyword = self.searchBar.text;
    // 清空本地数据
    self.currRequest = [MTDataTool findDealWithParams:params success:^(MTDealResponse *response) {
        [MBProgressHUD hideHUD];
        [self.deals removeAllObjects];
        [self.deals addObjectsFromArray:response.deals];
        [self.collectionView reloadData];
        self.currPage = 1;
        [self dealWithResponse:response];
    } error:^(NSError *error) {
        [self.collectionView headerEndRefreshing];
        [MBProgressHUD showError:@"服务器忙...请稍等"];
    }];
}

- (void)loadMoreRequest{
    if ( self.currSelectedCity == nil || self.searchBar.text.length == 0 ){
        [self.collectionView headerEndRefreshing];
        [MBProgressHUD showError:@"请输入搜索关键字"];
        return;
    }
    [self.currRequest disconnect];
    MTFindDealParams *params = [[MTFindDealParams alloc] init];
    // 城市名
    params.city = self.currSelectedCity.name;
    // 排序
    params.sort = @(1);
    // 区域
    params.keyword = self.searchBar.text;
    if ( self.currSelectedDistrict != nil && ![self.currSelectedDistrict.name containsString:@"全部"] ) {
        params.region = self.currSelectedDistrict.name;
    }
    // 设置页码
    NSInteger tempPage = self.currPage;
    tempPage++;
    params.page = @(tempPage);
    self.currRequest = [MTDataTool findDealWithParams:params success:^(MTDealResponse *response) {
        [self.deals addObjectsFromArray:response.deals];
        self.currPage++;
        [self dealWithResponse:response];
        [self.collectionView reloadData];
    } error:^(NSError *error) {
        [self.collectionView footerEndRefreshing];
        [MBProgressHUD showError:@"服务器忙...请稍等"];
    }];
}

- (void)dealWithResponse:(MTDealResponse *)response{
    [self.collectionView headerEndRefreshing];
    [self.collectionView footerEndRefreshing];
    self.collectionView.footerHidden = (self.deals.count == response.total_count);
}

#pragma mark - 设置 collectionView
- (void)setUpCollectionView{
    [self.collectionView registerNib:[UINib nibWithNibName:@"MTHomeCell" bundle:nil] forCellWithReuseIdentifier:@"homecell"];
    // 下拉刷新
    [self.collectionView addHeaderWithTarget:self action:@selector(loadNewRequest)];
    // 上拉刷新
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreRequest)];
    self.collectionView.headerRefreshingText = @"正在在帮你加载数据...";
    self.collectionView.footerRefreshingText = @"正在在帮你加载数据...";
    // 添加导航栏搜索框
    UIView *searchContainView = [[UIView alloc] init];
    searchContainView.backgroundColor = [UIColor clearColor];
    searchContainView.width = 300;
    searchContainView.height = 40;
    [searchContainView addSubview:self.searchBar];
    [self.searchBar autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.navigationItem.titleView = searchContainView;
    // 左边的返回按钮
     UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:@"icon_back" hightLightImage:@"icon_back_highlighted" target:self action:@selector(backBarbuttonitemDidClicked)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

#pragma mark - 返回
- (void)backBarbuttonitemDidClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count = self.deals.count;
    if ( count ) {
        self.noDealsImageView.hidden = YES;
    } else {
        self.noDealsImageView.hidden = NO;
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MTHomeCell *cell = (MTHomeCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"homecell" forIndexPath:indexPath];
    MTDeal *deal = self.deals[indexPath.item];
    cell.deal = deal;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MTDeal *deal = self.deals[indexPath.item];
    MTHomeDetailController *detailVc = [[MTHomeDetailController alloc] init];
    detailVc.deal = deal;
    [self presentViewController:detailVc animated:YES completion:nil];
}

@end
