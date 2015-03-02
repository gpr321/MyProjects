//
//  MTSortViewController.m
//  大众点评
//
//  Created by mac on 15-2-4.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "MTSortViewController.h"
#import "MTDataTool.h"
#import "MTSort.h"

@interface MTSortViewController ()

@end

@implementation MTSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpButtons];
}

- (void)setUpButtons{
    NSArray *sortArray = [MTDataTool sortData];
    CGFloat margin = 10;
    CGFloat width = 100;
    CGFloat height = 30;
    for (NSInteger i = 0; i < sortArray.count; i++) {
        MTSort *sort = sortArray[i];
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
        [button addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
        button.x = 15;
        button.width = width;
        button.height = height;
        button.y = margin + i * (button.height + margin);
        
        [button setTitle:sort.label forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        [button setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateHighlighted];
    }
    UIView *lastButton = [self.view.subviews lastObject];
    CGFloat w = CGRectGetMaxX(lastButton.frame) + margin;
    CGFloat h = CGRectGetMaxY(lastButton.frame) + margin;
    self.preferredContentSize = CGSizeMake(w, h);
}

#pragma mark - 按钮点击监听
- (void)buttonDidClicked:(UIButton *)button{
    // 销毁控制器
    [self dismissViewControllerAnimated:YES completion:nil];
    // 传值
    MTSort *sort = [MTDataTool sortData][button.tag];
    [MTNotficationCenter postNotificationName:MTSortItemDidClickedNotification object:nil userInfo:@{MTSortItemDidClickedNotificationKey : sort}];
}
@end
