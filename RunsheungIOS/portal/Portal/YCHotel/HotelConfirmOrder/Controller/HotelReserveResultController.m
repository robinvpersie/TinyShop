//
//  HotelReserveResultController.m
//  Portal
//
//  Created by ifox on 2017/4/13.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelReserveResultController.h"
#import "UILabel+CreateLabel.h"
#import "UIButton+CreateButton.h"
#import "HotelReserveResultDetailController.h"
#import "HotelOrderArrangeModel.h"

@interface HotelReserveResultController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UILabel *headerMsg;
@property(nonatomic, strong) UILabel *footerMsg;

@end

@implementation HotelReserveResultController {
    NSArray *_titles;
    NSArray *_msg;
    HotelOrderArrangeModel *_arrangeModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"HotelReserveTitle", nil);
    _titles = @[NSLocalizedString(@"HotelReserveTitle_0", nil),NSLocalizedString(@"HotelReserveTitle_1", nil),NSLocalizedString(@"HotelReserveTitle_2", nil),NSLocalizedString(@"HotelReserveTitle_3", nil),NSLocalizedString(@"HotelReserveTitle_4", nil),NSLocalizedString(@"HotelReserveTitle_5", nil)];
//    _msg = @[@"长沙宇成国际酒店",@"03-20入住,03-21离店,共一晚",@"1间,高级大床房",@"李在翼",@"13000000000",@"18:00之前"];
    [self.view addSubview:self.tableView];
    
    self.view.backgroundColor = BGColor;
    
    [self createView];
    
    [self requestData];
}

- (void)createView {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 85)];
    header.backgroundColor = BGColor;
    UILabel *headerTitle = [UILabel createLabelWithFrame:CGRectMake(0, 20, APPScreenWidth, 30) textColor:HotelBlackColor font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentCenter text:NSLocalizedString(@"HotelWaitConfirm", nil)];
    UILabel *headerMsg = [UILabel createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(headerTitle.frame), APPScreenWidth, 20) textColor:[UIColor orangeColor] font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentCenter text:NSLocalizedString(@"HotelSendMsg", nil)];
    self.headerMsg = headerMsg;
    [header addSubview:headerTitle];
    [header addSubview:headerMsg];
    self.tableView.tableHeaderView = header;
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 280)];
    footer.backgroundColor = BGColor;
    UIButton *goOrderDetail = [UIButton createButtonWithFrame:CGRectMake(12, 20,APPScreenWidth - 24, 35) title:NSLocalizedString(@"HotelCheckOrder", nil) titleColor:[UIColor whiteColor] titleFont:[UIFont systemFontOfSize:15] backgroundColor:PurpleColor];
    goOrderDetail.layer.cornerRadius = 5.0f;
    [goOrderDetail addTarget:self action:@selector(goHotelOrderDetail) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:goOrderDetail];
    
    UILabel *footerMsg = [UILabel createLabelWithFrame:CGRectMake(goOrderDetail.frame.origin.x,CGRectGetMaxY(goOrderDetail.frame)+10 , goOrderDetail.frame.size.width, 40) textColor:HotelLightGrayColor font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft text:@""];
    footerMsg.numberOfLines = 0;
    self.footerMsg = footerMsg;
    [footer addSubview:footerMsg];
    self.tableView.tableFooterView = footer;
}

- (void)requestData {
    [MBProgressHUD showWithView:KEYWINDOW];
    [YCHotelHttpTool hotelGetOrderArrangeInfoWithOrderID:self.orderID success:^(id response) {
        NSLog(@"%@",response);
        [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSDictionary *data = response[@"data"];
            _arrangeModel = [NSDictionary getHotelOrderArrangeModelWithDic:data];
            [self.tableView reloadData];
            self.headerMsg.text = [NSString stringWithFormat:@"%@%@,%@",NSLocalizedString(@"HotelConfirm_00",nil),_arrangeModel.retainTime,NSLocalizedString(@"HotelConfirm_01", nil)];
            self.footerMsg.text = _arrangeModel.reserveInfo;
        }
        
    } failure:^(NSError *err) {
        
    }];
}

- (void)goHotelOrderDetail {
    HotelReserveResultDetailController *orderDetail = [[HotelReserveResultDetailController alloc] init];
    orderDetail.orderNum = self.orderID;
    [self.navigationController pushViewController:orderDetail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.text = _titles[indexPath.row];
    cell.textLabel.textColor = HotelLightGrayColor;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.textColor = HotelBlackColor;
    
    switch (indexPath.row) {
        case 0:
            cell.detailTextLabel.text = _arrangeModel.hotelName;
            break;
        case 1:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@,%@%@",_arrangeModel.arriveTime,NSLocalizedString(@"HotelConfirm_02",nil),_arrangeModel.leaveTime,NSLocalizedString(@"HotelConfirm_03",nil)];
            break;
        case 2:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@,%@",_arrangeModel.roomCount,NSLocalizedString(@"HotelConfirmJian", nil),_arrangeModel.roomTypeName];
            break;
        case 3:
            cell.detailTextLabel.text = _arrangeModel.guestName;
            break;
        case 4:
            cell.detailTextLabel.text = _arrangeModel.guestPhone;
            break;
        case 5:
            cell.detailTextLabel.text = _arrangeModel.retainTime;
            break;
        default:
            break;
    }
    
    return cell;
}


- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}


@end
