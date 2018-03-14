//
//  HotelCalendarView.m
//  Portal
//
//  Created by ifox on 2017/3/31.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelCalendarView.h"
#import "UILabel+CreateLabel.h"
#import "MSSCalendarViewController.h"
#import "MSSCalendarDefine.h"

@interface HotelCalendarView ()<MSSCalendarViewControllerDelegate>

@property(nonatomic, strong) UIView *contentView;
@property (nonatomic,assign)NSInteger startDate;
@property (nonatomic,assign)NSInteger endDate;

@end

@implementation HotelCalendarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    
    UITapGestureRecognizer *tapBackGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
    [self addGestureRecognizer:tapBackGesture];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, APPScreenHeight*0.7)];
    contentView.backgroundColor = [UIColor whiteColor];
    self.contentView = contentView;
    [self addSubview:contentView];
    
    UILabel *title = [UILabel createLabelWithFrame:CGRectMake(0, 0, 200, 40) textColor:[UIColor darkcolor] font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentCenter text:NSLocalizedString(@"HotelChooseDate", nil)];
    title.center = CGPointMake(contentView.center.x, 20);
    [contentView addSubview:title];
    
    MSSCalendarViewController *cvc = [[MSSCalendarViewController alloc]init];
    cvc.limitMonth = 12 * 15;// 显示几个月的日历
    /*
     MSSCalendarViewControllerLastType 只显示当前月之前
     MSSCalendarViewControllerMiddleType 前后各显示一半
     MSSCalendarViewControllerNextType 只显示当前月之后
     */
    cvc.type = MSSCalendarViewControllerMiddleType;
    cvc.beforeTodayCanTouch = NO;// 今天之后的日期是否可以点击
    cvc.afterTodayCanTouch = YES;// 今天之前的日期是否可以点击
    cvc.startDate = _startDate;// 选中开始时间
    cvc.endDate = _endDate;// 选中结束时间
    /*以下两个属性设为YES,计算中国农历非常耗性能（在5s加载15年以内的数据没有影响）*/
    cvc.showChineseHoliday = YES;// 是否展示农历节日
    cvc.showChineseCalendar = YES;// 是否展示农历
    cvc.showHolidayDifferentColor = YES;// 节假日是否显示不同的颜色
    cvc.showAlertView = YES;// 是否显示提示弹窗
    cvc.delegate = self;
    
    [self.contentView addSubview:cvc.view];

}

- (void)calendarViewConfirmClickWithStartDate:(NSInteger)startDate endDate:(NSInteger)endDate
{
    _startDate = startDate;
    _endDate = endDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSString *startDateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_startDate]];
    NSString *endDateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_endDate]];
    NSString *start = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"HotelStartDate", nil),startDateString];
    NSString *end = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"HotelEndDate", nil),endDateString];
    [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:3 text:[NSString stringWithFormat:@"%@\n%@",start,end]];
}


- (void)showInView:(UIView *)view {
    [view addSubview:self];
    __weak typeof(self) _weakSelf = self;
    self.contentView.frame = CGRectMake(0, APPScreenHeight, APPScreenWidth, 0.7*APPScreenHeight);
    
    [UIView animateWithDuration:0.3 animations:^{
        _weakSelf.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _weakSelf.contentView.frame = CGRectMake(0, APPScreenHeight - 0.7*APPScreenHeight, APPScreenWidth, 0.7*APPScreenHeight);
    }completion:^(BOOL finished) {
        
    }];

}

- (void)removeView {
    __weak typeof(self) _weakSelf = self;
    [UIView animateWithDuration:0.3f animations:^{
        _weakSelf.backgroundColor = [UIColor clearColor];
        _weakSelf.contentView.frame = CGRectMake(0, APPScreenHeight, APPScreenWidth, 0.7*APPScreenHeight);
    } completion:^(BOOL finished) {
        [_weakSelf removeFromSuperview];
    }];
}

@end
