//
//  KLHomeCollectionView.m
//  Portal
//
//  Created by 左梓豪 on 2016/12/2.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "KLHomeCollectionView.h"
#import "KLHomeCollectionViewCell.h"
#import "MovieData.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation KLHomeCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        UINib *nib = [UINib nibWithNibName:@"KLHomeCollectionViewCell" bundle:nil];
        [self registerNib:nib forCellWithReuseIdentifier:@"Collection_Cell"];
        self.delegate = self;
        self.dataSource = self;
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = [UIColor clearColor];
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
//    return 4;
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_dataArray.count > 0) {
        return _dataArray.count;
    }
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    KLHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Collection_Cell" forIndexPath:indexPath];
    if (_dataArray.count > 0) {
        MovieData *data = _dataArray[indexPath.row];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",data.imgUrl]]];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"点击单元格");
//    NSLog(@"%@",indexPath);
//    if (_dataArray.count > 0) {
//         MovieData *data = _dataArray[indexPath.item];
//        NSNumber *uiniqueID = data.uniqueId;
//        NSLog(@"%@",uiniqueID);
//        NSString *url = [NSString stringWithFormat:@"http://192.168.2.233:89/WAP/VideoPlay?videoId=%@&kind=3",uiniqueID];
//        KLPlayVideosController *vc = [[KLPlayVideosController alloc] initWithUrl:[NSURL URLWithString:url]];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.viewController.navigationController pushViewController:vc animated:vc];
//    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    
    return YES;
}


@end
