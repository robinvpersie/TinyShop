//
//  HotelPicsCollectionView.m
//  Portal
//
//  Created by ifox on 2017/4/10.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelPicsCollectionView.h"
#import "HotelPicsCollectionViewCell.h"
#import "SDPhotoBrowser.h"
#import "HotelAlbumImageModel.h"

@interface HotelPicsCollectionView()<UICollectionViewDelegate, UICollectionViewDataSource,SDPhotoBrowserDelegate>

@end

@implementation HotelPicsCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.scrollEnabled = NO;
        self.backgroundColor = BGColor;
        UINib *nib = [UINib nibWithNibName:@"HotelPicsCollectionViewCell" bundle:nil];
        [self registerNib:nib forCellWithReuseIdentifier:@"HotelPicsCell"];
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
    if (_imageArr.count > 0) {
        return _imageArr.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HotelPicsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotelPicsCell" forIndexPath:indexPath];
    cell.backgroundColor = BGColor;
    if (_imageArr.count > 0) {
        HotelAlbumImageModel *model = _imageArr[indexPath.item];
        [UIImageView hotelSetImageWithImageView:cell.imageView UrlString:model.imgurl imageVersion:nil];
    }
    
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
    NSLog(@"%@",indexPath);
    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = indexPath.item;
    photoBrowser.imageCount = _imageArr.count;
    photoBrowser.sourceImagesContainerView = self;
    
    [photoBrowser show];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    
    return YES;
}

#pragma mark  SDPhotoBrowserDelegate

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    // 不建议用此种方式获取小图，这里只是为了简单实现展示而已
    HotelPicsCollectionViewCell *cell = (HotelPicsCollectionViewCell *)[self collectionView:self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];

    return cell.imageView.image;
    
}

- (void)setImageArr:(NSArray *)imageArr {
    _imageArr = imageArr;
    [self reloadData];
}



@end
