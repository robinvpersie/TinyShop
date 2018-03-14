//
//  HotelDetailIntroController.m
//  Portal
//
//  Created by ifox on 2017/4/7.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelDetailIntroController.h"
#import "HotelDetailIntroTableView.h"
#import "HotelDetailInfoModel.h"

@interface HotelDetailIntroController ()

@property(nonatomic, strong) HotelDetailIntroTableView *tableView;

@end

@implementation HotelDetailIntroController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"酒店详情介绍";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[HotelDetailIntroTableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    
    [self requetData];
    // Do any additional setup after loading the view.
}

- (void)requetData {
    [YCHotelHttpTool hotelgetDetailIntroWithHotelID:self.hotelInfoID success:^(id response) {
        NSLog(@"%@",response);
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSDictionary *data = response[@"data"];
            HotelDetailInfoModel *model = [NSDictionary getHotelDetailIntroModelWithDic:data];
            NSLog(@"%@",model);
            _tableView.detailModel = model;
            
        }
    } failure:^(NSError *err) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
