//
//  KLRecommendCollectionView.m
//  Portal
//
//  Created by 左梓豪 on 2016/12/3.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "KLRecommendCollectionView.h"
#import "KLRecommendCollectionViewCell.h"
#import "BroadcastData.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation KLRecommendCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        UINib *nib = [UINib nibWithNibName:@"KLRecommendCollectionViewCell" bundle:nil];
        [self registerNib:nib forCellWithReuseIdentifier:@"Recommend_Cell"];
        self.delegate = self;
        self.dataSource = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.scrollEnabled = NO;
        self.backgroundColor = [UIColor whiteColor];
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
    
    KLRecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Recommend_Cell" forIndexPath:indexPath];
    
    if (_dataArray.count > 0) {
        BroadcastData *data = _dataArray[indexPath.row];
        cell.titleLabel.text = data.title;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",data.imgUrl]]];
        BOOL isLiving = [self isLiving:data];
        if (isLiving) {
            cell.statusLabel.layer.borderColor = [UIColor greenColor].CGColor;
            cell.statusLabel.text = @"正在直播";
            cell.statusLabel.textColor = [UIColor greenColor];
        }
    }
    return cell;
}

- (BOOL)isLiving:(BroadcastData *)data {
    NSString *startTime = data.start_time;
    NSString *endTime = data.end_time;
    
    NSDateFormatter *startTimeFormatter = [[NSDateFormatter alloc] init];
    [startTimeFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    [startTimeFormatter setDateFormat: @"yyyy.MM.dd HH:mm"];
    NSDate *startDate = [startTimeFormatter dateFromString:startTime];
    NSLog(@"%@",startDate);
    
    NSDateFormatter *endTimeFormatter = [[NSDateFormatter alloc] init];
    [endTimeFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    endTimeFormatter.dateFormat = @"yyyy.MM.dd HH:mm";
    NSDate *endDate = [endTimeFormatter dateFromString:endTime];
    NSLog(@"%@",endDate);
    
    NSDate *nowTime = [NSDate dateWithTimeIntervalSinceNow:0];
    
    if (([nowTime timeIntervalSince1970]>[startDate timeIntervalSince1970]) && ([nowTime timeIntervalSince1970] < [endDate timeIntervalSince1970])) {
        return YES;
    }
    
    return NO;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击单元格");
    if (_dataArray.count > 0) {
        BroadcastData *data = _dataArray[indexPath.item];
        NSString *uiqueID = [NSString stringWithFormat:@"%@",data.uniqueId];
        NSLog(@"%@",uiqueID);
//        NSString *url = [NSString stringWithFormat:@"http://222.240.51.144:89/WAP/VideoPlay?videoId=%@&kind=2",uiqueID];
//        KLPlayVideosController *vc = [[KLPlayVideosController alloc] initWithUrl:[NSURL URLWithString:url]];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.viewController.navigationController pushViewController:vc animated:vc];
    }
    NSLog(@"%@",indexPath);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    
    return YES;
}



@end
