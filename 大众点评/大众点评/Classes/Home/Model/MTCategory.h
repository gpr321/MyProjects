//
//  MTCategory.h
//  大众点评
//
//  Created by mac on 15-2-4.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTCategory : NSObject
@property (nonatomic,copy) NSString *highlighted_icon;
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *small_highlighted_icon;
@property (nonatomic,copy) NSString *small_icon;
@property (nonatomic,strong) NSArray *subcategories;

@property (nonatomic,assign) NSInteger subcategoriesSelectedIndex;
@end
