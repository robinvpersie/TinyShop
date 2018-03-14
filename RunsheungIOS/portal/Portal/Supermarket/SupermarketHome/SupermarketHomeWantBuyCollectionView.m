//
//  SupermarketHomeWantBuyCollectionView.m
//  Portal
//
//  Created by 左梓豪 on 2016/12/6.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketHomeWantBuyCollectionView.h"
#import "SupermarketHomeWantBuyCollectionViewCell.h"
#import "SupermarketHomePeopleLikeData.h"
#import "UIView+ViewController.h"
#import "GoodsDetailController.h"

@implementation SupermarketHomeWantBuyCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        UINib *nib = [UINib nibWithNibName:@"SupermarketHomeWantBuyCollectionViewCell" bundle:nil];
        [self registerNib:nib forCellWithReuseIdentifier:@"Collection_Cell"];

        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        self.dataSource = self;

    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self reloadData];
}

#pragma mark - UICollectionViewDataSource

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    NSLog(@"移动单元格");
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_dataArray.count > 0) {
        return _dataArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SupermarketHomeWantBuyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Collection_Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    if (_dataArray.count > 0) {
        SupermarketHomePeopleLikeData *data = _dataArray[indexPath.row];
        cell.titleLabel.text = data.item_name;
        float price = data.item_price.floatValue;

		cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",price];
       [UIImageView setimageWithImageView:cell.imageView UrlString:data.imageUrl imageVersion:data.ver];
    }
    
    return cell;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击单元格");
    NSLog(@"%@",indexPath);
    
    GoodsDetailController *goodsDetail = [[GoodsDetailController alloc] init];
    goodsDetail.hidesBottomBarWhenPushed = YES;
    SupermarketHomePeopleLikeData *data = _dataArray[indexPath.item];
    goodsDetail.item_code = data.item_code;
    [self.viewController.navigationController pushViewController:goodsDetail animated:YES];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    
    return YES;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 4;
}

@end
