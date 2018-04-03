//
//  SupermarketOnSaleCollectionView.m
//  Portal
//
//  Created by ifox on 2016/12/28.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketOnSaleCollectionView.h"
#import "SupermarketOnSaleCell.h"
#import "SupermarketOnSaleModel.h"
#import "GoodsDetailController.h"
#import "UIImageView+ImageCache.h"

@interface SupermarketOnSaleCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation SupermarketOnSaleCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        UINib *nib = [UINib nibWithNibName:@"SupermarketOnSaleCell" bundle:nil];
        [self registerNib:nib forCellWithReuseIdentifier:@"SupermarketOnSaleCell"];
        self.showsVerticalScrollIndicator = NO;
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
    
    SupermarketOnSaleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SupermarketOnSaleCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    if (_dataArray.count > 0) {
        SupermarketOnSaleModel *model = _dataArray[indexPath.item];
        [UIImageView setimageWithImageView:cell.goodsImageView UrlString:model.iamge_url imageVersion:model.ver];
        cell.titleLabel.text = model.item_name;
//        cell.priceLabel.text = [NSString stringWithFormat:@"%.2f/%@",model.price.floatValue,model.stock_unit];
		//jake 170709
		cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.price.floatValue];
        cell.addShoppingCart.tag = indexPath.item;
        [cell.addShoppingCart addTarget:self action:@selector(addtoShoppingCart:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击单元格");
    NSLog(@"%@",indexPath);
     SupermarketOnSaleModel *model = _dataArray[indexPath.item];
    GoodsDetailController *vc = [GoodsDetailController new];
    vc.item_code = model.item_code;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    
    return YES;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (void)addtoShoppingCart:(UIButton *)button {
    BOOL islogIn = [YCAccountModel islogin];
    if (!islogIn) {
        [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:@"您还未登录,请先登录"];
        return;
    }
    
    NSString *divCode = [[NSUserDefaults standardUserDefaults] objectForKey:DivCodeDefault];
    SupermarketOnSaleModel *model = _dataArray[button.tag];
    
    [KLHttpTool addGoodsToShoppingCartWithGoodsID:model.item_code shopID:divCode applyID:@"YC01" numbers:1 success:^(id response) {
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:response[@"message"]];
        }
        
    } failure:^(NSError *err) {
        
    }];

}


@end
