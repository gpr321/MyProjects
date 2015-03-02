//
//  MTHomeTopItem.m
//  大众点评
//
//  Created by mac on 15-2-4.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "MTHomeTopItem.h"

@interface MTHomeTopItem ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *iconButton;
@end

@implementation MTHomeTopItem

+ (instancetype)homeTopItem{
    return [[[NSBundle mainBundle] loadNibNamed:@"MTHomeTopItem" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    self.autoresizingMask = UIViewAutoresizingNone;
}

+ (instancetype)homeTopItemWithImage:(NSString *)imageName hightLightImageName:(NSString *)hightLightImageName title:(NSString *)title subTitle:(NSString *)subTitle{
    MTHomeTopItem *item = [self homeTopItem];
    [item setImage:imageName hightLightImage:hightLightImageName];
    item.title = title;
    item.subTitle = subTitle;
    return item;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setSubTitle:(NSString *)subTitle{
    _subTitle = subTitle;
    self.subTitleLabel.text = subTitle;
}

- (void)setImage:(NSString *)imageName hightLightImage:(NSString *)hightLightImageName{
    [self.iconButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self.iconButton setImage:[UIImage imageNamed:hightLightImageName] forState:UIControlStateHighlighted];
}

- (void)addTarget:(id)target action:(SEL)action{
    [self.iconButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
