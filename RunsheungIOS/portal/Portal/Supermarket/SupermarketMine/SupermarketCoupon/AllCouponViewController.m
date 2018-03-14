//
//  AllCouponViewController.m
//  Portal
//
//  Created by ifox on 2017/2/17.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "AllCouponViewController.h"
#import "CouponTableView.h"
#import "CouponModel.h"
@interface AllCouponViewController ()

@property(nonatomic, strong) CouponTableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArr;
@property(nonatomic, assign) NSInteger total;

@end

@implementation AllCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArr = @[].mutableCopy;
    
    self.view.backgroundColor = BGColor;
    
    self.title = @"优惠券";
    
    _tableView = [[CouponTableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.couponStatus = CouponAll;
    [self.view addSubview:_tableView];
    
    [self requestData];
    // Do any additional setup after loading the view.
}

- (void)requestData {
    [KLHttpTool supermarketGetMyAllCouponspageIndex:1 success:^(id response) {
        NSLog(@"%@",response);
        
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSArray *data = response[@"data"];
            if (data.count > 0) {
                for (NSDictionary *dic in data) {
                    CouponModel *coupon = [NSDictionary getCouponModelWithDic:dic];
                    [_dataArr addObject:coupon];
                }
            }
            
            NSLog(@"%@",_dataArr);
            _tableView.dataArray = _dataArr;
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
