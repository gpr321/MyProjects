//
//  MTHomeTopItem.h
//  大众点评
//
//  Created by mac on 15-2-4.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTHomeTopItem : UIView

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subTitle;
- (void)setImage:(NSString *)imageName hightLightImage:(NSString *)hightLightImageName;
- (void)addTarget:(id)target action:(SEL)action;

+ (instancetype)homeTopItem;
+ (instancetype)homeTopItemWithImage:(NSString *)imageName hightLightImageName:(NSString *)hightLightImageName title:(NSString *)title subTitle:(NSString *)subTitle;

@end
