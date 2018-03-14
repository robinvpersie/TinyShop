//
//  SupermarketCommentPicCollectionView.m
//  Portal
//
//  Created by ifox on 2016/12/17.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketCommentPicCollectionView.h"
#import "SupermarketCommentPicCell.h"

@implementation SupermarketCommentPicCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        UINib *nib = [UINib nibWithNibName:@"SupermarketCommentPicCell" bundle:nil];
        [self registerNib:nib forCellWithReuseIdentifier:@"SupermarketCommentPicCell"];
        self.backgroundColor = [UIColor whiteColor];
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        self.dataSource = self;
        self.scrollEnabled = YES;
    }
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_imageArray.count > 0) {
        return _imageArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SupermarketCommentPicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SupermarketCommentPicCell" forIndexPath:indexPath];
    [UIImageView setimageWithImageView:cell.imageView UrlString:_imageArray[indexPath.row] imageVersion:nil];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = indexPath.item;
    photoBrowser.imageCount = _imageArray.count;
    photoBrowser.sourceImagesContainerView = self;
    
    [photoBrowser show];
}

#pragma mark  SDPhotoBrowserDelegate

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    // 不建议用此种方式获取小图，这里只是为了简单实现展示而已
    SupermarketCommentPicCell *cell = (SupermarketCommentPicCell *)[self collectionView:self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    
    return cell.imageView.image;
    
}


// 返回高质量图片的url
//- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
//{
////    NSString *urlStr = [[self.modelsArray[index] thumbnail_pic] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
//    NSString *urlStr = @"http://img2.niutuku.com/desk/anime/5732/5732-6922.jpg";
//    return [NSURL URLWithString:urlStr];
//}



@end
