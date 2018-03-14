//
//  HotelRefundOrderController.m
//  Portal
//
//  Created by ifox on 2017/4/10.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelRefundOrderController.h"
#import "HotelOrderTableView.h"
#import "HotelOrderListModel.h"
#import "MJRefresh.h"

@interface HotelRefundOrderController ()

@property(nonatomic, strong) HotelOrderTableView *tableView;
@property(nonatomic, strong) NSMutableArray *orderListArr;
@property(nonatomic, assign) NSInteger pageIndex;

@end

@implementation HotelRefundOrderController

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
    [YCHotelHttpTool hotelGetOrderListWithPageIndex:self.pageIndex orderStatus:6 success:^(id response) {
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
