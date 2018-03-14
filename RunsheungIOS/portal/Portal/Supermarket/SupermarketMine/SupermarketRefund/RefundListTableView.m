//
//  RefundListTableView.m
//  Portal
//
//  Created by ifox on 2017/3/20.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "RefundListTableView.h"
#import "RefundListCell.h"

@interface RefundListTableView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation RefundListTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        if (isIOS11) {
            self.estimatedRowHeight = 0;
            self.estimatedSectionHeaderHeight = 0;
            self.estimatedSectionFooterHeight = 0;
        }
        [self registerClass:[RefundListCell class] forCellReuseIdentifier:@"ListCell"];
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 165;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_dataArray.count > 0) {
        return _dataArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RefundListCell *cell = [[RefundListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ListCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArray.count > 0) {
        cell.data = _dataArray[indexPath.section];
    }
    return cell;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self reloadData];
}

@end
