//
//  ShopDetailedCollectionView.m
//  GigaProject
//
//  Created by dlwpdlr on 2018/3/9.
//  Copyright © 2018年 GIGA Korea. All rights reserved.
//

#import "TSShopDetailedCollectionView.h"
#import "ShopDetailedCollectionCell.h"
#import "UIView+ViewController.h"


@implementation TSShopDetailedCollectionView{
	NSString *CellIdentityID;
	
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
	
	self = [super initWithFrame:frame collectionViewLayout:layout];
	if (self) {
		CellIdentityID = @"ShopDetailedCollectionCellID";

		self.backgroundColor = [UIColor whiteColor];
		self.dataSource = self;
		self.delegate = self;
		[self registerNib:[UINib nibWithNibName:@"ShopDetailedCollectionCell" bundle:nil] forCellWithReuseIdentifier:CellIdentityID];
		
	}
	return self;
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
	
	return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
	ShopDetailedCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentityID forIndexPath:indexPath];
	cell.dic = self.dataArray[indexPath.row];
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
	
	SupermarketHomeMostFreshData *data = _dataArray[indexPath.item];
	GoodsDetailController *vc = [GoodsDetailController new];
	vc.item_code = data.item_code;
	[self.viewController.navigationController pushViewController:vc animated:YES];
	
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
				  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	float width = (SCREEN_WIDTH)/2-5;
	float height = width ;
	
	return CGSizeMake(width, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
	return 6;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
	return 6;
}

-(void)setDataArray:(NSArray *)dataArray{
	_dataArray = dataArray;
	CGRect frams = self.frame;
	frams.size.height = floorf(_dataArray.count/2.0f) *(APPScreenWidth/2 - 5);
	self.frame = frams;
													
	[self reloadData];
}


@end
