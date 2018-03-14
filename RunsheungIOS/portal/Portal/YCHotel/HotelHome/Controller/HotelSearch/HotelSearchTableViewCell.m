//
//  HotelSearchTableViewCell.m
//  Portal
//
//  Created by ifox on 2017/4/1.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelSearchTableViewCell.h"
#import "HotelSearchCollectionView.h"
#import "HotelCityModel.h"

#define ItemWidth (APPScreenWidth - 15*4)/3.0
#define ItemHeight 35

@implementation HotelSearchTableViewCell {
    HotelSearchCollectionView *_collectionView;
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
        
        _collectionView = [[HotelSearchCollectionView alloc] initWithFrame:CGRectMake(0, 0,APPScreenWidth , ItemHeight * 2 + 15) collectionViewLayout:layOut];
        [self.contentView addSubview:_collectionView];
    }
    return self;
}

- (void)setCitys:(NSArray *)citys {
    _citys = citys;
    if (citys.count == 1) {
        HotelCityModel *city = citys.firstObject;
        [[NSUserDefaults standardUserDefaults] setObject:city.cityName forKey:HotelChooseCityName];
        [[NSUserDefaults standardUserDefaults] setObject:city.zipCode forKey:HotelChooseCityZipCodeDefault];
//        _collectionView.userInteractionEnabled = NO;
    }
    _collectionView.frame = CGRectMake(0, 0,APPScreenWidth , ItemHeight * citys.count + 15);
    _collectionView.citys = citys;
}

@end
