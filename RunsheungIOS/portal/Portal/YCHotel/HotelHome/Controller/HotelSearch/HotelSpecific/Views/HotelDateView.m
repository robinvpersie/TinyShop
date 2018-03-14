//
//  HotelDateView.m
//  Portal
//
//  Created by 王五 on 2017/4/11.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelDateView.h"

#import "UIView+ViewController.h"

@implementation HotelDateView{
    NSString *dateyear;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)choiceDate:(UIButton *)sender{
    
        MSSCalendarViewController *cvc = [[MSSCalendarViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cvc];
        cvc.title = NSLocalizedString(@"HotelChooseDate", nil);
        cvc.limitMonth = 12 * 15;// 显示几个月的日历
        /*
         MSSCalendarViewControllerLastType 只显示当前月之前
         MSSCalendarViewControllerMiddleType 前后各显示一半
         MSSCalendarViewControllerNextType 只显示当前月之后
         */
        cvc.type = MSSCalendarViewControllerNextType;
        cvc.beforeTodayCanTouch = NO;// 今天之后的日期是否可以点击
        cvc.afterTodayCanTouch = YES;// 今天之前的日期是否可以点击
        cvc.startDate = _startDate;// 选中开始时间
        cvc.endDate = _endDate;// 选中结束时间
        /*以下两个属性设为YES,计算中国农历非常耗性能（在5s加载15年以内的数据没有影响）*/
        cvc.showChineseHoliday = YES;// 是否展示农历节日
        cvc.showChineseCalendar = NO;// 是否展示农历
        cvc.showHolidayDifferentColor = NO;// 节假日是否显示不同的颜色
        cvc.showAlertView = YES;// 是否显示提示弹窗
        cvc.delegate = self;
        [self.viewController presentViewController:nav animated:YES completion:nil];

 
}

- (void)calendarViewConfirmClickWithStartDate:(NSInteger)startDate endDate:(NSInteger)endDate
{
    _startDate = startDate;
    _endDate = endDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSString *startDateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_startDate]];
    NSString *endDateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_endDate]];
    NSString *startString = [NSString stringWithFormat:@"%@-%@", [startDateString componentsSeparatedByString:@"-"][1],[[startDateString componentsSeparatedByString:@"-"] lastObject]];
    NSString *endString = [NSString stringWithFormat:@"%@-%@", [endDateString componentsSeparatedByString:@"-"][1],[[endDateString componentsSeparatedByString:@"-"] lastObject]];
    _startStr = startDateString;
    _endStr = endDateString;
    [_startDateLab setText:startString];
    [_endDateLab setText:endString];
   
     NSInteger totalCount = (endDate - startDate)/(24 * 60 * 60);
     _totalStr = [NSString stringWithFormat:@"%ld",totalCount];
   
    NSString *totalString = [NSString stringWithFormat:@"%@%ld%@",NSLocalizedString(@"HotelTotal", nil),(long)totalCount,NSLocalizedString(@"HotelDay",nil)];
    [_totalButton setTitle:totalString forState:UIControlStateNormal];
  
}


- (void)createSubviews{
    
    [self setBackgroundColor:[UIColor whiteColor]];
    _totalButton =  [[UIButton alloc]initWithFrame:CGRectMake(APPScreenWidth/2.0f - 30, 10, 60, 30)];
    _totalButton.layer.cornerRadius = 5;
    _totalButton.layer.masksToBounds = YES;
    _totalButton.layer.borderColor = PurpleColor.CGColor;
    _totalButton.layer.borderWidth = 0.6f;
    [_totalButton addTarget:self action:@selector(choiceDate:) forControlEvents:UIControlEventTouchUpInside];
    [_totalButton setTitle:@"共1晚" forState:UIControlStateNormal];
    [_totalButton setTitleColor:PurpleColor forState:UIControlStateNormal];
    [_totalButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self addSubview:_totalButton];
    
    UILabel *startTitle =  [[UILabel alloc]initWithFrame:CGRectMake(APPScreenWidth/2.0f -  30 - 90, 10, 70, 15)];
    [startTitle setTextAlignment:NSTextAlignmentCenter];
    [startTitle setTextColor:HotelGrayColor];
    [startTitle setFont:[UIFont systemFontOfSize:11]];
    [startTitle setText:NSLocalizedString(@"HotelIn", nil)];
    [self addSubview:startTitle];
    
    _startDateLab =  [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(startTitle.frame), CGRectGetMaxY(startTitle.frame),70, 20)];
    [_startDateLab setTextAlignment:NSTextAlignmentCenter];
    [_startDateLab setTextColor:HotelGrayColor];
    [_startDateLab setFont:[UIFont systemFontOfSize:12]];
    [_startDateLab setText:[NSString stringWithFormat:@"%@%@",[self getSystemDate],NSLocalizedString(@"HotelTotay", nil)]];
    _startStr = [NSString stringWithFormat:@"%@-%@",dateyear,[self getSystemDate]];
    [self addSubview:_startDateLab];
    
    
    UILabel *endTitle =  [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_totalButton.frame)+ 20, 10, 70, 15)];
    [endTitle setTextAlignment:NSTextAlignmentCenter];
    [endTitle setTextColor:HotelGrayColor];
    [endTitle setFont:[UIFont systemFontOfSize:11]];
    [endTitle setText:NSLocalizedString(@"HotelLeave", nil)];
    [self addSubview:endTitle];
    
    _endDateLab =  [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(endTitle.frame), CGRectGetMaxY(endTitle.frame),70, 20)];
    [_endDateLab setTextAlignment:NSTextAlignmentCenter];
    [_endDateLab setTextColor:HotelGrayColor];
    [_endDateLab setFont:[UIFont systemFontOfSize:12]];
//    NSArray *today = [[self getSystemDate] componentsSeparatedByString:@"-"];
//    NSString *tomorrow = [NSString stringWithFormat:@"%@-%@-%d",dateyear,today.firstObject,[today.lastObject intValue] + 1];
        _totalStr = @"1";
    
    NSTimeInterval timeChuo = (long)[[NSDate date] timeIntervalSince1970] + 24 * 60 * 60;
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:timeChuo];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:detaildate];
    NSArray *arrays = [dateString componentsSeparatedByString:@" "];
    [_endDateLab setText:[NSString stringWithFormat:@"%@%@", arrays.lastObject,NSLocalizedString(@"HotelTomorrow", nil)]];
    _endStr = arrays.lastObject;

    [self addSubview:_endDateLab];

}

//获取系统的时间
- (NSString *)getSystemDate{
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    dateyear = [dateString componentsSeparatedByString:@" "].firstObject;
    NSString *monthDayStr =[dateString componentsSeparatedByString:@" "].lastObject;
    return monthDayStr;
}
@end
