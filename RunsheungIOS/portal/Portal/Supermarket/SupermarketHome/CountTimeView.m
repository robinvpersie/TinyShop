//
//  CountTimeView.m
//  Portal
//
//  Created by 左梓豪 on 2016/12/7.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "CountTimeView.h"

#define itemWidth (self.frame.size.width-40)/3

@implementation CountTimeView
{
    dispatch_source_t _timer;
    UILabel *_day;
    UILabel *_hour;
    UILabel *_minute;
    UILabel *_second;
    
    UILabel *_space;
    UILabel *_dot1;
    UILabel *_dot2;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self initView];
        
        [self config];
    }
    return self;
}

- (void)initView {
    
    if (_day == nil) {
        _day = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, self.frame.size.height)];
    }
    [self addSubview:_day];
    
    if (_space == nil) {
        _space = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_day.frame), 0, 20, self.frame.size.height)];
    }
    [self addSubview:_space];
    
    if (_hour == nil) {
        _hour = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_space.frame), 0, itemWidth, self.frame.size.height)];
        _hour.layer.cornerRadius = 5.0f;
        _hour.textColor = [UIColor whiteColor];
        _hour.backgroundColor = [UIColor blackColor];
    }
    [self addSubview:_hour];
    
    if (_dot1 == nil) {
        _dot1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_hour.frame), 0, 20, self.frame.size.height)];
        _dot1.text = @":";
        _dot1.textAlignment = NSTextAlignmentCenter;
    }
    [self addSubview:_dot1];
    
    if (_minute == nil) {
        _minute = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_dot1.frame), 0, itemWidth, self.frame.size.height)];
        _minute.layer.cornerRadius = 5.0f;
        _minute.backgroundColor = [UIColor blackColor];
        _minute.textColor = [UIColor whiteColor];
    }
    [self addSubview:_minute];
    
    if (_dot2 == nil) {
        _dot2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_minute.frame), 0, 20, self.frame.size.height)];
        _dot2.text = @":";
        _dot2.textAlignment = NSTextAlignmentCenter;
    }
    [self addSubview:_dot2];
    
    if (_second == nil) {
        _second = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_dot2.frame), 0, itemWidth, self.frame.size.height)];
        _second.layer.cornerRadius = 5.0f;
        _second.backgroundColor = [UIColor blackColor];
        _second.textColor = [UIColor whiteColor];
    }
    [self addSubview:_second];
}

- (void)config {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *endDate = [dateFormatter dateFromString:[self getyyyymmdd]];
    NSDate *endDate_tomorrow = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([endDate timeIntervalSinceReferenceDate] + 24*3600)];
    NSDate *startDate = [NSDate date];
    NSTimeInterval timeInterval =[endDate_tomorrow timeIntervalSinceDate:startDate];
    
    if (_timer==nil) {
        __block int timeout = timeInterval; //倒计时时间
        
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    _timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _day.text = @"";
                        _hour.text = @"00";
                        _minute.text = @"00";
                        _second.text = @"00";
                    });
                }else{
                    int days = (int)(timeout/(3600*24));
                    if (days==0) {
                        _day.text = @"";
                    }
                    int hours = (int)((timeout-days*24*3600)/3600);
                    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    int second = timeout-days*24*3600-hours*3600-minute*60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (days==0) {
                            _day.text = @"0天";
                        }else{
                            _day.text = [NSString stringWithFormat:@"%d天",days];
                        }
                        if (hours<10) {
                            _hour.text = [NSString stringWithFormat:@"0%d",hours];
                        }else{
                            _hour.text = [NSString stringWithFormat:@"%d",hours];
                        }
                        if (minute<10) {
                            _minute.text = [NSString stringWithFormat:@"0%d",minute];
                        }else{
                            _minute.text = [NSString stringWithFormat:@"%d",minute];
                        }
                        if (second<10) {
                            _second.text = [NSString stringWithFormat:@"0%d",second];
                        }else{
                            _second.text = [NSString stringWithFormat:@"%d",second];
                        }
                        
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
    }

}

/**
 *  获取当天的年月日的字符串
 *  这里测试用
 *  @return 格式为年-月-日
 */
-(NSString *)getyyyymmdd{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyy-MM-dd";
    NSString *dayStr = [formatDay stringFromDate:now];
    
    return dayStr;
    
}

@end
