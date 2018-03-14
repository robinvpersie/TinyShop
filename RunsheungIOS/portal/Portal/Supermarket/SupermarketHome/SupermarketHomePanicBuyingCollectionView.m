//
//  SupermarketHomePanicBuyingCollectionView.m
//  Portal
//
//  Created by 左梓豪 on 2016/12/7.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketHomePanicBuyingCollectionView.h"
#import "SupermarketHomePanicBuyingCell.h"
#import "SupermarketHomePurchaseData.h"

@implementation SupermarketHomePanicBuyingCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        UINib *nib = [UINib nibWithNibName:@"SupermarketHomePanicBuyingCell" bundle:nil];
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_dataArray.count > 0) {
        return _dataArray.count;
    }
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SupermarketHomePanicBuyingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Collection_Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    if (_dataArray.count > 0) {
        SupermarketHomePurchaseData *data = _dataArray[indexPath.row];
        cell.titleLabel.text = data.title;
//        cell.priceLabel.text = data.price;
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%@",data.price];
        [UIImageView setimageWithImageView:cell.imageView UrlString:data.imageUrl imageVersion:data.ver];
    }
    
    //    height += (cell.frame.size.height/2+2.5);
    //    CGRect frame = self.frame;
    //    frame.size.height = height;
    //    self.frame = frame;
    
    return cell;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击单元格");
    NSLog(@"%@",indexPath);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    
    return YES;
}



@end
