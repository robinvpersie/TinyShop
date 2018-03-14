//
//  SupermarketReceiveTimeController.m
//  Portal
//
//  Created by ifox on 2016/12/15.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketReceiveTimeController.h"
#import "SupermarketChooseTimeCell.h"
#import "SupermarketReceiveTimeModel.h"

@interface SupermarketReceiveTimeController ()<UITableViewDataSource, UITableViewDelegate, SupermarketChooseTimeCellDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, assign) NSIndexPath *selIndex;

@end

@implementation SupermarketReceiveTimeController {
    NSMutableArray *timeArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择时间";
    
    [self initTableView];
    
    [self createData];
    // Do any additional setup after loading the view.
}

- (void)initTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[SupermarketChooseTimeCell class] forCellReuseIdentifier:@"timeCell"];
}

- (void)createData {
    timeArray = @[].mutableCopy;
    
    NSDate *currentDate = [NSDate date];
    
    NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:currentDate];
    NSDate *nextTwoDay = [NSDate dateWithTimeInterval:2*24*60*60 sinceDate:currentDate];
    NSDate *nextThreeDay = [NSDate dateWithTimeInterval:3*24*60*60 sinceDate:currentDate];
    
    SupermarketReceiveTimeModel *nextDayModel = [[SupermarketReceiveTimeModel alloc] init];
    nextDayModel.date = [self getDateWithTime:nextDay];
    nextDayModel.weekDay = [self getWeekDayWithTime:nextDay];
    nextDayModel.dayAfter = @"明天";
    [timeArray addObject:nextDayModel];
    
    SupermarketReceiveTimeModel *nextTwoDayModel = [[SupermarketReceiveTimeModel alloc] init];
    nextTwoDayModel.date = [self getDateWithTime:nextTwoDay];
    nextTwoDayModel.weekDay = [self getWeekDayWithTime:nextTwoDay];
    nextTwoDayModel.dayAfter = @"后天";
    [timeArray addObject:nextTwoDayModel];
    
    SupermarketReceiveTimeModel *nextThreeDayModel = [[SupermarketReceiveTimeModel alloc] init];
    nextThreeDayModel.date = [self getDateWithTime:nextThreeDay];
    nextThreeDayModel.weekDay = [self getWeekDayWithTime:nextThreeDay];
    nextThreeDayModel.dayAfter = @"大后天";
    [timeArray addObject:nextThreeDayModel];
    
    NSLog(@"%@",timeArray);
    
    [self.tableView reloadData];
  
}

- (NSString *)getWeekDayWithTime:(NSDate *)time {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:time];
    
    NSInteger weekDay = [comps weekday];
    
    switch (weekDay) {
        case 1:
            return @"星期日";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 7:
            return @"星期六";
            break;
        default:
            break;
    }
    return nil;
}

- (NSString *)getDateWithTime:(NSDate *)time {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSString *dateString = [dateFormatter stringFromDate:time];
    return dateString;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SupermarketChooseTimeCell *cell = [[SupermarketChooseTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"timeCell"];
    cell.delegate = self;
    if (timeArray.count > 0) {
        cell.timeModel = timeArray[indexPath.section];
    }
    return cell;
}

- (void)clickCheckButton:(UIButton *)checkButton {
    NSLog(@"%ld",checkButton.tag);
    SupermarketChooseTimeCell *cell = (SupermarketChooseTimeCell*)checkButton.superview;
    _selIndex = [_tableView indexPathForCell:cell];
    NSLog(@"%ld",_selIndex.section);
    
    //选择后先把所有的选择清空
    for (SupermarketReceiveTimeModel *model in timeArray) {
        model.selectedPm = NO;
        model.selectedAm = NO;
    }
    
    SupermarketReceiveTimeModel *model = [timeArray objectAtIndex:_selIndex.section];
    if (checkButton.tag == 100) {
        model.selectedAm = YES;
    } else if (checkButton.tag == 200) {
        model.selectedPm = YES;
    }
    
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
