//
//  HotelSearchResultController.m
//  Portal
//
//  Created by ifox on 2017/4/5.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelSearchResultController.h"
#import "HotelSearchResultTableView.h"
#import "HotelSearchFilterView.h"

@interface HotelSearchResultController ()

@property(nonatomic, strong) HotelSearchResultTableView *searchResultTableView;
@property(nonatomic, strong) HotelSearchFilterView *filterView;

@end

@implementation HotelSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   
    [self createView];
}

- (void)createView {
     _searchResultTableView = [[HotelSearchResultTableView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height - 40) style:UITableViewStylePlain];
     _filterView = [[HotelSearchFilterView alloc] initWithFrame:CGRectMake(0, 64, APPScreenWidth, self.view.frame.size.height)];
    [self.view addSubview:_searchResultTableView];
    [self.view addSubview:_filterView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
