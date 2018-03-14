//
//  CouponUsedController.m
//  Portal
//
//  Created by ifox on 2017/1/11.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "CouponUsedController.h"
#import "CouponTableView.h"

@interface CouponUsedController ()

@property(nonatomic, strong) CouponTableView *tableView;

@end

@implementation CouponUsedController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[CouponTableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.couponStatus = CouponUsed;
    [self.view addSubview:_tableView];
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
