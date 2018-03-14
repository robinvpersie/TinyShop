//
//  HotelChooseView.m
//  Portal
//
//  Created by ifox on 2017/3/29.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelChooseView.h"
#import "UIButton+CreateButton.h"
#import "HotelChoosePriceView.h"
#import "UILabel+CreateLabel.h"
#import "UIButton+CreateButton.h"
#import "MSSCalendarViewController.h"
#import "MSSCalendarDefine.h"
#import "UIView+ViewController.h"
#import "HotelSeachViewController.h"
#import "HotelDetailIntroController.h"

@interface HotelChooseView ()<UITableViewDelegate, UITableViewDataSource,MSSCalendarViewControllerDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *iconNames;
@property(nonatomic, strong) HotelChoosePriceView *choosePriceView;
@property (nonatomic,assign)NSInteger startDate;
@property (nonatomic,assign)NSInteger endDate;

@end

@implementation HotelChooseView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _iconNames = @[@"icon_destination",@"icon_date",@"icon_find",@"icon_price"];
        [self createView];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)createView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self addSubview:_tableView];
    
    _choosePriceView = [[HotelChoosePriceView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, APPScreenHeight)];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 60)];
    footer.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = footer;
    UIButton *search = [UIButton createButtonWithFrame:CGRectMake(APPScreenWidth/6, 10, APPScreenWidth/3*2, 40) title:@"查找酒店" titleColor:[UIColor whiteColor] titleFont:[UIFont systemFontOfSize:17] backgroundColor:PurpleColor];
    search.layer.cornerRadius = 20;
    [search setImage:[UIImage imageNamed:@"icon_searchhotel"] forState:UIControlStateNormal];
    [footer addSubview:search];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HotelCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImage *icon = [UIImage imageNamed:_iconNames[indexPath.row]];
    CGSize itemSize = CGSizeMake(17, 17);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
    CGRect imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
    [icon drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    switch (indexPath.row) {
        case 0:
        {
            UIButton *location = [UIButton createButtonWithFrame:CGRectMake(self.frame.size.width - 120, 0, 120, 50) title:@"我的位置" titleColor:PurpleColor titleFont:[UIFont systemFontOfSize:14] backgroundColor:[UIColor whiteColor]];
            [location setImage:[UIImage imageNamed:@"icon_position"] forState:UIControlStateNormal];
            [cell.contentView addSubview:location];
            
            UILabel *place = [UILabel createLabelWithFrame:CGRectMake(45, 0, self.frame.size.width - 45 - 120, 50) textColor:[UIColor darkcolor] font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft text:@"长沙市雨花区人民东路"];
            [cell.contentView addSubview:place];
        }
            break;
            
        case 1:
            break;
            
        case 2:
            cell.textLabel.text = @"位置/酒店/关键字";
            cell.textLabel.textColor = RGB(215, 215, 215);
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
            
        case 3:
            cell.textLabel.text = @"星级/价格";
            cell.textLabel.textColor = RGB(215, 215, 215);
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            
            break;
        case 1:
        {
            MSSCalendarViewController *cvc = [[MSSCalendarViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cvc];
            cvc.title = @"选择日期";
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

            break;
        case 2:
        {
//            HotelSeachViewController *searchHotel = [[HotelSeachViewController alloc] init];
            HotelDetailIntroController *vc = [HotelDetailIntroController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
             [_choosePriceView showInView:KEYWINDOW];
            break;
        default:
            break;
    }
}

- (void)calendarViewConfirmClickWithStartDate:(NSInteger)startDate endDate:(NSInteger)endDate
{
    _startDate = startDate;
    _endDate = endDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSString *startDateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_startDate]];
    NSString *endDateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_endDate]];
    NSString *start = [NSString stringWithFormat:@"开始日期:%@",startDateString];
    NSString *end = [NSString stringWithFormat:@"结束日期:%@",endDateString];
    [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:3 text:[NSString stringWithFormat:@"%@\n%@",start,end]];
}


@end
