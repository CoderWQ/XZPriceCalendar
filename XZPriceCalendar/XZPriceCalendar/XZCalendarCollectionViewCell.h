//
//  XZCalendarCollectionViewCell.h
//  XZPriceCalendar
//
//  Created by coderXu on 16/12/19.
//  Copyright © 2016年 coderXu. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,XZCalendarItemType){
    XZCalendarItemTypeRectAlone, // 矩形无连接色
    XZCalendarItemTypeRectCollected, // 矩形有连接色
    XZCalendarItemTypeRoundAlone,   // 圆形无连接色
    XZCalendarItemTypeRoundCollected // 圆形有连接色
};
@interface XZCalendarCollectionViewCell : UICollectionViewCell

// cell的选中类型
@property (nonatomic,assign) XZCalendarItemType *itemType;
// UI控件
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rebateLabel;




// 传入今天是几号
@property(assign,nonatomic)int nowDay;
@property(strong,nonatomic)NSDictionary *dataSource;
// 传入用户身份
@property (nonatomic, copy) NSString  *userType;

 





@end
