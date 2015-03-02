//
//  MTHomeViewController.m
//  大众点评
//
//  Created by mac on 15-2-4.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "MTHomeViewController.h"
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

@interface MTHomeViewController ()<AwesomeMenuDelegate>

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionLayout;
@property (nonatomic,strong) UIBarButtonItem *categoryItem;

@property (nonatomic,strong) UIBarButtonItem *regionItem;

@property (nonatomic,strong) UIBarButtonItem *sortItem;

@property (nonatomic,strong) MTCity *currSelectedCity;

@property (nonatomic,strong) MTDistrict *currSelectedDistrict;

@property (nonatomic,strong) MTSort *currSort;

@property (nonatomic,strong) MTCategory *currCategory;

@property (nonatomic,strong) NSMutableArray *deals;
/** 记录当前刷新到那一页 */
@property (nonatomic,assign) NSInteger currPage;
/** 记录当前请求 */
@property (nonatomic,weak) DPRequest *currRequest;

@property (nonatomic,weak) UIImageView *noDealsImageView;

@end

@implementation MTHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpCollectionView];
    self.collectionView.backgroundColor = GPRGB(230, 230, 230);
    [self setUpNavGationBarButton];
    [self setUpNotificationLinstener];
    [self setUpDefaultData];
    [self setUpAwesomeMenu];
}

- (void)dealloc{
    [self.currRequest disconnect];
    [MTNotficationCenter removeObserver:self];
}

#pragma mark - AwesomeMenu
- (void)setUpAwesomeMenu{
    // 公共背景图片
    UIImage *itemBgImg = [UIImage imageNamed:@"bg_pathMenu_black_normal"];
    // 开始按钮
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_pathMenu_background_normal"] highlightedImage:[UIImage imageNamed:@"icon_pathMenu_background_highlighted"] ContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"]];
    // 个人信息
    AwesomeMenuItem *personalItem = [[AwesomeMenuItem alloc] initWithImage:itemBgImg highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_mine_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_mine_highlighted"]];
    // 收藏
    AwesomeMenuItem *collectedItem = [[AwesomeMenuItem alloc] initWithImage:itemBgImg highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_highlighted"]];
    // 历史记录
    AwesomeMenuItem *hostortItem = [[AwesomeMenuItem alloc] initWithImage:itemBgImg highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_highlighted"]];
    // 更多
    AwesomeMenuItem *moreItem = [[AwesomeMenuItem alloc] initWithImage:itemBgImg highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_more_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_more_highlighted"]];
    
    AwesomeMenu *awesome = [[AwesomeMenu alloc] initWithFrame:CGRectZero startItem:startItem optionMenus:@[personalItem,collectedItem,hostortItem,moreItem]];
    // 设置根按钮不可转
    awesome.rotateAddButton = NO;
    awesome.menuWholeAngle = M_PI_2;
    [self.view addSubview:awesome];
    // 添加约束
    [awesome autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [awesome autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    // 宽高约束
    CGFloat awesomeWH = 250;
    [awesome autoSetDimensionsToSize:CGSizeMake(awesomeWH, awesomeWH)];
    // 设置初始位置
    CGFloat margin = 30;
    [awesome setStartPoint:CGPointMake(margin, awesomeWH - margin)];
    // 设置代理
    awesome.delegate = self;
    awesome.alpha = 0.5;

}
// @[personalItem,collectedItem,hostortItem,moreItem]
#pragma mark - AwesomeMenuDelegate
- (void)awesomeMenuWillAnimateOpen:(AwesomeMenu *)menu
{
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_cross_normal"];
    menu.highlightedContentImage = [UIImage imageNamed:@"icon_pathMenu_cross_highlighted"];
    menu.alpha = 1.0;
}

- (void)awesomeMenuWillAnimateClose:(AwesomeMenu *)menu
{
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_normal"];
    menu.highlightedContentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"];
    menu.alpha = 0.5;
}
- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx{
    switch (idx) {
        case 0: // 个人信息
            MTLog(@"个人信息");
            break;
        case 1:{    // 收藏
            MTCollectedViewController *collectedVc = [[MTCollectedViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
            MTNavigationController *nav = [[MTNavigationController alloc] initWithRootViewController:collectedVc];
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 2: {
            MTHistroyViewController *collectedVc = [[MTHistroyViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
            MTNavigationController *nav = [[MTNavigationController alloc] initWithRootViewController:collectedVc];
            [self presentViewController:nav animated:YES completion:nil]; 
        }
            break;
        case 3: // 更多
            MTLog(@"更多");
            break;
    }
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

#pragma mark - 设置默认的初始化数据
- (void)setUpDefaultData{
    self.currSelectedCity = [MTDataTool cityWithName:@"广州"];
    self.currCategory = [MTDataTool categoryData][1];
    self.currSort = [MTDataTool sortData][0];
    // 修改城市显示
    MTHomeTopItem *itemView = (MTHomeTopItem *)self.regionItem.customView;
    itemView.title = [NSString stringWithFormat:@"%@ - 全部",self.currSelectedCity.name];
    itemView.subTitle = nil;

    // 修改分类显示
    MTHomeTopItem *categoryItemView = (MTHomeTopItem *)self.categoryItem.customView;
    MTCategory *category = self.currCategory;
    [categoryItemView setImage:category.icon hightLightImage:category.highlighted_icon];
    categoryItemView.title = category.name;
    categoryItemView.subTitle = category.subcategories[0];
    // 修改排序显示
    MTHomeTopItem *sortItemView = (MTHomeTopItem *)self.sortItem.customView;
    sortItemView.subTitle = self.currSort.label;
    
    self.collectionView.footerHidden = YES;
    self.noDealsImageView.hidden = NO;
    [self.collectionView headerBeginRefreshing];
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
    self.collectionLayout.minimumLineSpacing = margin;
    self.collectionLayout.minimumInteritemSpacing = margin;
    self.collectionLayout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    CGFloat width = size.width;
    CGFloat precent = 1 / (CGFloat)columns;
    CGFloat itemWidth = precent * width -margin - 0.5 * margin;
    CGFloat itemHeight = precent * width - margin;
    self.collectionLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

#pragma mark - 发送请求到服务器
- (void)loadNewRequest{
    if ( self.currSelectedCity == nil ){
        [self.collectionView headerEndRefreshing];
        return;
    }
    [self.currRequest disconnect];
    MTFindDealParams *params = [[MTFindDealParams alloc] init];
    // 城市名
    params.city = self.currSelectedCity.name;
    // 排序
    params.sort = @(self.currSort.value);
    // 区域
    if ( self.currSelectedDistrict != nil && ![self.currSelectedDistrict.name containsString:@"全部"] ) {
        params.region = self.currSelectedDistrict.name;
    }
    // 分类 category
    if ( self.currCategory && ![self.currCategory.name containsString:@"全部"] ) {
        
        params.category = self.currCategory.name;
    }
    // 清空本地数据
    self.currRequest = [MTDataTool findDealWithParams:params success:^(MTDealResponse *response) {
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
    if ( self.currSelectedCity == nil ){
        [self.collectionView footerEndRefreshing];
        return;
    }
    [self.currRequest disconnect];
    MTFindDealParams *params = [[MTFindDealParams alloc] init];
    // 城市名
    params.city = self.currSelectedCity.name;
    // 排序
    params.sort = @(self.currSort.value);
    // 区域
    if ( self.currSelectedDistrict != nil && ![self.currSelectedDistrict.name containsString:@"全部"] ) {
        params.region = self.currSelectedDistrict.name;
    }
    // 分类 category
    if ( self.currCategory && ![self.currCategory.name containsString:@"全部"] ) {
        params.category = self.currCategory.name;
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

#pragma mark - 设置导航条的按钮
- (void)setUpNavGationBarButton{
    // 右边
    UIBarButtonItem *search = [UIBarButtonItem barButtonItemWithImage:@"icon_search" hightLightImage:@"icon_search_highlighted" target:self action:@selector(searchClick)];
    search.customView.width = 50;
    UIBarButtonItem *map = [UIBarButtonItem barButtonItemWithImage:@"icon_map" hightLightImage:@"icon_map_highlighted" target:self action:@selector(mapClick)];
    map.customView.width = search.customView.width;
    self.navigationItem.rightBarButtonItems = @[search,map];
    
    // 左边
    UIBarButtonItem *logo = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_meituan_logo"] style:UIBarButtonItemStylePlain target:nil action:nil];
    
    MTHomeTopItem *category = [MTHomeTopItem homeTopItem];
    [category setImage:@"icon_category_-1" hightLightImage:@"icon_category_highlighted_-1"];
    [category setTitle:@"美食"];
    [category setSubTitle:@"台湾菜"];
    self.categoryItem = [[UIBarButtonItem alloc] initWithCustomView:category];
    [category addTarget:self action:@selector(categoryItemDidClick)];
    
    MTHomeTopItem *area = [MTHomeTopItem homeTopItem];
    [area setImage:@"icon_district" hightLightImage:@"icon_district_highlighted"];
    area.title = @"广州";
    area.subTitle = @"天河区";
    self.regionItem = [[UIBarButtonItem alloc] initWithCustomView:area];
    [area addTarget:self action:@selector(regionItemDidClick)];
    
    MTHomeTopItem *sort = [MTHomeTopItem homeTopItem];
    [sort setImage:@"icon_sort" hightLightImage:@"icon_sort_highlighted"];
    sort.title = @"排序";
    sort.subTitle = @"默认排序";
    self.sortItem = [[UIBarButtonItem alloc] initWithCustomView:sort];
    [sort addTarget:self action:@selector(sortItemDidClick)];
    
    self.navigationItem.leftBarButtonItems = @[logo,self.categoryItem,self.regionItem,self.sortItem];
}

#pragma mark - 添加通知监听
- (void)setUpNotificationLinstener{
    [MTNotficationCenter addObserver:self selector:@selector(sortDidChanged:) name:MTSortItemDidClickedNotification object:nil];
    [MTNotficationCenter addObserver:self selector:@selector(categoryDidChanged:) name:MTCategoryItemDidClickedNotification object:nil];
    [MTNotficationCenter addObserver:self selector:@selector(regionDidChanged:) name:MTRegionDidChangedNotification object:nil];
    [MTNotficationCenter addObserver:self selector:@selector(districtDidChanged:) name:MTDistrictDidChangeNotification object:nil];
}

#pragma mark - 通知事件处理
- (void)districtDidChanged:(NSNotification *)notification{
    // 记录选中的子地区
    self.currSelectedDistrict = notification.userInfo[MTDistrictDidChangeKey];
    // 取消子地区的数值
    // 首先要该子标题
    MTHomeTopItem *item = (MTHomeTopItem *)self.regionItem.customView;
    // 主标题
    item.title = [NSString stringWithFormat:@"%@ - %@",self.currSelectedCity.name,self.currSelectedDistrict.name];
    // 子标题
    if ( self.currSelectedDistrict.subdistricts.count > 0 ) {
        NSInteger index = [notification.userInfo[MTDistrictDidSelectedKey] integerValue];
        self.currSelectedDistrict.subdistrictsSelectIndex = index;
        item.subTitle = self.currSelectedDistrict.subdistricts[index];
    } else {
        item.subTitle = nil;
    }
//    [self loadNewRequest];
    [self.collectionView headerBeginRefreshing];
}

- (void)sortDidChanged:(NSNotification *)notification{
    MTHomeTopItem *sortItemView = (MTHomeTopItem *)self.sortItem.customView;
    MTSort *sort = notification.userInfo[MTSortItemDidClickedNotificationKey];
    self.currSort = sort;
    sortItemView.subTitle = sort.label;
    
//    [self loadNewRequest];
    [self.collectionView headerBeginRefreshing];
}

- (void)categoryDidChanged:(NSNotification *)notification{
    MTHomeTopItem *categoryItemView = (MTHomeTopItem *)self.categoryItem.customView;
    MTCategory *category = notification.userInfo[MTCategoryItemDidClickedNotificationKey];
    [categoryItemView setImage:category.icon hightLightImage:category.highlighted_icon];
    categoryItemView.title = category.name;
    
    NSNumber *subIndexNumber =notification.userInfo[MTCategoryItemDidClickedNotificationSubIndexKey];
    self.currCategory = category;
    if ( category.subcategories.count > 0 && subIndexNumber != nil ) {
        NSInteger subIndex = [subIndexNumber integerValue];
        categoryItemView.subTitle = category.subcategories[subIndex];
        
        self.currCategory.subcategoriesSelectedIndex = subIndex;
    } else {
        categoryItemView.subTitle = nil;
    }
//    [self loadNewRequest];
    [self.collectionView headerBeginRefreshing];
}

- (void)regionDidChanged:(NSNotification *)notification{
    MTCity *city = notification.userInfo[MTRegionDidChangedKey];
    self.currSelectedCity = city;
    // 取消子地区
    self.currSelectedDistrict = nil;
    MTHomeTopItem *itemView = (MTHomeTopItem *)self.regionItem.customView;
    itemView.title = [NSString stringWithFormat:@"%@ - 全部",city.name];
    itemView.subTitle = nil;
    [self.collectionView headerBeginRefreshing];
//    [self loadNewRequest];
}

#pragma mark - topItem事件处理
- (void)categoryItemDidClick{
    MTCategoryController *catVC = [[MTCategoryController alloc] init];
    catVC.modalPresentationStyle = UIModalPresentationPopover;
    catVC.popoverPresentationController.barButtonItem = self.categoryItem;
    [self presentViewController:catVC animated:YES completion:nil];
}

- (void)regionItemDidClick{
    MTRegionController *regionVC = [[MTRegionController alloc] init];
    regionVC.modalPresentationStyle = UIModalPresentationPopover;
    regionVC.popoverPresentationController.barButtonItem = self.regionItem;
    regionVC.currSelectedCity = self.currSelectedCity;
    [self presentViewController:regionVC animated:YES completion:nil];
}

- (void)sortItemDidClick{
    MTSortViewController *sortVc = [[MTSortViewController alloc] init];
    sortVc.modalPresentationStyle = UIModalPresentationPopover;
    sortVc.popoverPresentationController.barButtonItem = self.sortItem;
    sortVc.popoverPresentationController.passthroughViews = nil;
    [self presentViewController:sortVc animated:YES completion:nil];
}

#pragma mark - 搜索按钮被点击
- (void)searchClick{
    MTSearchViewController *searchVC = [[MTSearchViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
    searchVC.currSelectedCity = self.currSelectedCity;
    searchVC.currSelectedDistrict = self.currSelectedDistrict;
    MTNavigationController *nav = [[MTNavigationController alloc] initWithRootViewController:searchVC];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 地图按钮被点击
- (void)mapClick{

}



@end
