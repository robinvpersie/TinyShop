//
//  GroomCollectionView.m
//  Portal
//
//  Created by dlwpdlr on 2018/5/25.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "FavCollectionView.h"
#import "TSCategoryController.h"

@implementation FavCollectionView
- (instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		
		[self createCollectionview];
	}
	return self;
}
- (void)layoutSubviews{
	[super layoutSubviews];
	self.collectionview.layer.backgroundColor = [UIColor whiteColor].CGColor;
}
- (void)createCollectionview{
	if (self.collectionview == nil) {
		UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
		layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		self.collectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH , self.frame.size.height) collectionViewLayout:layout];
		[self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellID"];
		self.collectionview.showsVerticalScrollIndicator = NO;
		self.collectionview.showsHorizontalScrollIndicator = NO;
		self.collectionview.delegate = self;
		self.collectionview.dataSource = self;
		[self addSubview:self.collectionview];
	}
}
#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
	
	return _datas.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
	
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCellID" forIndexPath:indexPath];
	cell.contentView.backgroundColor = [UIColor whiteColor];
	UIImageView *groomImg = [UIImageView new];
	NSDictionary *dic = _datas[indexPath.row];
	[groomImg sd_setImageWithURL:[NSURL URLWithString: dic[@"image_url"]]];
	[cell.contentView addSubview:groomImg];
	[groomImg mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(cell.contentView).offset(2);
	}];
	
	return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
	
	NSDictionary *dic = _datas[indexPath.row];
	TSCategoryController *cateVC = [[TSCategoryController alloc]init];
	cateVC.hidesBottomBarWhenPushed = YES;
	cateVC.leves = @[dic[@"level1"],@"1",@"1"].mutableCopy;
	[self.viewController.navigationController pushViewController:cateVC animated:YES];
	
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
				  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	float width = self.frame.size.height;
	float height = width ;
	return CGSizeMake(width, height);
	
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
	return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
	return 0;
}


@end
