//
//  GroomCollectionView.h
//  Portal
//
//  Created by dlwpdlr on 2018/5/25.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroomCollectionView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
@property (nonatomic,retain)UICollectionView *collectionview;
@property (nonatomic,retain)NSArray *datas;
- (instancetype)initWithFrame:(CGRect)frame;

@end
