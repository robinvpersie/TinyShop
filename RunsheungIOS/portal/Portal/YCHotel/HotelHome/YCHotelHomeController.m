//
//  YCHotelHomeController.m
//  Portal
//
//  Created by ifox on 2017/4/8.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "YCHotelHomeController.h"
#import "NinaPagerView.h"
#import "HotelHomeAllDayController.h"
#import "HotelHomeTimeController.h"
#import "UIButton+CreateButton.h"
#import "YCHotelChooseCityController.h"
#import "HotelSearchResultTableView.h"
#import "UILabel+WidthAndHeight.h"
#import "HotelHomeListModel.h"

@interface YCHotelHomeController ()

@property(nonatomic, strong) HotelSearchResultTableView *searchResultTableView;
@property(nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation YCHotelHomeController {
    UIButton *_locaationButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = @[].mutableCopy;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCityName) name:HotelCityListReloadCityNotification object:nil];
    
    UIBarButtonItem *dismiss = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(dimissHotel)];
    dismiss.tintColor = [UIColor darkGrayColor];
    self.navigationItem.leftBarButtonItem = dismiss;
    
    [self requestData];
    
    _searchResultTableView = [[HotelSearchResultTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _searchResultTableView.roomType = HotelRoomTypeAllDay;
    [self.view addSubview:_searchResultTableView];
    
    CGFloat width = [UILabel getWidthWithTitle:NSLocalizedString(@"HotelHomeTitle", nil) font:[UIFont systemFontOfSize:17]];
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width+35, 35)];
    titleView.backgroundColor = [UIColor whiteColor];
    
    UIButton *titleButton = [UIButton createButtonWithFrame:CGRectMake(0, 0, width, 35) title:NSLocalizedString(@"HotelHomeTitle", nil) titleColor:HotelBlackColor titleFont:[UIFont systemFontOfSize:17] backgroundColor:[UIColor whiteColor]];
    [titleView addSubview:titleButton];
    [titleButton addTarget:self action:@selector(presentChooseLocationController) forControlEvents:UIControlEventTouchUpInside];
    _locaationButton = [UIButton createButtonWithFrame:CGRectMake(width, 10, 45, 20) title:@"长沙市∨" titleColor:HotelGrayColor titleFont:[UIFont systemFontOfSize:11] backgroundColor:[UIColor whiteColor]];
    [_locaationButton addTarget:self action:@selector(presentChooseLocationController) forControlEvents:UIControlEventTouchUpInside];
    NSString *cityName = [[NSUserDefaults standardUserDefaults] objectForKey:HotelChooseCityName];
    if (cityName.length > 0) {
        [_locaationButton setTitle:[NSString stringWithFormat:@"%@∨",cityName] forState:UIControlStateNormal];
    }
    [titleView addSubview:_locaationButton];
    self.navigationItem.titleView = titleView;
    // Do any additional setup after loading the view.
}

- (void)changeCityName {
    NSString *cityName = [[NSUserDefaults standardUserDefaults] objectForKey:HotelChooseCityName];
    if (cityName.length > 0) {
        [_locaationButton setTitle:[NSString stringWithFormat:@"%@∨",cityName] forState:UIControlStateNormal];
    }
}

- (void)requestData {
    [MBProgressHUD showWithView:KEYWINDOW];
    NSString *title = [[NSUserDefaults standardUserDefaults] objectForKey:HotelChooseCityName];
    if (title.length == 0) {
        title = @"长沙市";
    }
    [YCHotelHttpTool HotelGetHomePageDataWithLocation:title success:^(id response) {
        NSLog(@"%@",response);
        [MBProgressHUD hideHUDForView:KEYWINDOW animated:NO];
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSArray *data = response[@"data"];
            if (data.count > 0) {
                for (NSDictionary *dic in data) {
                    HotelHomeListModel *model = [NSDictionary getHotelHomeListModelWithDic:dic];
                    [_dataArr addObject:model];
                }
                _searchResultTableView.dataArray = _dataArr;
            }
        }
    } failure:^(NSError *err) {
        [_searchResultTableView removeFromSuperview];
        [MBProgressHUD hideHUDForView:KEYWINDOW animated:YES];
        [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:@"没有数据"];
    }];
}

- (void)presentChooseLocationController {
    NSLog(@"~~~~GoChooseLocation~~~~~");
    YCHotelChooseCityController *vc = [YCHotelChooseCityController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)dimissHotel {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
