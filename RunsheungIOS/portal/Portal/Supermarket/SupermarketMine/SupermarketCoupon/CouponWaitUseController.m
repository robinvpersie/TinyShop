//
//  CouponWaitUseController.m
//  Portal
//
//  Created by ifox on 2017/1/11.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "CouponWaitUseController.h"
#import "CouponTableView.h"

@interface CouponWaitUseController ()

@property(nonatomic, strong) CouponTableView *tableView;

@end

@implementation CouponWaitUseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[CouponTableView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, self.view.frame.size.height - 148) style:UITableViewStylePlain];
    _tableView.couponStatus = CouponWaitUse;
    _tableView.dataArray = self.canUseCoupons;
    [self.view addSubview:_tableView];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(0, self.view.frame.size.height - 148, APPScreenWidth, 40);
    sureButton.backgroundColor = [UIColor redColor];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [sureButton addTarget:self action:@selector(getSelectedResult) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sureButton];
    // Do any additional setup after loading the view.
}

- (void)getSelectedResult {
    self.selectedCoupons = _tableView.selectedArray;
    [[NSNotificationCenter defaultCenter] postNotificationName:CouponSureButtonClickedNotification object:self.selectedCoupons];
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
