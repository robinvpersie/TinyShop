//
//  CouponTableView.m
//  Portal
//
//  Created by ifox on 2017/1/11.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "CouponTableView.h"
#import "CouponTableViewCell.h"
#import "CouponModel.h"

@interface CouponTableView ()<UITableViewDelegate, UITableViewDataSource, SelectCouponDelegate>

@end

@implementation CouponTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = RGB(242, 242, 242);
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.dataSource = self;
        self.delegate = self;
        _selectedArray = @[].mutableCopy;
        [self registerClass:[CouponTableViewCell class] forCellReuseIdentifier:@"CouponTableViewCell"];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataArray.count > 0) {
        return _dataArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CouponTableViewCell *cell = [[CouponTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CouponTableViewCell"];
    if (_dataArray.count > 0) {
        cell.coupon = _dataArray[indexPath.row];
    }
    
    cell.couponStatus = self.couponStatus;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_couponStatus == CouponCantUse) {
        return 120;
    }
    return 95;
}

- (void)selectCoupon:(CouponTableViewCell *)cell
          isSelected:(BOOL)isSelected {
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    
    if (isSelected) {
        CouponModel *coupon = cell.coupon;
        coupon.isSelected = YES;
        [_selectedArray addObject:coupon];
        
        NSInteger range = coupon.couponRange.integerValue;
        
        //全类品选中一张,其余都不能选
        if (coupon.couponRange.integerValue == 0) {
            if ([self.dataArray containsObject:coupon]) {
                for (CouponModel *couponModel in self.dataArray) {
                    if (couponModel != coupon) {
                        couponModel.cantSelected = YES;
                    }
                }
                [self reloadData];
            }
        } else {
            if ([self.dataArray containsObject:coupon]) {
                for (CouponModel *couponModel in self.dataArray) {
                    //相同range不能选
                    if (couponModel.couponRange.integerValue == range) {
                        if (couponModel != coupon) {
                            couponModel.cantSelected = YES;
                        }
                    }
                    //0的range不能选
                    if (couponModel.couponRange.integerValue == 0) {
                        couponModel.cantSelected = YES;
                    }
                }
            }
            [self reloadData];
        }

    } else {
        CouponModel *coupon = cell.coupon;
        coupon.isSelected = NO;
        [_selectedArray removeObject:coupon];
        
        NSInteger range = coupon.couponRange.integerValue;
        
        if (self.selectedArray.count > 0) {
            for (CouponModel *couponModel in self.dataArray) {
                if (couponModel.couponRange.integerValue == range) {
                    couponModel.cantSelected = NO;
                }
            }
            
            [self reloadData];
        } else {
            //全类品取消选中后都可以选
            if (coupon.couponRange.integerValue == 0) {
                for (CouponModel *couponModel in self.dataArray) {
                    couponModel.cantSelected = NO;
                }
                [self reloadData];
            } else {
                for (CouponModel *couponModel in self.dataArray) {
                    if (couponModel.couponRange.integerValue == range) {
                        couponModel.cantSelected = NO;
                    }
                    if (couponModel.couponRange.integerValue == 0) {
                        couponModel.cantSelected = NO;
                    }
                }
                [self reloadData];
            }
        }
    }
}

- (void)setCouponStatus:(CouponStatus)couponStatus {
    _couponStatus = couponStatus;
    [self reloadData];
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self reloadData];
}

@end
