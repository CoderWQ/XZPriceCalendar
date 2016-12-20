//
//  XZCalendarCollectionReusableView.m
//  XZPriceCalendar
//
//  Created by coderXu on 16/12/19.
//  Copyright © 2016年 coderXu. All rights reserved.
//

#import "XZCalendarCollectionReusableView.h"

@interface XZCalendarCollectionReusableView()
@property (weak, nonatomic) IBOutlet UILabel *MonthDayLabel;

@end

@implementation XZCalendarCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)showMonthDayLabelWithDate:(NSDate *)date{
    
    NSCalendar * calendar = [NSCalendar currentCalendar];
    //日期拆分类型
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay;

    NSDateComponents *components =  [calendar components:unitFlags fromDate:date];
    
     self.MonthDayLabel.text = [NSString stringWithFormat:@"%@年%@月",[NSNumber numberWithInteger:[components year]],[NSNumber numberWithInteger:[components month]]];
}




@end
