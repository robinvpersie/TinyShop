//
//  HotelOrderTableView.m
//  Portal
//
//  Created by ifox on 2017/4/10.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelOrderTableView.h"
#import "HotelOrderTableViewCell.h"
#import "HotelReserveResultDetailController.h"


@interface HotelOrderTableView ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation HotelOrderTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        [self registerClass:[HotelOrderTableViewCell class] forCellReuseIdentifier:@"HotelOrderTableViewCell"];
        self.backgroundColor = BGColor;
        if (isIOS11) {
            self.estimatedRowHeight = 0;
            self.estimatedSectionHeaderHeight = 0;
            self.estimatedSectionFooterHeight = 0;
        }
    }
    return self;
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    [self reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_dataArr.count > 0) {
        return _dataArr.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HotelOrderTableViewCell *cell = [[HotelOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HotelOrderTableViewCell"];
    if (_dataArr.count > 0) {
    cell.data = _dataArr[indexPath.section];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataArr.count > 0) {
        HotelOrderListModel *data = _dataArr[indexPath.section];
        [[NSNotificationCenter defaultCenter] postNotificationName:HotelClickOrderNotification object:data];
    }
}

@end
