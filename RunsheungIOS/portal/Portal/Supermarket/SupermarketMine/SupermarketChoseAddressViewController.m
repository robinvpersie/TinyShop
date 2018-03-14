//
//  SupermarketChoseAddressViewController.m
//  Portal
//
//  Created by ifox on 2016/12/16.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketChoseAddressViewController.h"
#import "NinaPagerView.h"
#import "SupermarketMyAddressViewController.h"
#import "SupermarketSelfPickViewController.h"
#import "SupermarketNewAddessController.h"

@interface SupermarketChoseAddressViewController ()/**<>*/

@end

@implementation SupermarketChoseAddressViewController {
    UILabel *titleLabel;
    UITextField *searchField;
    UIBarButtonItem *search;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"收货地址";
    self.navigationItem.titleView = titleLabel;
    
    searchField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth - 80, 30)];
    searchField.textAlignment = NSTextAlignmentCenter;
    searchField.placeholder = @"搜索自提站点地址";
    searchField.backgroundColor = RGB(226, 230, 231);
    
    search = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_search_001"] style:UIBarButtonItemStylePlain target:self action:@selector(goSearch)];
    search.tintColor = [UIColor darkGrayColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePageChange:) name:@"changePage" object:nil];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationController.navigationBar.translucent = NO;
    
    SupermarketMyAddressViewController *vc = [SupermarketMyAddressViewController new];
    vc.isPageView = YES;
//    vc.delegate = self;
    
    NSArray *controllers = @[vc, [SupermarketSelfPickViewController new]];
    NSArray *colorArray = @[
                            GreenColor, /**< 选中的标题颜色 Title SelectColor  **/
                            [UIColor darkGrayColor], /**< 未选中的标题颜色  Title UnselectColor **/
                            GreenColor, /**< 下划线颜色或滑块颜色 Underline or SlideBlock Color   **/
                            [UIColor whiteColor], /**<  上方菜单栏的背景颜色 TopTab Background Color   **/
                            ];
    NinaPagerView *pageView = [[NinaPagerView alloc] initWithTitles:@[@"收货地址",@"自提站点"] WithVCs:controllers WithColorArrays:colorArray];
    [self.view addSubview:pageView];
    pageView.pushEnabled = YES;
    // Do any additional setup after loading the view.
}

- (void)receivePageChange:(NSNotification *)notification {
    NSLog(@"%@",notification.object);
    NSNumber *page = notification.object;
    NSInteger pageIndex = [page integerValue];
    if (pageIndex == 0) {
        self.navigationItem.titleView = titleLabel;
    } else if (pageIndex == 1) {
        self.navigationItem.titleView = searchField;
        self.navigationItem.rightBarButtonItem = search;
    }
}

- (void)goSearch {
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
}

//- (void)addNewAddressButtonPreessed {
//    [self.navigationController pushViewController:[SupermarketNewAddessController new] animated:YES];
//}
//
//- (void)editAddressButtonPressed:(SupermarketAddressModel *)addressModel {
//    SupermarketNewAddessController *edit = [[SupermarketNewAddessController alloc] init];
//    edit.addressModel = addressModel;
//    [self.navigationController pushViewController:edit animated:YES];
//}

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
