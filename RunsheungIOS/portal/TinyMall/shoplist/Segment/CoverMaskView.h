//
//  CoverMaskView.h
//  Portal
//
//  Created by dlwpdlr on 2018/5/21.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SaixuanDegate<NSObject>

- (void)clickSaixuan:(int)index;

@end;

@interface CoverMaskView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,retain)NSArray *data;
@property(nonatomic,strong)UICollectionView *collectionview;
@property (nonatomic,assign) id<SaixuanDegate>sxdegate;
@end
