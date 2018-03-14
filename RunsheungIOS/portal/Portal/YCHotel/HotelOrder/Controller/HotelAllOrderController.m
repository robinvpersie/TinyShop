//
//  HotelAllOrderController.m
//  Portal
//
//  Created by ifox on 2017/4/10.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelAllOrderController.h"
#import "HotelOrderTableView.h"
#import "HotelOrderListModel.h"
#import "MJRefresh.h"

@interface HotelAllOrderController ()

@property(nonatomic, strong) HotelOrderTableView *tableView;
@property(nonatomic, strong) NSMutableArray *orderListArr;
@property(nonatomic, assign) NSInteger pageIndex;

@end

@implementation HotelAllOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pageIndex = 1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:HotelRefreshOrderListNotification object:nil];
    
    _tableView = [[HotelOrderTableView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, self.view.frame.size.height - 64*2 - 30) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    
    _orderListArr = @[].mutableCopy;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_orderListArr removeAllObjects];
        _pageIndex = 1;
        [self requestData];
    }];
    
    _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        _pageIndex++;
        [self requestData];
    }];

    
    [self requestData];
    // Do any additional setup after loading the view.
}

- (void)refreshData {
    [_orderListArr removeAllObjects];
    _pageIndex = 1;
    [self requestData];
}

- (void)requestData {
    NSLog(@"%ld",_pageIndex);
    [YCHotelHttpTool hotelGetOrderListWithPageIndex:self.pageIndex orderStatus:-1 success:^(id response) {
        NSLog(@"%@",response);
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSArray *data = response[@"data"];
            if (data.count > 0) {
                for (NSDictionary *dic in data) {
                    HotelOrderListModel *model = [NSDictionary getHotelOrderListModelWithDic:dic];
                    [_orderListArr addObject:model];
                }
            } else {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
            _tableView.dataArr = _orderListArr;
            [_tableView.mj_footer endRefreshing];
            [_tableView.mj_header endRefreshing];
        }
    } failure:^(NSError *err) {
        
    }];
}

@end
