//
//  MTSearchViewController.h
//  大众点评
//
//  Created by mac on 15-2-9.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MTCity,MTDistrict;
@interface MTSearchViewController : UICollectionViewController
@property (nonatomic,strong) MTCity *currSelectedCity;
@property (nonatomic,strong) MTDistrict *currSelectedDistrict;
@end
