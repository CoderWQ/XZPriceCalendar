//
//  XZCalendarCollectionViewCell.m
//  XZPriceCalendar
//
//  Created by coderXu on 16/12/19.
//  Copyright © 2016年 coderXu. All rights reserved.
//

#import "XZCalendarCollectionViewCell.h"
#import "UIColor+Hex.h"
@interface XZCalendarCollectionViewCell ()
// UI约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rebateLabelHeight;
@end
@implementation XZCalendarCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //    self.contentView.backgroundColor = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1];
    
    
}

- (void)setDataSource:(NSDictionary *)dataSource
{
    _dataSource = dataSource;
    
    // 0.设置天数小于0 的消失
    if ([self.dayLabel.text intValue] > 0) {
        self.hidden = NO;
    }else{
        self.hidden = YES;
    }
    
    
    
    // 1.设置字体-北京颜色
    self.dayLabel.font = [UIFont systemFontOfSize:14];
    self.priceLabel.font = [UIFont systemFontOfSize:12];
    self.rebateLabel.font = [UIFont systemFontOfSize:10];
    self.contentView.backgroundColor = [UIColor whiteColor];

    // 2.设置默认情况下的字体颜色
    // 根据有没有传值进来，判断
    // 北京均为白色
    //传入为空，则为灰色字体，白色底
    //传入不为空，则黑色，稍微黑色，还有黄色
    

    
    
//    {
//        backMoney = 99;
//        day = 5;
//        sellMoney = 1000;
//        sellStatue = 5;
//    }
    self.priceLabelHeight.constant = 18;
    self.rebateLabelHeight.constant = 19;
    self.userType = @"推广员";
    if (dataSource != nil) {
        
       
        
        
         
        // 1.设置颜色
        self.dayLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.priceLabel.textColor = [UIColor colorWithHexString:@"666666"];
        self.rebateLabel.textColor = [UIColor colorWithHexString:@"ee7700"];
        
        // 2.赋值
//        根据状态来
        NSString *status = [NSString stringWithFormat:@"%@",dataSource[@"sellStatue"]];
        if ([status intValue] == 1) {
            self.priceLabel.text = [NSString stringWithFormat:@"￥%@",dataSource[@"sellMoney"]];
        }else if ([status intValue] == 2) {
            self.priceLabel.text = [NSString stringWithFormat:@"￥%@",dataSource[@"sellMoney"]];
        }else if ([status intValue] == 3 ||[status intValue] == 4 ||[status intValue] == 5 ||[status intValue] == 0 ) {
            self.priceLabel.text = [NSString stringWithFormat:@"售罄"];
        }
        
        
        
    }else{
        
        self.priceLabel.text = @"";
        
        self.dayLabel.textColor = [UIColor colorWithHexString:@"bbbbbb"];
        self.priceLabel.textColor = [UIColor colorWithHexString:@"bbbbbb"];
        self.rebateLabel.textColor = [UIColor colorWithHexString:@"bbbbbb"];

        
        
    }
    
    
    // 最后判断身份
    if ([self.userType isEqualToString:@"推广员"]) {
        self.rebateLabel.text  = @"";
        self.rebateLabelHeight.constant = 0;
    }else{
        self.rebateLabelHeight.constant = 19;

        self.rebateLabel.text = @"222222";
    }
//
    
    
    
    
    
}




@end
