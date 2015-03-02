//
//  MTHistroyViewController.m
//  大众点评
//
//  Created by mac on 15-2-8.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "MTHistroyViewController.h"
#import "MTDealDataTool.h"
#import "MTDeal.h"
#import "MTHomeCell.h"
#import "MTHomeDetailController.h"
#import "UIBarButtonItem+Button.h"
#import <UIView+AutoLayout.h>

static CGFloat const horizonalColumnCount = 4;
static CGFloat const verticalColumnCount = 2;
static CGFloat const margin = 50;

#define MTBarbuttonTitle(text) [NSString stringWithFormat:@"  %@  ",(text)]

@interface MTHistroyViewController ()
/** 界面数据 */
@property (nonatomic,strong) NSArray *deals;
/** 用来保存用户要处理的数据的集合 */
@property (nonatomic,strong) NSMutableArray *tempDeals;
/** 当没有加载数据的时候会显示该view */
@property (nonatomic,weak) UIImageView *noDealsImageView;
/** 编辑按钮 */
@property (nonatomic,weak) UIBarButtonItem *editBarButton;
/** 全选按钮 */
@property (nonatomic,strong) UIBarButtonItem *selectAllBarButton;
/** 全不选 */
@property (nonatomic,strong) UIBarButtonItem *unSelectAllBarButton;
/** 删除按钮 */
@property (nonatomic,strong) UIBarButtonItem *deleteBarButton;
/** 用来标志是否进入编辑状态 */
@property (nonatomic,assign,getter = isEditing) BOOL editing;
/** 用来记录当前多少个cell被选中 */
@property (nonatomic,assign) NSInteger selectedCount;
@end

@implementation MTHistroyViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpCollectionView];
}

#pragma mark - tempDeals 懒加载
- (NSMutableArray *)tempDeals{
    if (_tempDeals == nil) {
        _tempDeals = [[NSMutableArray alloc]init];
    }
    return _tempDeals;
}

#pragma mark - setSelectedCount
- (void)setSelectedCount:(NSInteger)selectedCount{
    _selectedCount = selectedCount;
    NSString *deleteTitle = nil;
    if ( selectedCount == 0 ) {
        deleteTitle = @"删除";
    } else {
        deleteTitle = [NSString stringWithFormat:@"删除(%d)",selectedCount];
    }
    self.deleteBarButton.title = MTBarbuttonTitle(deleteTitle);
}

#pragma mark - UIBarButtonItem懒加载
- (UIBarButtonItem *)selectAllBarButton{
    if (_selectAllBarButton == nil) {
        _selectAllBarButton = [[UIBarButtonItem alloc] initWithTitle:MTBarbuttonTitle(@"全选") style:UIBarButtonItemStylePlain target:self action:@selector(selectedAllButtonDidClicked:)];
    }
    return _selectAllBarButton;
}

- (UIBarButtonItem *)unSelectAllBarButton{
    if (_unSelectAllBarButton == nil) {
        _unSelectAllBarButton = [[UIBarButtonItem alloc] initWithTitle:MTBarbuttonTitle(@"取消全选选") style:UIBarButtonItemStylePlain target:self action:@selector(unSelectedAllButtonDidClicked:)];
    }
    return _unSelectAllBarButton;
}

- (UIBarButtonItem *)deleteBarButton{
    if (_deleteBarButton == nil) {
        _deleteBarButton = [[UIBarButtonItem alloc] initWithTitle:MTBarbuttonTitle(@"删除") style:UIBarButtonItemStylePlain target:self action:@selector(deleteButtonDidClicked:)];
    }
    return _deleteBarButton;
}

#pragma mark - 返回按钮
- (void)backBarbuttonitemDidClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 导航条按钮点击监听
- (void)editButtonDidClicked{
    self.editing = !self.isEditing;
    for (MTDeal *item in self.deals) {
        item.isEditing = self.isEditing;
    }
    self.editBarButton.title = !self.isEditing ? @"编辑" : @"完成";
    [self.collectionView reloadData];
}

- (void)selectedAllButtonDidClicked:(UIBarButtonItem *)buttonItem{
    for (MTDeal *item in self.deals) {
        item.isChecked = YES;
    }
    self.selectedCount = self.deals.count;
    [self.tempDeals addObjectsFromArray:self.deals];
    [self.collectionView reloadData];
}

- (void)unSelectedAllButtonDidClicked:(UIBarButtonItem *)buttonItem{
    for (MTDeal *item in self.deals) {
        item.isChecked = NO;
    }
    self.selectedCount = 0;
    [self.tempDeals removeAllObjects];
    [self.collectionView reloadData];
}

- (void)deleteButtonDidClicked:(UIBarButtonItem *)buttonItem{
    if ( self.tempDeals.count == 0 ) return;
    [MTDealDataTool unSaveHistoryDeals:self.tempDeals];
    self.deals = [MTDealDataTool historyDeals];
    self.selectedCount = 0;
    [self editButtonDidClicked];
    [self.collectionView reloadData];
    
}

#pragma mark - 当前没有数据使用此 View 来显示
- (UIImageView *)noDealsImageView{
    if (_noDealsImageView == nil) {
        // icon_deals_empty
        UIImageView *noDealsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_collects_empty"]];
        noDealsImageView.contentMode = UIViewContentModeCenter;
        [self.view addSubview:noDealsImageView];
        [noDealsImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        _noDealsImageView = noDealsImageView;
    }
    return _noDealsImageView;
}

#pragma mark - 懒加载
- (NSArray *)deals{
    if (_deals == nil) {
        _deals = [MTDealDataTool historyDeals];
    }
    return _deals;
}

#pragma mark - 处理不同屏幕方向的尺寸
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGFloat column = 0;
    if ( MTHorizonalScreen ) {
        column = horizonalColumnCount;
    } else {
        column = verticalColumnCount;
    }
    [self setUpCellSizeWithSize:[UIScreen mainScreen].bounds.size margin:margin columnCount:column];
    self.deals = [MTDealDataTool historyDeals];
    [self.collectionView reloadData];
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

#pragma mark - 设置 collectionView
- (void)setUpCollectionView{
    [self.collectionView registerNib:[UINib nibWithNibName:@"MTHomeCell" bundle:nil] forCellWithReuseIdentifier:@"homecell"];
    self.collectionView.backgroundColor = GPRGB(230, 230, 230);
    [self setUpBarButtonItem];
    self.title = @"历史浏览记录";
}

- (void)setUpBarButtonItem{
    // 左边
    UIBarButtonItem *leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:@"icon_back" hightLightImage:@"icon_back_highlighted" target:self action:@selector(backBarbuttonitemDidClicked)];
    self.navigationItem.leftBarButtonItems = @[leftBarButtonItem,self.selectAllBarButton,self.unSelectAllBarButton,self.deleteBarButton];
    // 右边
    UIBarButtonItem *editBarButton = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editButtonDidClicked)];
    self.navigationItem.rightBarButtonItem = editBarButton;
    self.editBarButton = editBarButton;
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count = self.deals.count;
    self.noDealsImageView.hidden = count != 0;
    self.editBarButton.enabled = count != 0;
    self.selectAllBarButton.enabled = self.selectedCount != count && self.isEditing;
    self.unSelectAllBarButton.enabled = self.selectedCount  && self.isEditing;
    self.deleteBarButton.enabled = self.selectedCount != 0;
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
    if ( self.editing == NO ) {
        [self presentViewController:detailVc animated:YES completion:nil];
    } else {
        deal.isChecked = !deal.isChecked;
        self.selectedCount += (deal.isChecked ? 1 : -1);
        [self.tempDeals addObject:deal];
        [self.collectionView reloadData];
    }
}


@end
