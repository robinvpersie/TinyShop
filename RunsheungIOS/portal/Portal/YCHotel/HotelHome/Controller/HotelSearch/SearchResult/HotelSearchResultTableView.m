//
//  HotelSearchResultTableView.m
//  Portal
//
//  Created by ifox on 2017/4/5.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelSearchResultTableView.h"
#import "HotelSearchResultTableViewCell.h"
#import "HotelPicsController.h"
#import "HotelHomeListModel.h"
#import "HotelSpecificSearchResultController.h"

@interface HotelSearchResultTableView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation HotelSearchResultTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self registerClass:[HotelSearchResultTableViewCell class] forCellReuseIdentifier:@"SearchReultCell"];
        self.dataSource = self;
        self.delegate = self;
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 125;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataArray.count > 0) {
        return _dataArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HotelSearchResultTableViewCell *cell = [[HotelSearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchReultCell"];
    
    cell.rommType = self.roomType;
    if (_dataArray.count > 0) {
        cell.data = _dataArray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    HotelHomeListModel *model = _dataArray[indexPath.row];
    
    HotelSpecificSearchResultController *specificSearchResultVC = [[HotelSpecificSearchResultController alloc]initWithModel:model];
    specificSearchResultVC.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:specificSearchResultVC  animated:YES];

}

- (void)setRoomType:(HotelRoomType)roomType {
    _roomType = roomType;
    [self reloadData];
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self reloadData];
}

@end
