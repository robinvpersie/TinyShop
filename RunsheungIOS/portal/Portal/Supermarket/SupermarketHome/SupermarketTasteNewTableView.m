//
//  SupermarketTasteNewTableView.m
//  Portal
//
//  Created by ifox on 2016/12/28.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketTasteNewTableView.h"
#import "SupermarketTasteNewCell.h"
#import "SupermarketHomeMostFreshData.h"
#import "GoodsDetailController.h"
#import "UIView+ViewController.h"
#import "UIImageView+ImageCache.h"

@interface SupermarketTasteNewTableView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation SupermarketTasteNewTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = BGColor;
        
        UINib *nib = [UINib nibWithNibName:@"SupermarketTasteNewCell" bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:@"SupermarketTasteNewCell"];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 250;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_dataArray.count > 0) {
        return _dataArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SupermarketTasteNewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SupermarketTasteNewCell"];
    [cell.buyRightNow addTarget:self action:@selector(goDetail:) forControlEvents:UIControlEventTouchUpInside];
    if (_dataArray.count > 0) {
        SupermarketHomeMostFreshData *data = _dataArray[indexPath.section];
        [UIImageView setimageWithImageView:cell.goodsImageView UrlString:data.imageUrl imageVersion:data.ver];
        cell.titleLabel.text = data.item_name;
//        cell.priceLabel.text = [NSString stringWithFormat:@"¥%@/%@",data.item_price,data.stock_unit];
		//jake 170709
		cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",data.item_price];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SupermarketHomeMostFreshData *data = _dataArray[indexPath.section];
    GoodsDetailController *vc = [GoodsDetailController new];
    vc.item_code = data.item_code;
    
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (void)goDetail:(UIButton *)button {
    UIView *view = button.superview.superview;
    if ([view isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell *cell = (UITableViewCell *)view;
        NSIndexPath *indexPath = [self indexPathForCell:cell];
        
        SupermarketHomeMostFreshData *data = _dataArray[indexPath.section];
        GoodsDetailController *vc = [GoodsDetailController new];
        vc.item_code = data.item_code;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
}


@end
