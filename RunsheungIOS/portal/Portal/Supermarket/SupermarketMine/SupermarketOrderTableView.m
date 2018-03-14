//
//  SupermarketOrderTableView.m
//  Portal
//
//  Created by ifox on 2016/12/22.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketOrderTableView.h"
#import "SupermarketOrderTableViewCell.h"
#import "SupermarketOrderData.h"
#import "UIView+ViewController.h"
#import "SupermarketOrderDetaiController.h"

#define CellHeight  110

@implementation SupermarketOrderTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self registerClass:[SupermarketOrderTableViewCell class] forCellReuseIdentifier:@"orderCell"];
        self.dataSource = self;
        self.delegate = self;
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;

    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataArray.count > 0) {
        SupermarketOrderData *data = _dataArray[indexPath.section];
        NSArray *goodList = data.goodList;
        NSInteger count = goodList.count;

            if (count == 1) {
                return 130+CellHeight;
            } else {
                return 130 + CellHeight*count + 5*(count-1);
            }
        }

    return 130;
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SupermarketOrderTableViewCell *cell = [[SupermarketOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.isPageView = self.isPageView;
    cell.controllerType = self.controllerType;
    if (_dataArray.count > 0) {
        cell.data = _dataArray[indexPath.section];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataArray.count > 0) {
        SupermarketOrderData *data = _dataArray[indexPath.section];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"clickOrder" object:data];
    }
}

@end
