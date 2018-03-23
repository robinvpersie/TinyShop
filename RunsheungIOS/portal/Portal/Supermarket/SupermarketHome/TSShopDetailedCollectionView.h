//
//  ShopDetailedCollectionView.h
//  GigaProject
//
//  Created by dlwpdlr on 2018/3/9.
//  Copyright © 2018年 GIGA Korea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSShopDetailedCollectionView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource>

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout;
/**
 数据源数组
 */
@property(nonatomic,retain)NSArray *dataArray;

@property (nonatomic,retain)NSDictionary *shopDic;

@end
