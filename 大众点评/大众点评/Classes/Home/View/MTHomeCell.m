//
//  MTHomeCell.m
//  大众点评
//
//  Created by mac on 15-2-5.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "MTHomeCell.h"
#import "MTDeal.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIView+AutoLayout.h>

static CGFloat const coverIconWH = 34;

@interface MTHomeCell ()
@property (weak, nonatomic) IBOutlet UILabel *dealTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dealDescLabel;

@property (weak, nonatomic) IBOutlet UILabel *nowPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orignalPrice;
@property (weak, nonatomic) IBOutlet UILabel *saleCountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *dealImageView;
@property (weak, nonatomic) IBOutlet UIImageView *xindanImageView;
@property (weak, nonatomic) IBOutlet UIView *infoContentView;

/** 遮罩 */
@property (nonatomic,weak) UIButton *cover;
/** 遮罩右下角的图标,默认是隐藏 */
@property (nonatomic,weak) UIImageView *coverIcon;
@end

@implementation MTHomeCell

- (void)setDeal:(MTDeal *)deal{
    _deal = deal;
    self.dealTitleLabel.text = deal.title;
    self.dealDescLabel.text = deal.desc;

    self.nowPriceLabel.text = deal.current_price;
    self.orignalPrice.text = deal.list_price;
    self.saleCountLabel.text = [NSString stringWithFormat:@"已售%d",deal.purchase_count];
    
    [self.dealImageView sd_setImageWithURL:[NSURL URLWithString:deal.image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    self.xindanImageView.hidden = !deal.is_newDeal;
    self.cover.hidden = !deal.isEditing;
    self.coverIcon.hidden = !deal.isChecked;
}

- (void)awakeFromNib{
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dealcell"]];
}

- (UIButton *)cover{
    if ( _cover == nil ) {
        UIButton *cover = [[UIButton alloc] init];
        cover.backgroundColor = [UIColor whiteColor];
        cover.userInteractionEnabled = NO;
        cover.alpha = 0.5;
        cover.hidden = YES;
        [self.contentView addSubview:cover];
        [cover autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        _cover = cover;
    }
    return _cover;
}

- (UIImageView *)coverIcon{
    if ( _coverIcon == nil ) {
        UIImageView *coverIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_order_refundable"]];
        coverIcon.alpha = 0.5;
        coverIcon.hidden = YES;
        [self.contentView addSubview:coverIcon];
        [coverIcon autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [coverIcon autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        [coverIcon autoSetDimension:ALDimensionWidth toSize:coverIconWH];
        [coverIcon autoSetDimension:ALDimensionHeight toSize:coverIconWH];
        _coverIcon = coverIcon;
    }
    return _coverIcon;
}

@end
