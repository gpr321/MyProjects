//
//  MTDeal.m
//  大众点评
//
//  Created by mac on 15-2-6.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "MTDeal.h"
#import "MTBusiness.h"
#import "NSString+Regex.h"
#import <MJExtension.h>
#import "GPJSonModel.h"
#import "GPJSonModel.h"

@implementation MTDeal
MJCodingImplementation

- (void)setPublish_date:(NSString *)publish_date{
    _publish_date = publish_date;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSDate *publishDate = [fmt dateFromString:publish_date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay;
    NSDateComponents *comp = [calendar components:unit fromDate:publishDate toDate:[NSDate date] options:kNilOptions];
    if ( comp.year == 0 && comp.month == 0 && comp.day == 0 ) {
        self.is_newDeal = YES;
    } else {
        self.is_newDeal = NO;
    }
}

- (void)setList_price:(NSString *)list_price{
    if ( [list_price gp_matchWithRegex:@"^\\d*\\.\\d*$"] ) { // 保修两位小数
        list_price = [NSString stringWithFormat:@"%.2f",[list_price floatValue]];
    }
    _list_price = [NSString stringWithFormat:@"￥%@",list_price];
}

- (void)setCurrent_price:(NSString *)current_price{
    if ( [current_price gp_matchWithRegex:@"^\\d*\\.\\d*$"] ) { // 保修两位小数
        current_price = [NSString stringWithFormat:@"%.2f",[current_price floatValue]];
    }
    _current_price = [NSString stringWithFormat:@"￥%@",current_price];
}

+ (NSDictionary *)gp_objectClassesInArryProperties{
    return @{@"businesses" : [MTBusiness class]};
}

- (NSDictionary *)objectClassInArray
{
    return @{@"businesses" : [MTBusiness class]};
}

+ (NSDictionary *)gp_dictionaryKeysMatchToPropertyNames{
    return @{@"description" : @"desc",
             @"restrictions.is_refundable" : @"is_refundable"
             };
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    // 模型的desc属性对应着字典中的description
    return @{@"desc" : @"description",
             @"is_refundable" : @"restrictions.is_refundable"
             };
}

- (BOOL)isEqual:(id)object{
    if ( object == self ) {
        return YES;
    }
    if ( [object isKindOfClass:[self class]] ) {
        typeof(self) temp = object;
        return [temp.deal_id isEqualToString:self.deal_id];
    }
    return NO;
}


- (NSString *)description{
    NSMutableString *string = [NSMutableString string];
    [string appendFormat:@"<%@ %p> {\n",NSStringFromClass([self class]),self];
    [self gp_emurateIvarsUsingBlock:^(Ivar ivar, NSString *ivarName, id value) {
        [string appendFormat:@"\t%@ = %@\n",ivarName,value];
    }];
    [string appendString:@"}"];
    return string;
}
@end
