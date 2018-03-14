//
//  SupermarketHomePanicBuyingCollectionView.h
//  Portal
//
//  Created by 左梓豪 on 2016/12/7.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
    限时抢购
 */
@interface SupermarketHomePanicBuyingCollectionView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, strong) NSArray *dataArray;

@end
