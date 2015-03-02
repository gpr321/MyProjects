//
//  MTHomeDetailController.m
//  大众点评
//
//  Created by mac on 15-2-7.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "MTHomeDetailController.h"
#import "MTDeal.h"
#import <UIImageView+WebCache.h>
#import "GPDianPingManager.h"
#import "MBProgressHUD+GP.h"
#import "MTDealResponse.h"
#import <MJExtension.h>
#import <UIView+AutoLayout.h>
#import "MTDealDataTool.h"

static NSString *const baseURLString = @"http://lite.m.dianping.com/group/deal/moreinfo/";

@interface MTHomeDetailController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,copy) NSString *dealDetailURLString;
@property (nonatomic,weak) UIActivityIndicatorView *activityIndicatorView;

@property (weak, nonatomic) IBOutlet UIImageView *dealIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *dealTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dealDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *dealCurrPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dealOriginPriceLabel;

@property (weak, nonatomic) IBOutlet UIButton *leftTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *soldNumberButton;
/** 随时退款 */
@property (weak, nonatomic) IBOutlet UIButton *anyTimeRefuntableButton;
/** 过期退 */
@property (weak, nonatomic) IBOutlet UIButton *expiresRefuntableButton;
@property (weak, nonatomic) IBOutlet UIButton *dealCollectionButton;

@end

@implementation MTHomeDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MTDealDataTool saveHistoryDeal:self.deal];
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    // 加载数据
    self.webView.scrollView.hidden = YES;
    self.webView.backgroundColor = GPRGB(230, 230, 230);
    [self.activityIndicatorView startAnimating];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.deal.deal_h5_url]]];
    [self setUpDetail];
    // 保存浏览记录
    
}

#pragma mark - 加载详情信息
- (void)setUpDetail{
    // 图标
    [self.dealIconImageView sd_setImageWithURL:[NSURL URLWithString:self.deal.image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    // 标题
    self.dealTitleLabel.text = self.deal.title;
    // 现价
    self.dealCurrPriceLabel.text = self.deal.current_price;
    // 原价
    self.dealOriginPriceLabel.text = self.deal.list_price;
    // 判断是否被收藏
    self.dealCollectionButton.selected = [MTDealDataTool isDealCollected:self.deal];
    // 剩余时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSDate *deadDate = [fmt dateFromString:self.deal.purchase_deadline];
    deadDate = [deadDate dateByAddingTimeInterval:(24 * 60 * 60)];
    // 跟当前时间相比
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay|NSCalendarUnitHour| NSCalendarUnitMinute;
    NSDateComponents *component = [calender components:unit fromDate:[NSDate date] toDate:deadDate options:kNilOptions];
    NSString *leftTimeText = nil;
    if ( component.day >= 30 ) {
        leftTimeText = @"未来一个月内有效";
    } else {
        leftTimeText = [NSString stringWithFormat:@"剩余%d天%d小时%d分",component.day,component.hour,component.minute];
    }
    [self.leftTimeButton setTitle:leftTimeText forState:UIControlStateNormal];
    // 已经销售数量
    [self.soldNumberButton setTitle:[NSString stringWithFormat:@"已售出%d", self.deal.purchase_count] forState:UIControlStateNormal];
    // 详细信息(需要进一步请求服务器)
    self.dealDetailLabel.text = self.deal.desc;
    NSDictionary *params = @{@"deal_id" : self.deal.deal_id};
    [[GPDianPingManager shareDianPingManager] requestWithURL:@"v1/deal/get_single_deal" params:params success:^(id result) {
//        NSLog(@"请求成功---%@",result);
        MTDealResponse *response = [MTDealResponse objectWithKeyValues:result];
        self.deal = [response.deals lastObject];
        // 支持随时退 (YES设置按钮为selected = yes ,支持过期退跟它同步 ,需要请求服务器)
        self.anyTimeRefuntableButton.selected = self.deal.is_refundable;
        self.expiresRefuntableButton.selected = self.deal.is_refundable;
        // 支持过期退 需要请求服务器
    } error:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力,请稍后重试"];
        MTLog(@"出错了--%@",error);
    }];
}

#pragma mark - 按钮点击事件
- (IBAction)collectedButtonDidClicked:(UIButton *)btn {
    if ( btn.selected == YES ) { // 要做取消收藏的操作
        [MTDealDataTool unCollectDeal:self.deal];
    } else{ // 做收藏的操作
        [MTDealDataTool collectedDeal:self.deal];
    }
    // 改变按钮的状态
    btn.selected = !btn.selected;
}
#pragma mark - 分享按钮
- (IBAction)shareButonDidClicked:(UIButton *)sender {
}

- (IBAction)backButtonDidClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 小菊花
- (UIActivityIndicatorView *)activityIndicatorView{
    if (_activityIndicatorView == nil) {
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.webView addSubview:activityIndicatorView];
        [activityIndicatorView autoCenterInSuperview];
        _activityIndicatorView = activityIndicatorView;
    }
    return _activityIndicatorView;
}

#pragma mark - 固定界面的(不可旋转)
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if ( self.dealDetailURLString == nil ) {
        NSString *deal_id = [self.deal.deal_id substringFromIndex:2];
        self.dealDetailURLString = [baseURLString stringByAppendingFormat:@"%@",deal_id];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.dealDetailURLString]]];
    } else{
        NSString *js = @"document.getElementsByTagName('header')[0].remove();"
        "document.getElementsByClassName('cost-box')[0].remove();"
        "document.getElementsByClassName('buy-now')[0].remove();";
        [webView stringByEvaluatingJavaScriptFromString:js];
        self.activityIndicatorView.hidden = YES;
        [self.activityIndicatorView stopAnimating];
        self.webView.scrollView.hidden = NO;
    }
}

@end
