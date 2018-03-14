//
//  YCHotelChooseCityController.m
//  Portal
//
//  Created by ifox on 2017/4/8.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "YCHotelChooseCityController.h"
#import "HotelSearchTableView.h"
#import "HotelCityModel.h"

@interface YCHotelChooseCityController ()

@property(nonatomic, strong) HotelSearchTableView *locationTableView;
@property(nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation YCHotelChooseCityController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"切换城市";
    
    _dataArr = @[].mutableCopy;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissController) name:HotelCityListReloadCityNotification object:nil];
    
    [self createView];
    
    [self requestData];
    // Do any additional setup after loading the view.
}

//- (void)dismissController {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

- (void)createView {
    _locationTableView = [[HotelSearchTableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:_locationTableView];
    
    UIBarButtonItem *dismiss = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_closecity"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissController)];
    dismiss.tintColor = HotelBlackColor;
    self.navigationItem.leftBarButtonItem = dismiss;
}

- (void)requestData {
    [MBProgressHUD showWithView:self.view];
    [YCHotelHttpTool hotelGetCityListsuccess:^(id response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSArray *availableCityList = response[@"availableCityList"];
        if (availableCityList.count > 0) {
            for (NSDictionary *dic in availableCityList) {
                HotelCityModel *city = [NSDictionary getHotelCityModelWithDic:dic];
                [_dataArr addObject:city];
            }
            _locationTableView.dataArr = _dataArr;
        }
    } failure:^(NSError *err) {
        
    }];
}

- (void)dismissController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
