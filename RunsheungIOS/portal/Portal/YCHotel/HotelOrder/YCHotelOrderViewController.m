//
//  YCHotelOrderViewController.m
//  Portal
//
//  Created by ifox on 2017/3/29.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "YCHotelOrderViewController.h"
#import "NinaPagerView.h"
#import "HotelAllOrderController.h"
#import "HotelActiveOrderController.h"
#import "HotelWaitPayOrderController.h"
#import "HotelRefundOrderController.h"
#import "HotelFinishedOrderController.h"
#import "HotelReserveResultDetailController.h"
#import "HotelOrderListModel.h"
#import "HotelReserveResultController.h"

@interface YCHotelOrderViewController ()

@end

@implementation YCHotelOrderViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.automaticallyAdjustsScrollViewInsets == YES) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if (self.navigationController.navigationBar.translucent == NO) {
        self.navigationController.navigationBar.translucent = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BGColor;
    self.title = @"我的订单";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goOrderDetail:) name:HotelClickOrderNotification object:nil];
    
    HotelAllOrderController *all = [[HotelAllOrderController alloc] init];
    HotelActiveOrderController *active = [[HotelActiveOrderController alloc] init];
    HotelWaitPayOrderController *waitPay = [[HotelWaitPayOrderController alloc] init];
    HotelFinishedOrderController *finish = [[HotelFinishedOrderController alloc] init];
    HotelRefundOrderController *refund = [[HotelRefundOrderController alloc] init];
    
    NSArray *colorArray = @[
                            PurpleColor, /**< 选中的标题颜色 Title SelectColor  **/
                            [UIColor darkGrayColor], /**< 未选中的标题颜色  Title UnselectColor **/
                            PurpleColor, /**< 下划线颜色或滑块颜色 Underline or SlideBlock Color   **/
                            [UIColor whiteColor], /**<  上方菜单栏的背景颜色 TopTab Background Color   **/
                            ];
    NinaPagerView *pageView = [[NinaPagerView alloc] initWithTitles:@[NSLocalizedString(@"HotelOrder_0", nil),NSLocalizedString(@"HotelOrder_1", nil),NSLocalizedString(@"HotelOrder_2", nil),NSLocalizedString(@"HotelOrder_3", nil),NSLocalizedString(@"HotelOrder_4", nil)] WithVCs:@[all,active,waitPay,finish,refund] WithColorArrays:colorArray];
    pageView.pushEnabled = YES;
    [self.view addSubview:pageView];

    // Do any additional setup after loading the view.
}

- (void)goOrderDetail:(NSNotification *)notifacation {
    HotelOrderListModel *orderModel = notifacation.object;
    if (orderModel.orderStatus == HotelOrderStatusPayFinish) {
        HotelReserveResultController *vc = [[HotelReserveResultController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.orderID = orderModel.orderID;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        HotelReserveResultDetailController *vc = [[HotelReserveResultDetailController alloc] init];
        vc.orderNum = orderModel.orderID;
        vc.orderListModel = orderModel;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
