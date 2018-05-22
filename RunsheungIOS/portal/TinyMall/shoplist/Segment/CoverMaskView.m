//
//  CoverMaskView.m
//  Portal
//
//  Created by dlwpdlr on 2018/5/21.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "CoverMaskView.h"

@implementation CoverMaskView

- (instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		self.userInteractionEnabled = YES;
		[self createsubviews];
		
	}
	return self;
}

- (void)setData:(NSArray *)data{
	_data = data;
	CGRect frams = self.collectionview.frame;
	frams.size.height = 80*ceil(_data.count/2.0f)>SCREEN_HEIGHT-184?SCREEN_HEIGHT-184:80*ceil(_data.count/2.0f);
	self.collectionview.frame = frams;
	[self.collectionview reloadData];
	
}

- (void)createsubviews{
	if (self.collectionview == nil) {
		
		UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
		layout.scrollDirection = UICollectionViewScrollDirectionVertical;
		self.collectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,0) collectionViewLayout:layout];
		self.collectionview.backgroundColor = [UIColor whiteColor];
		[self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellID"];
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
	
	return ((_data.count+1)%2==0)?_data.count+1:_data.count+2;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCellID" forIndexPath:indexPath];
	cell.contentView.backgroundColor = RGB(242, 244, 246);
	
	if (indexPath.row<(_data.count+1)) {
		
		UIButton *bg_cell = [[UIButton alloc]initWithFrame:CGRectMake(indexPath.row%2==0?20:10, 10,SCREEN_WIDTH/2- 30 , 60 )];
		bg_cell.layer.cornerRadius = 5;
		bg_cell.layer.masksToBounds = YES;
		bg_cell.backgroundColor = [UIColor whiteColor];
		bg_cell.tag = indexPath.row;
		
		
		if (indexPath.row == 0) {
			
			bg_cell.layer.borderColor = [UIColor greenColor].CGColor;
			bg_cell.layer.borderWidth = 1;
			UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 30, 30)];
			[icon setImage:[UIImage imageNamed:@"icon_all"]];
			[bg_cell addSubview:icon];
			
			UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+6, 20, 100, 20)];
			title.text = @"全部";
			title.font = [UIFont systemFontOfSize:15];
			[bg_cell addSubview:title];
			
		}else{
			
			NSDictionary *dic = self.data[indexPath.row-1];
			UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 30, 30)];
			[icon sd_setImageWithURL:[NSURL URLWithString:dic[@"image_url"]]];
			[bg_cell addSubview:icon];
			
			UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+6, 20, 100, 20)];
			title.text = dic[@"lev_name"];
			title.font = [UIFont systemFontOfSize:15];
			[bg_cell addSubview:title];
			
		}
		[bg_cell addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
		[cell.contentView addSubview:bg_cell];
		
		
		
	}
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
				  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	float width = self.frame.size.width/2.0f;
	float height = 80.0f;
	return CGSizeMake(width, height);
	
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
	return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
	return 0;
}

- (void)action:(UIButton*)sender{
	if ([self.sxdegate respondsToSelector:@selector(clickSaixuan:)]) {
		[self.sxdegate clickSaixuan:(int)sender.tag];
	}
	
}


@end
