//
//  SupermarketKindsViewController.m
//  Portal
//
//  Created by 左梓豪 on 2016/12/6.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketKindsViewController.h"
#import "NinaPagerView.h"
#import "SupermarketKindHotController.h"
#import "SupermarketKindNewController.h"
#import "SupermarketKindSaleController.h"
#import "SupermarketKindPriceController.h"

@interface SupermarketKindsViewController ()

@end

@implementation SupermarketKindsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    self.title = @"商品列表";
    
    NSArray *colorArray = @[
                            GreenColor, /**< 选中的标题颜色 Title SelectColor  **/
                            [UIColor darkGrayColor], /**< 未选中的标题颜色  Title UnselectColor **/
                            GreenColor, /**< 下划线颜色或滑块颜色 Underline or SlideBlock Color   **/
                            [UIColor whiteColor], /**<  上方菜单栏的背景颜色 TopTab Background Color   **/
                            ];
    
    SupermarketKindHotController *hot = [SupermarketKindHotController new];
    hot.category_code = self.category_code;
    hot.level = self.level;
    
    SupermarketKindNewController *new = [SupermarketKindNewController new];
    new.category_code = self.category_code;
    new.level = self.level;
    
    SupermarketKindSaleController *sale = [SupermarketKindSaleController new];
    sale.category_code = self.category_code;
    sale.level = self.level;
    
    SupermarketKindPriceController *price = [SupermarketKindPriceController new];
    price.category_code = self.category_code;
    price.level = self.level;
    
    NinaPagerView *pagerView = [[NinaPagerView alloc] initWithTitles:@[NSLocalizedString(@"SMKindsHot", nil),NSLocalizedString(@"SMKindsNew", nil),NSLocalizedString(@"SMKindsSales", nil),NSLocalizedString(@"SMKindsPrice", nil)] WithVCs:@[hot,new,sale,price] WithColorArrays:colorArray];
    [self.view addSubview:pagerView];
    
    pagerView.pushEnabled = YES;
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
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
