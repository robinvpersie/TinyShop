//
//  SupermarketWaitDeliverOrderController.m
//  Portal
//
//  Created by ifox on 2017/7/20.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "SupermarketWaitDeliverOrderController.h"
#import "SupermarketOrderTableView.h"
#import "OrderVirtualData.h"
#import "SupermarketOrderData.h"
#import "MJRefresh.h"

@interface SupermarketWaitDeliverOrderController ()

@property(nonatomic, strong) SupermarketOrderTableView *orderTableView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, assign) NSInteger pageIndex;
@property(nonatomic, assign) NSInteger totalOrder;

@end

@implementation SupermarketWaitDeliverOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _pageIndex = 1;
    _dataArray = @[].mutableCopy;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"YCAccountIsLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveGoodSuc) name:ReceiveGoodsSucNotification object:nil];
    
    [self requestData];
    
 

    // Do any additional setup after loading the view.
}

- (void)receiveGoodSuc {
    [_dataArray removeAllObjects];
    [self requestData];
}

- (void)createView {
    
    [self.view addSubview:self.orderTableView];
    _orderTableView.controllerType = self.controllerType;
    
    if (!_isPageView) {
        _orderTableView.frame = CGRectMake(0, 64, APPScreenWidth, self.view.frame.size.height - 64);
    }
    
    _orderTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_dataArray removeAllObjects];
        _pageIndex = 1;
        [self requestData];
    }];
    
    _orderTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _pageIndex++;
        if (self.dataArray.count < _totalOrder) {
            [self requestData];
        } else {
            [_orderTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }];
}

- (void)requestData {
    [MBProgressHUD showWithView:KEYWINDOW];
    if (self.controllerType == ControllerTypeDepartmentStores) {
        
        [KLHttpTool getOrderListWithStatus:2 pageIndex:_pageIndex appType:8 success:^(id response) {
            NSLog(@"%@",response);
            NSNumber *status = response[@"status"];
            if (status.integerValue == 1) {
                NSArray *data = response[@"data"];
                if (data.count > 0) {
                    for (NSDictionary *dic  in data) {
                        SupermarketOrderData *data = [NSDictionary getOrderDataWithDic:dic];
                        data.severTime = response[@"serverTime"];
                        [_dataArray addObject:data];
                    }
                    self.totalOrder = [response[@"total"] integerValue];
                    [_orderTableView.mj_footer endRefreshing];
                    [_orderTableView.mj_header endRefreshing];
                } else {
                    
                    [self createEmptyView];
                    [_orderTableView.mj_footer endRefreshingWithNoMoreData];
                }
                [self chageView];
            }
        } failure:^(NSError *err) {
            
        }];
        
        
    } else {
        [KLHttpTool getOrderListWithStatus:2 pageIndex:_pageIndex appType:6 success:^(id response) {
            NSLog(@"%@",response);
            NSNumber *status = response[@"status"];
            if (status.integerValue == 1) {
                NSArray *data = response[@"data"];
                if (data.count > 0) {
                    for (NSDictionary *dic  in data) {
                        SupermarketOrderData *data = [NSDictionary getOrderDataWithDic:dic];
                        data.severTime = response[@"serverTime"];
                        [_dataArray addObject:data];
                    }
                    self.totalOrder = [response[@"total"] integerValue];
                    [_orderTableView.mj_footer endRefreshing];
                    [_orderTableView.mj_header endRefreshing];
                } else {
                    [_orderTableView.mj_footer endRefreshingWithNoMoreData];
                }
                [self chageView];
            }
        } failure:^(NSError *err) {
            
        }];
    }
}

- (void)chageView {
    if (_dataArray.count > 0) {
        [self createView];
        _orderTableView.dataArray = _dataArray;
    }
}

- (void)createEmptyView {
    UIImageView *empty = [[UIImageView alloc] init];
    empty.bounds = CGRectMake(0, 0, APPScreenWidth/4, APPScreenWidth/4);
    empty.center = CGPointMake(self.view.center.x, self.view.center.y - 80);
    empty.backgroundColor = [UIColor whiteColor];
    empty.contentMode = UIViewContentModeScaleAspectFit;
    empty.image = [UIImage imageNamed:@"no_order"];
    [self.view addSubview:empty];
    UILabel *msg = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(empty.frame)+15, APPScreenWidth, 20)];
    msg.textColor = RGB(225, 225, 225);
    msg.text = NSLocalizedString(@"SupermarketNoOrder", nil);
    msg.textAlignment = NSTextAlignmentCenter;
    msg.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:msg];
    
}

- (SupermarketOrderTableView *)orderTableView {
    if (_orderTableView == nil) {
        _orderTableView = [[SupermarketOrderTableView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, self.view.frame.size.height) style:UITableViewStyleGrouped];
        _orderTableView.isPageView = self.isPageView;
        _orderTableView.contentInset = UIEdgeInsetsMake(-15, 0, 0, 0);
    }
    return _orderTableView;
}

@end
