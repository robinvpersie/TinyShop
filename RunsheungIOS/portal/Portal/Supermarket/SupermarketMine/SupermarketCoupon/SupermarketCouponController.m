//
//  SupermarketCouponController.m
//  Portal
//
//  Created by ifox on 2017/1/11.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "SupermarketCouponController.h"
#import "CouponWaitUseController.h"
#import "CouponUsedController.h"
#import "CouponOverTimeController.h"
#import "NinaPagerView.h"
#import "CouponCantUseController.h"

@interface SupermarketCouponController ()

@end

@implementation SupermarketCouponController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pooController) name:CouponSureButtonClickedNotification object:nil];
    
    self.title = @"优惠券";
    
    CouponWaitUseController *waitUse = [[CouponWaitUseController alloc] init];
    waitUse.canUseCoupons = self.canUseCoupons;
//    CouponUsedController *used = [[CouponUsedController alloc] init];
//    CouponOverTimeController *overtime = [[CouponOverTimeController alloc] init];
    
    CouponCantUseController *cantUse = [[CouponCantUseController alloc] init];
    cantUse.cantUseCoupons = self.cantUseCoupons;
    
    NSArray *colorArray = @[
                            GreenColor, /**< 选中的标题颜色 Title SelectColor  **/
                            [UIColor darkGrayColor], /**< 未选中的标题颜色  Title UnselectColor **/
                            GreenColor, /**< 下划线颜色或滑块颜色 Underline or SlideBlock Color   **/
                            [UIColor whiteColor], /**<  上方菜单栏的背景颜色 TopTab Background Color   **/
                            ];
    
    NSString *canUseTitle = [NSString stringWithFormat:@"可用优惠券(%ld)",self.canUseCoupons.count];
    NSString *cantUseTitle = [NSString stringWithFormat:@"不可用优惠券(%ld)",self.cantUseCoupons.count];
    
    NinaPagerView *pageView = [[NinaPagerView alloc] initWithTitles:@[canUseTitle,cantUseTitle] WithVCs:@[waitUse,cantUse] WithColorArrays:colorArray];
    pageView.pushEnabled = YES;
    [self.view addSubview:pageView];
    // Do any additional setup after loading the view.
}

- (void)pooController {
    [self.navigationController popViewControllerAnimated:YES];
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
