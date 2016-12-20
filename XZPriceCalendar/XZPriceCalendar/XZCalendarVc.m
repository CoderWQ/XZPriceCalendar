//
//  XZCalendarVc.m
//  XZPriceCalendar
//
//  Created by coderXu on 16/12/19.
//  Copyright © 2016年 coderXu. All rights reserved.
//

#import "XZCalendarVc.h"
#import "XZCalendarConst.h"
#import "XZCalendarCollectionViewCell.h"
#import "XZCalendarCollectionReusableView.h"
@interface XZCalendarVc ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView * collectionView;


//当前的时间
@property (nonatomic, strong) NSDate * nowDate;
//当前日历
@property (nonatomic, strong) NSCalendar * calendar;
//当前components
@property (nonatomic, strong) NSDateComponents * components;
//时间格式
@property (nonatomic, strong) NSDateFormatter * formatter;
//日历星期的格式
@property (nonatomic, strong) NSArray * weekdays;
// 时区
@property (nonatomic, strong) NSTimeZone * timeZone;

@property (nonatomic, strong) NSDictionary * dataSource;



@property (nonatomic, copy) NSString  *type;

@end

static NSString * const XZPriceCalendarVcHeaderViewID = @"XZPriceCalendarVcHeaderViewID";
static NSString * const XZPriceCalendarVcCellID = @"XZPriceCalendarVcCellID";


@implementation XZCalendarVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的日历，感谢！";
    
    // 1.获取服务器数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"plist1.plist" ofType:nil];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    self.dataSource = [NSDictionary dictionary];
    self.dataSource = dict;
    // 1.1标记身份状态
    self.type = @"推广员";
//    self.type = @"游客";
    
    
    
    // 2.初始化
    // 获取当前时间
    self.nowDate = [NSDate date];
    
    
    //设置布局
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    if ([self.type isEqualToString:@"推广员"]) {
        flowLayout.itemSize = CGSizeMake(XZScreenWidth / 7.0, 45);//item大小
    }else{
        flowLayout.itemSize = CGSizeMake(XZScreenWidth / 7.0, 64);//item大小
     }
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//滚动方向
    flowLayout.headerReferenceSize = CGSizeMake(XZScreenWidth, 85);//header大小
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);//边界距离
    
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, XZScreenWidth, XZScreenHeight) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    
    //注册
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XZCalendarCollectionReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:XZPriceCalendarVcHeaderViewID];
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XZCalendarCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:XZPriceCalendarVcCellID];
    [self.view addSubview:self.collectionView];
    
    
    
    
    
    
    
    
}

//#pragma mark -代理

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // 个数就为当月总天数  +  第一天星期几的数量
    NSDate *dateTime = [self  getEarlierAndLaterDaysFromDate:self.nowDate withMonth:section];
    
    NSString *firstDayMonth = [self getBeginTimeInMonth:dateTime];
    
    NSInteger startDay = [firstDayMonth integerValue];
    
    NSInteger totalDays = [self getTotalDaysInMonth:dateTime];
    
    return startDay + totalDays;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    XZCalendarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:XZPriceCalendarVcCellID forIndexPath:indexPath];
    
    
    
    // 1.获取该cell所在月份的第一天是星期几,然后赋值
    NSDate * dateTime = [self getEarlierAndLaterDaysFromDate:self.nowDate withMonth:indexPath.section];
    // 当天是多少号
    NSInteger nowDay =  [[self getCurrentComponentWithDate:self.nowDate] day];
    cell.nowDay = nowDay;
    // 当天所在月的第一天是星期几
    NSInteger startDayMonth = [[self getBeginTimeInMonth:dateTime] integerValue];
    /* 计算每个cell的日子  当前天数 = 第几行 - 这个月第一天是星期几 + 1 */
    NSInteger dayIndex = indexPath.row - startDayMonth + 1;
    NSString *dayString = dayIndex > 0? [NSString stringWithFormat:@"%d",dayIndex]:@"0";
    
    // 2.取得当前服务器数据，搞起来。
    NSArray *netWrokingArray = self.dataSource[@"data"];
    NSDictionary *dict = netWrokingArray[indexPath.section];
    // 获取时间比较--按照同月份，格式为2016-01-01
    NSString *dateString = [NSString stringWithFormat:@"%@",dict[@"date"]];
    NSString *dayCell =  [self getFormatTime:dateTime];
    // section为月，拿到天数的数组
    NSArray *dayArray = dict[@"data"];
    
    
    // 3.给cell赋值
    
    // 3.1 赋值天数
    cell.dayLabel.text = dayString;
    
    
    // 3.2赋值状态价格模型
    // 注意：日历中，第一个月赋值要大于当天
    if (indexPath.section  == 0) {
        
        if ([cell.dayLabel.text integerValue] > nowDay  && [dateString isEqualToString:dayCell]) {
            
            cell.dataSource = dayArray[indexPath.row - nowDay];
            
            
        }else{
            cell.dataSource = nil;
            
        }
        
    }else{
        // 日历中，其他月赋值要从1号开始
        
        if (dayIndex > 0  && [dateString isEqualToString:dayCell]) {
            
            cell.dataSource = dayArray[indexPath.row - startDayMonth];
            
        }else{
            
            cell.dataSource = nil;
            
        }
     }
    
    // 3.3 最后传入身份
    cell.userType = @"推广员";
    
    return cell;
}

// header代理方法
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        XZCalendarCollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:XZPriceCalendarVcHeaderViewID forIndexPath:indexPath];
        
        //设置headerView的title
        [headerView showMonthDayLabelWithDate:[self getEarlierAndLaterDaysFromDate:self.nowDate withMonth:indexPath.section]];
        
        
        return headerView;
        
    }
    
    return nil;
}

#pragma mark- 获取时间
/**根据当前时间获取该日子的月份以及该日子以后的月份---count数量由section的个数决定 - 0代表当前*/
- (NSDate *)getEarlierAndLaterDaysFromDate:(NSDate*)date withMonth:(NSInteger)nowMonth{
    
    NSDate * newDate = [NSDate date];
    
    NSDateComponents * components = [self getCurrentComponentWithDate:newDate];
    
    
    //获取section表示的每个月份
    NSInteger year = [components year];
    NSInteger month = [components month];
    
    //获取当前section代表的月份和现在月份的差值
    // 获取当年
    //    NSInteger months = nowMonth  - month + 1;
    
    
    // 把当前时间加到另外一个时间内，来获取前后每个月的今天
    [self.components setMonth:nowMonth];
    
    //返回（当年）各月份的当前日期，如：2016-01-14，2016-02-14，测试31号会自动转换成30
    NSDate * ndate = [self.calendar dateByAddingComponents:self.components toDate:date options:0];
    
    return ndate;
    
}



/**
 获得该日子所在月份的第一天  --->是星期几
 @return 返回星期几
 */
- (NSString *)getBeginTimeInMonth:(NSDate *)date{
    
    NSTimeInterval count = 0;
    NSDate * beginDate = nil;
    NSCalendar *calendar  = [NSCalendar currentCalendar];
    
    // 查看日历中，当月第一天是多少
    BOOL findFirstDay = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&count forDate:date];
    
    if (findFirstDay) {
        
        
        [self.calendar setTimeZone:self.timeZone];
        
        // 返回第一天是星期几
        NSDateComponents *weekday = [self.calendar components:NSCalendarUnitWeekday fromDate:beginDate];
        
        NSString *weekdayString = [self.weekdays objectAtIndex:[weekday weekday]];
        
        return weekdayString;
    }else{
        return @"";
    }
    
}

/**获取每个月多少天*/
- (NSInteger)getTotalDaysInMonth:(NSDate *)date {
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    //标识为day的单位在标识为month的单位中的格式，返回range
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    
    return range.length;
}

/**构造NSDateComponents*/
- (NSDateComponents *)getCurrentComponentWithDate:(NSDate *)dateTime {
    NSCalendar * calendar = [NSCalendar currentCalendar];
    //日期拆分类型
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unitFlags fromDate:dateTime];
}
// 获取格式化之后的日期 用----分割
- (NSString *)getFormatTime:(NSDate *)date{
    
    
    NSDateFormatter *dataFormater = [[NSDateFormatter alloc] init];
    dataFormater.dateFormat = @"yyyy-MM";
    NSString *timeFormat = [dataFormater stringFromDate:date];
    
    return timeFormat;
    
}


#pragma mark -懒加载

- (NSCalendar *)calendar{
    if (_calendar == nil) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return _calendar;
}
- (NSDateComponents *)components {
    if (_components == nil) {
        _components = [[NSDateComponents alloc] init];
    }
    return _components;
}
- (NSDateFormatter *)formatter {
    if (_formatter == nil) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = @"yyyy-MM-dd";
    }
    return _formatter;
}

- (NSArray *)weekdays
{
    //在这里需要注意的是：星期日是数字1，星期一时数字2，以此类推。
    if (_weekdays == nil) {
        _weekdays = @[[NSNull null], @"0", @"1", @"2", @"3", @"4", @"5", @"6"];
    }
    return _weekdays;
}
- (NSTimeZone *)timeZone {
    //时区为中国上海
    if (_timeZone == nil) {
        //        _timeZone = [NSTimeZone defaultTimeZone];
        
        _timeZone = [[NSTimeZone alloc] initWithName:@"Asia/BeiJing"];
    }
    return _timeZone;
}

@end
