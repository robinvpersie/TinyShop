//
//  KLHomeCollectionView.h
//  Portal
//
//  Created by 左梓豪 on 2016/12/2.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLHomeCollectionView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, strong) NSArray *dataArray;

@end
