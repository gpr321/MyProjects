//
//  MTDistrict.h
//  大众点评
//
//  Created by mac on 15-2-5.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTDistrict : NSObject

@property (nonatomic,copy) NSString *name;
/** 里面放的都是NSString */
@property (nonatomic,strong) NSArray *subdistricts;

@property (nonatomic,assign) NSInteger subdistrictsSelectIndex;

@end
