//
//  SupermarketHomeWantBuyCollectionView.h
//  Portal
//
//  Created by 左梓豪 on 2016/12/6.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SupermarketHomeWantBuyCollectionView : UICollectionView <UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic, strong) NSArray *dataArray;

@end
