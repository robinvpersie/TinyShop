//
//  HotelPicTableViewCell.m
//  Portal
//
//  Created by ifox on 2017/4/10.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelPicTableViewCell.h"
#import "HotelPicsCollectionView.h"

#define ItemWidth (APPScreenWidth - 15*3)/2.0
#define ItemHeight 110

@implementation HotelPicTableViewCell {
    HotelPicsCollectionView *_collectionView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
        layOut.minimumInteritemSpacing = 0;
        layOut.minimumLineSpacing = 0;
        layOut.itemSize = CGSizeMake(ItemWidth, ItemHeight);
        layOut.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        layOut.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[HotelPicsCollectionView alloc] initWithFrame:CGRectMake(0, 0,APPScreenWidth , ItemHeight * 2 + 15) collectionViewLayout:layOut];
        [self.contentView addSubview:_collectionView];
    }
    return self;
}

- (void)setImageArr:(NSArray *)imageArr {
    _imageArr = imageArr;
    _collectionView.imageArr = imageArr;
    CGRect collectionFrame = _collectionView.frame;
    if (_imageArr.count > 0) {
        NSInteger line = (imageArr.count + 1)/2;
        NSInteger space = (imageArr.count - 1)/2;
        CGFloat cellHeight = 110*line + 15*space;
        collectionFrame.size.height = cellHeight;
        _collectionView.frame = collectionFrame;
    } else {
        collectionFrame.size.height = 0;
        _collectionView.frame = collectionFrame;
    }
  
}

@end
