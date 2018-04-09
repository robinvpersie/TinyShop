//
//  SupermarketHomeTasteNewCollectionView.m
//  Portal
//
//  Created by 左梓豪 on 2016/12/6.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketHomeTasteNewCollectionView.h"
#import "SupermarketHomeTasteNewCollectionViewCell.h"
#import "SupermarketHomeTasteFreshBannerData.h"
#import "SupermarketHomeMostFreshData.h"
#import "GoodsDetailController.h"
#import "UIImageView+ImageCache.h"

@implementation SupermarketHomeTasteNewCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        UINib *nib = [UINib nibWithNibName:@"SupermarketHomeTasteNewCollectionViewCell" bundle:nil];
        [self registerNib:nib forCellWithReuseIdentifier:@"Collection_Cell"];
        self.backgroundColor = [UIColor whiteColor];
        self.showsHorizontalScrollIndicator = NO;
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

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return 1;
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_dataArray.count > 0) {
        return _dataArray.count;
    }
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SupermarketHomeTasteNewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Collection_Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    if (_dataArray.count > 0) {
        SupermarketHomeMostFreshData *data = _dataArray[indexPath.row];
        cell.titleLabel.text = data.item_name;
//        cell.priceLabel.text = [NSString stringWithFormat:@"¥%@/%@",data.item_price,data.stock_unit];
		//jake 170709
		cell.priceLabel.text = [NSString stringWithFormat:@"%.f",[data.item_price doubleValue]];
        [UIImageView setimageWithImageView:cell.imageView UrlString:data.imageUrl imageVersion:data.ver];
    }
    
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击单元格");
    SupermarketHomeMostFreshData *data = _dataArray[indexPath.item];
    GoodsDetailController *vc = [GoodsDetailController new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.item_code = data.item_code;
    [self.viewController.navigationController pushViewController:vc animated:YES];
    NSLog(@"%@",indexPath);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    
    return YES;
}


@end
