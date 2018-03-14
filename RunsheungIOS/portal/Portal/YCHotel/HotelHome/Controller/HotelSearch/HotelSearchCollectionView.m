//
//  HotelSearchCollectionView.m
//  Portal
//
//  Created by ifox on 2017/4/1.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelSearchCollectionView.h"
#import "HotelSearchCollectionViewCell.h"
#import "HotelCityModel.h"

@interface HotelSearchCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation HotelSearchCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor whiteColor];
        [self setScrollEnabled:NO];
        UINib *nib = [UINib nibWithNibName:@"HotelSearchCollectionViewCell" bundle:nil];
        [self registerNib:nib forCellWithReuseIdentifier:@"HotelSearchCell"];
    }
    return self;
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
    if (_citys.count > 0) {
        return _citys.count;
    }
      return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HotelSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotelSearchCell" forIndexPath:indexPath];
    HotelCityModel *model = _citys[indexPath.item];
    cell.titleLabel.text = model.cityName;
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15.0f;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HotelCityModel *cityModel = _citys[indexPath.item];
    
    [[NSUserDefaults standardUserDefaults] setObject:cityModel.cityName forKey:HotelChooseCityName];
    [[NSUserDefaults standardUserDefaults] setObject:cityModel.zipCode forKey:HotelChooseCityZipCodeDefault];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HotelCityListReloadCityNotification object:nil];
  
    NSLog(@"%@",indexPath);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    
    return YES;
}

- (void)setCitys:(NSArray *)citys {
    _citys = citys;
    [self reloadData];
}

@end
