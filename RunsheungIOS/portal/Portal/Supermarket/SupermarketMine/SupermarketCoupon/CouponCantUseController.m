//
//  CouponCantUseController.m
//  Portal
//
//  Created by ifox on 2017/2/17.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "CouponCantUseController.h"
#import "CouponTableView.h"

@interface CouponCantUseController ()

@property(nonatomic, strong) CouponTableView *tableView;

@end

@implementation CouponCantUseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BGColor;
    
    _tableView = [[CouponTableView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, self.view.frame.size.height - 110) style:UITableViewStylePlain];
    _tableView.couponStatus = CouponAll;
    [self.view addSubview:_tableView];
    _tableView.dataArray = _cantUseCoupons;
    // Do any additional setup after loading the view.
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
