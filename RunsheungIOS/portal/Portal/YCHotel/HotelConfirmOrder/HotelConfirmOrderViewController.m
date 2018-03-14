//
//  HotelConfirmOrderViewController.m
//  Portal
//
//  Created by ifox on 2017/4/11.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelConfirmOrderViewController.h"
#import "HotelConfirmOrderTableView.h"
#import "UILabel+CreateLabel.h"
#import "UIButton+CreateButton.h"
#import "HotelConfirmOrderDetailView.h"
#import "HotelReserveResultController.h"
#import "HotelPaymentController.h"
#import "HotelRetainTimeModel.h"

@interface HotelConfirmOrderViewController ()

@property(nonatomic, strong) HotelConfirmOrderTableView *tableView;
@property(nonatomic, strong) HotelConfirmOrderDetailView *orderDetailView;
@property(nonatomic, strong) UIView *maskView;
@property(nonatomic, strong) UILabel *totalPrice;

@property(nonatomic, copy) NSString *point;
@property(nonatomic, copy) NSString *actuaMoney;
@property(nonatomic, copy) NSString *orderMoney;

@property(nonatomic, copy) NSString *arriveDate;
@property(nonatomic, copy) NSString *leaveDate;
@property(nonatomic, copy) NSString *days;

@end

@implementation HotelConfirmOrderViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _maskView.hidden = YES;
    [_maskView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"HotelOrderNewOrderTitle", nil);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reCountPrice:) name:HotelChooseRoomNumbersNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(swithChange:) name:HotelUsePointSwitchChangeNotification object:nil];

    _tableView = [[HotelConfirmOrderTableView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, self.view.frame.size.height - 50) style:UITableViewStyleGrouped];
    _tableView.hotelName = self.hotelName;
    _tableView.roomTypeName = self.roomModel.roomTypeName;
    _tableView.arrivedate = self.arriveDate;
    _tableView.days = self.days;
    _tableView.leavedate = self.leaveDate;
    [self.view addSubview:_tableView];
    
    [self createView];
    
    [self requestRetainTime];
}

- (void)requestRetainTime {
    [YCHotelHttpTool hotelGetRetainTimeListWithArriveTime:_dateArray.firstObject success:^(id response) {
        NSLog(@"%@",response);
        
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSMutableArray *retainArr = @[].mutableCopy;
            NSArray *data = response[@"data"];
            for (NSDictionary *dic in data) {
                HotelRetainTimeModel *model = [NSDictionary getHotelRetainTimeModelWithDic:dic];
                [retainArr addObject:model];
            }
            _tableView.retainTimeArray = retainArr.copy;
        }
    } failure:^(NSError *err) {
        
    }];
}

- (void)setDateArray:(NSArray *)dateArray{
    _dateArray = dateArray;
    _arriveDate = dateArray[0];
    _leaveDate = dateArray[1];
    _days = dateArray[2];
}

- (void)createView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, APPScreenWidth, 50)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UILabel *price = [UILabel createLabelWithFrame:CGRectMake(10, 0, 200, bottomView.frame.size.height) textColor:[UIColor redColor] font:[UIFont systemFontOfSize:17] textAlignment:NSTextAlignmentLeft text:@"￥0"];
    self.totalPrice = price;
    [bottomView addSubview:price];
    
    UIButton *confirmOrder = [UIButton createButtonWithFrame:CGRectMake(APPScreenWidth/3*2, 0, APPScreenWidth/3, bottomView.frame.size.height) title:NSLocalizedString(@"SMConfirmOrderSubmitButtonTitle", nil) titleColor:[UIColor whiteColor] titleFont:[UIFont systemFontOfSize:17] backgroundColor:PurpleColor];
    [confirmOrder addTarget:self action:@selector(confirmOrder) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:confirmOrder];
    
    UIButton *detail = [UIButton createButtonWithFrame:CGRectMake(CGRectGetMinX(confirmOrder.frame) - 80, 0, 80, bottomView.frame.size.height) title:NSLocalizedString(@"HotelOrderNewOrderDetailUp", nil) titleColor:HotelLightGrayColor titleFont:[UIFont systemFontOfSize:12] backgroundColor:[UIColor whiteColor]];
    [detail setTitle:NSLocalizedString(@"HotelOrderNewOrderDetailDown", nil) forState:UIControlStateSelected];
    [detail addTarget:self action:@selector(detailButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:detail];
    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, APPScreenHeight - 50 - APPScreenHeight/3)];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    _maskView.hidden = YES;
    [KEYWINDOW addSubview:_maskView];
    
    _orderDetailView = [[HotelConfirmOrderDetailView alloc] initWithFrame:CGRectMake(0, APPScreenHeight, APPScreenWidth, APPScreenHeight/3)];
    [self.view insertSubview:_orderDetailView belowSubview:bottomView];
}

- (void)reCountPrice:(NSNotification *)notification {
    NSNumber *roomCout = notification.object;
    [self countPriceWithRoomNumbers:roomCout.integerValue];
}

- (void)swithChange:(NSNotification *)notification {
    NSNumber *isOn = notification.object;
    BOOL usePoint = isOn.boolValue;
    if (usePoint) {
        self.totalPrice.text = [NSString stringWithFormat:@"￥%@",self.actuaMoney];
        _orderDetailView.point = self.point;
        _orderDetailView.realMoney = self.actuaMoney;
        _orderDetailView.orderMoney = self.orderMoney;
    } else {
        self.totalPrice.text = [NSString stringWithFormat:@"￥%@",self.orderMoney];
        _orderDetailView.point = @"0";
        _orderDetailView.realMoney = self.orderMoney;
        _orderDetailView.orderMoney = self.orderMoney;
    }
}

- (void)countPriceWithRoomNumbers:(NSInteger)roomNumbers {
    
    BOOL usePoint = _tableView.usePoint;
    NSString *isPoint;
    if (usePoint) {
        isPoint = @"1";
    } else {
        isPoint = @"0";
    }

    [YCHotelHttpTool hotelGetActuallyPayWithHotelID:self.hotelID roomPrice:self.roomModel.MemeberPrice arriveTime:self.arriveDate leaveTime:self.leaveDate roomCount:@(roomNumbers) usePoint:@"1" roomTypeID:self.roomModel.roomTypeID success:^(id response) {
        NSLog(@"%@",response);
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSDictionary *data = response[@"data"];
            NSString *orderPoint = data[@"order_point"];
            NSString *realMoney = data[@"real_amount"];
            NSString *orderMoney = data[@"order_amount"];
            
            self.point = orderPoint;
            self.actuaMoney = realMoney;
            self.orderMoney = orderMoney;
            _orderDetailView.point = self.point;
            _orderDetailView.realMoney = self.actuaMoney;
            _orderDetailView.orderMoney = self.orderMoney;
//            self.totalPrice.text = [NSString stringWithFormat:@"￥%@",self.actuaMoney];
            if (usePoint) {
                self.totalPrice.text = [NSString stringWithFormat:@"￥%@",self.actuaMoney];
                _orderDetailView.point = self.point;
                _orderDetailView.realMoney = self.actuaMoney;
                _orderDetailView.orderMoney = self.orderMoney;
            } else {
                self.totalPrice.text = [NSString stringWithFormat:@"￥%@",self.orderMoney];
                _orderDetailView.point = @"0";
                _orderDetailView.realMoney = self.orderMoney;
                _orderDetailView.orderMoney = self.orderMoney;
            }
        }
    } failure:^(NSError *err) {
        
    }];

}

- (void)confirmOrder {

    if (self.point.length == 0) {
        return;
    }
    if (_tableView.roomNumbers == 0) {
        [MBProgressHUD hideAfterDelayWithView:self.view interval:2 text:NSLocalizedString(@"HotelOrderNewMsg_0", nil)];
        return;
    }
    if (_tableView.arriveTime.length == 0) {
        [MBProgressHUD hideAfterDelayWithView:self.view interval:2 text:NSLocalizedString(@"HotelOrderNewMsg_1", nil)];
        return;
    }
    [self createHotelOrderWithPoint:self.point payment:self.actuaMoney orderMoney:self.orderMoney];
}

- (void)createHotelOrderWithPoint:(NSString *)point
                          payment:(NSString *)payment
                       orderMoney:(NSString *)orderMoney {
    NSArray *names = _tableView.customerNames;
    NSArray *phones = _tableView.customerPhones;
    
    NSNumber *usePoint = @(point.floatValue);
    NSNumber *actuallyPay = @(payment.floatValue);
    
    if (names.count<_tableView.roomNumbers || phones.count < _tableView.roomNumbers) {
        [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:NSLocalizedString(@"HotelOrderNewMsg_2", nil)];
        return;
    }
    
    BOOL isPoint = _tableView.usePoint;
    if (!isPoint) {
        usePoint = @(0);
        actuallyPay = @(orderMoney.floatValue);
    }
    
    [YCHotelHttpTool hotelCreateOrderWithHotelID:self.hotelID userName:names phoneNumbers:phones arriveTime:self.arriveDate leaveTime:self.leaveDate orderMoney:self.orderMoney payment:actuallyPay point:usePoint retainTime:_tableView.retainTimeKey roomTypeID:self.roomModel.roomTypeID roomCount:_tableView.roomNumbers remark:@"" success:^(id response) {
        NSLog(@"%@",response);
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSDictionary *data = response[@"data"];
            NSString *orderNum = data[@"order_no"];//订单号
            NSString *orderAmount = data[@"order_amount"];//订单价格
            NSString *realAmount = data[@"real_amount"];//实际付款
            NSString *point = data[@"order_Point"];
            NSString *currentTime = data[@"currentTime"];
            NSString *overTime = data[@"overTime"];
            
            HotelPaymentController *vc = [[HotelPaymentController alloc] init];
            vc.isCreate = YES;
            vc.paymentMoney = realAmount;
            vc.orderNum = orderNum;
            vc.orderMoney = orderAmount;
            vc.point = point;
            vc.roomModel = self.roomModel;
            vc.hotelName = self.hotelName;
            vc.serverTime = currentTime;
            vc.overTime = overTime;
            vc.startDate = self.arriveDate;
            vc.endDate = self.leaveDate;
            vc.liveDays = self.days;
            vc.hotelName = self.hotelName;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(NSError *err) {
        
    }];
}

- (void)detailButtonSelected:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected == YES) {
        [UIView animateWithDuration:0.3 animations:^{
            _orderDetailView.frame = CGRectMake(0, APPScreenHeight - APPScreenHeight/3 - 50, APPScreenWidth, APPScreenHeight/3);
        }completion:^(BOOL finished) {
            _maskView.hidden = NO;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            _orderDetailView.frame = CGRectMake(0, APPScreenHeight, APPScreenWidth, APPScreenHeight/3);
            _maskView.hidden = YES;
        }completion:^(BOOL finished) {
            
        }];
    }
}

@end
