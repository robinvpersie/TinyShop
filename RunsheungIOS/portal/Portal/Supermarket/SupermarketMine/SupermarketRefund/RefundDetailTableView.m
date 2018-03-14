//
//  RefundDetailTableView.m
//  Portal
//
//  Created by ifox on 2017/3/17.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "RefundDetailTableView.h"
#import "UILabel+CreateLabel.h"
#import "RefundDetailTableViewCell.h"
#import "RefundDetailModel.h"
#import "UILabel+WidthAndHeight.h"

@interface RefundDetailTableView()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation RefundDetailTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor whiteColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerClass:[RefundDetailTableViewCell class] forCellReuseIdentifier:@"RefundCell"];
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataArr.count > 0) {
        RefundDetailModel *model = _dataArr[indexPath.section];
        return 35 + model.contentHeight + 20;
    }
    return 70;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 55)];
    
    UILabel *time = [UILabel createLabelWithFrame:CGRectMake(0, 0, 200, 20) textColor:[UIColor grayColor] font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentCenter text:@"2016-12-12"];
    time.center = header.center;
    time.backgroundColor = RGB(237, 237, 237);
    if (_dataArr.count > 0) {
        RefundDetailModel *model = _dataArr[section];
        time.text = model.time;
        CGFloat width = [UILabel getWidthWithTitle:time.text font:time.font];
        width+=20;
        time.frame = CGRectMake(0, 0, width, 20);
        time.center = header.center;
        time.layer.cornerRadius = 8;
    }
    [header addSubview:time];
    
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RefundDetailTableViewCell *cell = [[RefundDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RefundCell"];
    
    if (_dataArr.count > 0) {
        cell.data = _dataArr[indexPath.section];
    }
    
    return cell;
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    [self reloadData];
}

@end
