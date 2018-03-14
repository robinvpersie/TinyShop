//
//  HotelHomeTimeController.m
//  Portal
//
//  Created by ifox on 2017/4/8.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelHomeTimeController.h"
#import "HotelSearchResultTableView.h"

@interface HotelHomeTimeController ()

@property(nonatomic, strong) HotelSearchResultTableView *searchResultTableView;

@end

@implementation HotelHomeTimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _searchResultTableView = [[HotelSearchResultTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64*2) style:UITableViewStylePlain];
    _searchResultTableView.roomType = HotelRoomTypeHour;
    [self.view addSubview:_searchResultTableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
