//
//  SupermarketCommentPicCollectionView.h
//  Portal
//
//  Created by ifox on 2016/12/17.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDPhotoBrowser.h"

@interface SupermarketCommentPicCollectionView : UICollectionView<UICollectionViewDelegate, UICollectionViewDataSource, SDPhotoBrowserDelegate>

@property(nonatomic, strong) NSArray *imageArray;

@end
