//
//  SupermarketRefundController.m
//  Portal
//
//  Created by ifox on 2017/1/11.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "SupermarketRefundController.h"
#import "SupermarketOrderTableView.h"
#import "OrderVirtualData.h"
#import "XTPopView.h"
#import "SupermarketRefundRuleController.h"
#import "RefundListData.h"
#import "RefundListTableView.h"
#import "MJRefresh.h"
#import "CustomerServiceController.h"

@interface SupermarketRefundController ()<selectIndexPathDelegate>

@property(nonatomic, strong)RefundListTableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArr;
@property(nonatomic, assign) NSInteger pageIndex;
@property(nonatomic, assign) NSInteger totalDatas;
@property (nonatomic, strong) UIButton *customBtn;

@end

@implementation SupermarketRefundController {
    XTPopView *view1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"SMOrderRefundTitle", nil);
    
    _dataArr = @[].mutableCopy;
    _pageIndex = 1;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadListData) name:ReloadRefundListNotification object:nil];
    
    _tableView = [[RefundListTableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_dataArr removeAllObjects];
        _pageIndex = 1;
        [self requestData];
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageIndex++;
        if (_dataArr.count < _totalDatas) {
         [self requestData];
        } else {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }];
    
    _customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _customBtn.frame = CGRectMake(0, 0, 40, 40);
    [_customBtn setImage:[UIImage imageNamed:@"nav_more"] forState:UIControlStateNormal];
    [_customBtn addTarget:self action:@selector(showSmallWindow) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithCustomView:_customBtn];
    self.navigationItem.rightBarButtonItem = btn;
    
    [self requestData];
    // Do any additional setup after loading the view.
}

- (void)reloadListData {
    _pageIndex = 1;
    [_dataArr removeAllObjects];
    [self requestData];
}

- (void)requestData {
    if (self.controllerType == ControllerTypeDepartmentStores) {
//        [KLHttpTool shopGetRefundLiestWithPageIndex:_pageIndex success:^(id response) {
//            NSNumber *status = response[@"status"];
//            
//            if (status.integerValue == 1) {
//                NSArray *data = response[@"data"];
//                if (data.count > 0) {
//                    for (NSDictionary *dic in data) {
//                        RefundListData *listData = [NSDictionary getRefundListDataWithDic:dic];
//                        [_dataArr addObject:listData];
//                    }
//                    _tableView.dataArray = _dataArr;
//                }
//                _totalDatas = ((NSNumber *)response[@"total"]).integerValue;
//                [_tableView.mj_footer endRefreshing];
//                [_tableView.mj_header endRefreshing];
//            }
//
//        } failure:^(NSError *err) {
//            
//        }];
        [KLHttpTool supermarketGetRefundLiestWithPageIndex:_pageIndex success:^(id response) {
            NSLog(@"%@",response);
            NSNumber *status = response[@"status"];
            
            if (status.integerValue == 1) {
                NSArray *data = response[@"data"];
                if (data.count > 0) {
                    for (NSDictionary *dic in data) {
                        RefundListData *listData = [NSDictionary getRefundListDataWithDic:dic];
                        [_dataArr addObject:listData];
                    }
                    _tableView.dataArray = _dataArr;
                }
                _totalDatas = ((NSNumber *)response[@"total"]).integerValue;
                [_tableView.mj_footer endRefreshing];
                [_tableView.mj_header endRefreshing];
            }
        } failure:^(NSError *err) {
            
        }];
    } else {
        [KLHttpTool supermarketGetRefundLiestWithPageIndex:_pageIndex success:^(id response) {
            NSLog(@"%@",response);
            NSNumber *status = response[@"status"];
            
            if (status.integerValue == 1) {
                NSArray *data = response[@"data"];
                if (data.count > 0) {
                    for (NSDictionary *dic in data) {
                        RefundListData *listData = [NSDictionary getRefundListDataWithDic:dic];
                        [_dataArr addObject:listData];
                    }
                    _tableView.dataArray = _dataArr;
                }
                _totalDatas = ((NSNumber *)response[@"total"]).integerValue;
                [_tableView.mj_footer endRefreshing];
                [_tableView.mj_header endRefreshing];
            }
        } failure:^(NSError *err) {
            
        }];
    }
}

- (void)showSmallWindow {
    CGPoint point = CGPointMake(_customBtn.center.x,_customBtn.frame.origin.y + 60);
    
    view1 = [[XTPopView alloc] initWithOrigin:point Width:150 Height:45 * 2 Type:XTTypeOfUpRight Color:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0]];
        view1.backGoundView.backgroundColor = [UIColor whiteColor];
    view1.dataArray = @[NSLocalizedString(@"SMRefundRule", nil),NSLocalizedString(@"SMContactServiceButtonTitle", nil)];
    view1.images = @[@"rule",@"phone_black"];
    view1.fontSize = 15;
    view1.row_height = 45;
    view1.titleTextColor = [UIColor darkcolor];
    view1.delegate = self;
    [view1 popView];
}

- (void)selectIndexPathRow:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            NSLog(@"Click 0 ......");
            SupermarketRefundRuleController *rule = [[SupermarketRefundRuleController alloc] init];
            [view1 dismiss];
            [self.navigationController pushViewController:rule animated:YES];
        }
            break;
        case 1:
        {
            NSLog(@"Clikc 1 ......");
            CustomerServiceController *vc = [[CustomerServiceController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;

        default:
            break;
    }
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
