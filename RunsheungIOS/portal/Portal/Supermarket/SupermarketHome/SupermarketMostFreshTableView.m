//
//  SupermarketMostFreshTableView.m
//  Portal
//
//  Created by ifox on 2016/12/27.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketMostFreshTableView.h"
#import "SupermarketMostFreshCell.h"
#import "SupermarketHomeMostFreshData.h"
#import "GoodsDetailController.h"
#import "UIView+ViewController.h"
#import "UIImageView+ImageCache.h"

#define  CellHeight   180

@interface SupermarketMostFreshTableView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation SupermarketMostFreshTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        UINib *nib = [UINib nibWithNibName:@"SupermarketMostFreshCell" bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:@"SupermarketMostFreshCell"];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataArray.count > 0) {
        return _dataArray.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SupermarketMostFreshCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SupermarketMostFreshCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArray.count > 0) {
        SupermarketHomeMostFreshData *data = _dataArray[indexPath.row];
        cell.titleLabel.text = data.item_name;
        cell.introLabel.text = data.item_des;
        cell.likeLabel.text = [NSString stringWithFormat:@"%@%@",data.good_num,NSLocalizedString(@"SMMostFreshSayGood", nil)];
        [UIImageView setimageWithImageView:cell.goodsImageView UrlString:data.imageUrl imageVersion:data.ver];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SupermarketHomeMostFreshData *data = _dataArray[indexPath.item];
    GoodsDetailController *vc = [GoodsDetailController new];
    vc.item_code = data.item_code;
    
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

@end
