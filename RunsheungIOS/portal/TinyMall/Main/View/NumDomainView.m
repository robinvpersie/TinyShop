//
//  NumDomainView.m
//  demo
//
//  Created by dlwpdlr on 2018/3/21.
//  Copyright © 2018年 wangchengshan. All rights reserved.
//

#import "NumDomainView.h"
#import "TSCategoryController.h"
#import "UIView+ViewController.h"
#define ScrollviewHeight  (self.frame.size.width)/5.0f

#define topLandScropeTag 1001
#define bottomLandScropeTag 1002
#define leftPortraitTag 2001
#define rightPortraitTag 2002

#define centerScrollViewTag 3000

@implementation NumDomainView

- (instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		self.pickerIndex1 = 1;
		self.pickerIndex2 = 1;
		self.pickerIndex3 = 1;
		self.backgroundColor = [UIColor colorWithRed:60/255.0f green:60/255.0f blue:60/255.0f alpha:1.0f];
		[self createPickerviews];
		[self createCollectViews];
		
	}
	return self;
}
#pragma mark -- 创建UIPickerView

- (void)createPickerviews{
	UIImageView*pickbackImg = [[UIImageView alloc]initWithFrame:CGRectMake(8, 0, self.frame.size.width-ScrollviewHeight, 60)];
	pickbackImg.userInteractionEnabled = YES;
	pickbackImg.image = [UIImage imageNamed:@"dial_num"];
	[self addSubview:pickbackImg];
	
	UIButton *ok = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(pickbackImg.frame), 0, self.frame.size.width - CGRectGetMaxX(pickbackImg.frame), 60)];
	[ok setTitle:@"确定" forState:UIControlStateNormal];
	[ok setTitleColor:[UIColor colorWithRed:38/255.0f green:199/255.0f blue:48/255.0f alpha:1.0f] forState:UIControlStateNormal];
	ok.layer.cornerRadius = 5;
	ok.layer.masksToBounds = YES;
	[ok addTarget:self action:@selector(okAction:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:ok];
	
	
	self.pickerNumbers = @[@"1", @"2", @"3",@"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16"];
	for (int i = 0; i<4; i++) {
		UIPickerView *pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(i*(CGFloat)CGRectGetWidth(pickbackImg.frame)/5.5,0, (CGFloat)CGRectGetWidth(pickbackImg.frame)/5.5, 60)];
		pickView.dataSource = self;
		pickView.delegate = self;
		pickView.tag = i;
		[pickbackImg addSubview:pickView];
	}
}

#pragma mark -- UIPickerView代理方法
//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件包含的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
	return 1;
}

//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return self.pickerNumbers.count;
}


// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为UIPickerView
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	
	return [self.pickerNumbers objectAtIndex:row];
}

// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	
	switch (pickerView.tag) {
			
		case 0:
			self.pickerIndex1 = (int)row+1;
			break;
		case 1:
			self.pickerIndex2 = (int)row+1;
			break;
		case 2:
			self.pickerIndex3 = (int)row+1;
			break;
		default:
			break;
	}
	
}
- (void)okAction:(UIButton*)sender{
	
	BOOL islogIn = [YCAccountModel islogin];
	if (islogIn) {
		TSCategoryController *cateVC = [[TSCategoryController alloc]init];
		cateVC.hidesBottomBarWhenPushed = YES;
		cateVC.leves = @[[NSString stringWithFormat:@"%d",self.pickerIndex1],[NSString stringWithFormat:@"%d",self.pickerIndex2],[NSString stringWithFormat:@"%d",self.pickerIndex3]].mutableCopy;
		[self.viewController.navigationController pushViewController:cateVC animated:YES];
		
	}else{
		MemberEnrollController *loginVC = [[MemberEnrollController alloc] init];
		UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
		[self.viewController presentViewController:nav animated:YES completion:nil];
		
	}
	
}

#pragma mark --- 创建上下左右滑动视图
/**
 *创建上下左右滑动视图
 */
- (void)createCollectViews{
	
	
	if (self.topLandScopeCollectView == nil) {
		UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
		layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		self.topLandScopeCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 60, ScrollviewHeight*5, ScrollviewHeight) collectionViewLayout:layout];
		self.topLandScopeCollectView.tag = topLandScropeTag;
		[self.topLandScopeCollectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellID"];
		self.topLandScopeCollectView.showsVerticalScrollIndicator = NO;
		self.topLandScopeCollectView.showsHorizontalScrollIndicator = NO;
		self.topLandScopeCollectView.delegate = self;
		self.topLandScopeCollectView.dataSource = self;
		self.topLandScopeCollectView.backgroundColor = [UIColor colorWithRed:60/255.0f green:60/255.0f blue:60/255.0f alpha:1.0f];
//		[self addSubview:self.topLandScopeCollectView];

	}
	if (self.bottomLandScopeCollectView == nil) {
		UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
		layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		self.bottomLandScopeCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - ScrollviewHeight, ScrollviewHeight*5, ScrollviewHeight) collectionViewLayout:layout];
		self.bottomLandScopeCollectView.tag = bottomLandScropeTag;
		[self.bottomLandScopeCollectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellID"];
		self.bottomLandScopeCollectView.showsVerticalScrollIndicator = NO;
		self.bottomLandScopeCollectView.showsHorizontalScrollIndicator = NO;
		self.bottomLandScopeCollectView.delegate = self;
		self.bottomLandScopeCollectView.dataSource = self;
		self.bottomLandScopeCollectView.backgroundColor = [UIColor colorWithRed:60/255.0f green:60/255.0f blue:60/255.0f alpha:1.0f];
//		[self addSubview:self.bottomLandScopeCollectView];
		
	}
	
	if (self.leftPortraitCollectView == nil) {
		UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
		layout.scrollDirection = UICollectionViewScrollDirectionVertical;
		self.leftPortraitCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, ScrollviewHeight+60, ScrollviewHeight, 3*ScrollviewHeight) collectionViewLayout:layout];
		self.leftPortraitCollectView.tag = leftPortraitTag;
		[self.leftPortraitCollectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellID"];
		self.leftPortraitCollectView.showsVerticalScrollIndicator = NO;
		self.leftPortraitCollectView.showsHorizontalScrollIndicator = NO;
		self.leftPortraitCollectView.delegate = self;
		self.leftPortraitCollectView.dataSource = self;
		self.leftPortraitCollectView.backgroundColor = [UIColor colorWithRed:60/255.0f green:60/255.0f blue:60/255.0f alpha:1.0f];
//		[self addSubview:self.leftPortraitCollectView];
		
	}
	if (self.rightPortraitCollectView == nil) {
		UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
		layout.scrollDirection = UICollectionViewScrollDirectionVertical;
		self.rightPortraitCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(self.frame.size.width - ScrollviewHeight, ScrollviewHeight+60, ScrollviewHeight,3* ScrollviewHeight) collectionViewLayout:layout];
		self.rightPortraitCollectView.tag = rightPortraitTag;
		[self.rightPortraitCollectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellID"];
		self.rightPortraitCollectView.showsVerticalScrollIndicator = NO;
		self.rightPortraitCollectView.showsHorizontalScrollIndicator = NO;
		self.rightPortraitCollectView.delegate = self;
		self.rightPortraitCollectView.dataSource = self;
		self.rightPortraitCollectView.backgroundColor = [UIColor colorWithRed:60/255.0f green:60/255.0f blue:60/255.0f alpha:1.0f];
//		[self addSubview:self.rightPortraitCollectView];
		
	}

	if (self.centerShowCollectView == nil) {
		UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
		layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		self.centerShowCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 60, 5* ScrollviewHeight,3* ScrollviewHeight) collectionViewLayout:layout];
		self.centerShowCollectView.tag = centerScrollViewTag;
		[self.centerShowCollectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellID"];
//		self.centerShowCollectView.scrollEnabled = NO;
		self.centerShowCollectView.showsVerticalScrollIndicator = NO;
		self.centerShowCollectView.showsHorizontalScrollIndicator = NO;
		self.centerShowCollectView.delegate = self;
		self.centerShowCollectView.dataSource = self;
		self.centerShowCollectView.backgroundColor = [UIColor colorWithRed:60/255.0f green:60/255.0f blue:60/255.0f alpha:1.0f];
		[self addSubview:self.centerShowCollectView];
		
	}

}


#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
	
	
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
	if (collectionView.tag == topLandScropeTag||collectionView.tag == bottomLandScropeTag) {
		return 16;
	}else if (collectionView.tag == leftPortraitTag||collectionView.tag == rightPortraitTag){
		return 10;
	}
	return 15;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
	

	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCellID" forIndexPath:indexPath];
	for (UIView *view in cell.contentView.subviews)
	{
		[view removeFromSuperview];
	}
	NSString *topImgNamed;
	if (collectionView.tag == topLandScropeTag||collectionView.tag == bottomLandScropeTag) {
		
		if (indexPath.row < 9) {
			topImgNamed = [NSString stringWithFormat:@"top_r0%d.png",(int)indexPath.row+1];
		}else{
			topImgNamed = [NSString stringWithFormat:@"top_r%d.png",(int)indexPath.row+1];
		}

	}else if(collectionView.tag == leftPortraitTag||collectionView.tag == rightPortraitTag){

		if (indexPath.row < 9) {
			topImgNamed = [NSString stringWithFormat:@"left_r0%d.png",(int)indexPath.row+1];
		}else{
			topImgNamed = [NSString stringWithFormat:@"left_r%d.png",(int)indexPath.row+1];
		}

	}else{
		if ((int)indexPath.row < 9) {
			topImgNamed = [NSString stringWithFormat:@"m_icon0%d.png",(int)indexPath.row+1];
		}else{
			topImgNamed = [NSString stringWithFormat:@"m_icon%d.png", (int)indexPath.row+1];
		}

	}
	UIImageView *numberImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:topImgNamed]];
	numberImg.frame = CGRectMake(8, 8, ScrollviewHeight-16, ScrollviewHeight-16);
	[cell.contentView addSubview:numberImg];
	
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
	BOOL islogIn = [YCAccountModel islogin];
	if (islogIn) {
		TSCategoryController *cateVC = [[TSCategoryController alloc]init];
		cateVC.hidesBottomBarWhenPushed = YES;
		self.pickerIndex1 =(int)indexPath.row+1;
		cateVC.leves = @[[NSString stringWithFormat:@"%d",self.pickerIndex1],[NSString stringWithFormat:@"%d",self.pickerIndex2],[NSString stringWithFormat:@"%d",self.pickerIndex3]].mutableCopy;
		[self.viewController.navigationController pushViewController:cateVC animated:YES];

	}else{
		MemberEnrollController *loginVC = [[MemberEnrollController alloc] init];
		UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
		[self.viewController presentViewController:nav animated:YES completion:nil];

	}
	

	
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
				  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	float width = ScrollviewHeight ;
	float height = width ;
	
	return CGSizeMake(width, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
	return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
	return 0;
}


#pragma mark - scrollView 停止滚动监测
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	// 停止类型1、停止类型2
	BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging &&!scrollView.decelerating;
	if (scrollToScrollStop) {
		[self scrollViewDidEndScroll:scrollView];
	}
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if (!decelerate) {
		// 停止类型3
		BOOL dragToDragStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
		if (dragToDragStop) {
			[self scrollViewDidEndScroll:scrollView];
		}
	}
}

- (void)scrollViewDidEndScroll:(UIScrollView *)scrollview{
	if (scrollview.tag == topLandScropeTag||scrollview.tag == bottomLandScropeTag||scrollview.tag == centerScrollViewTag) {
		
		CGFloat offsetX = scrollview.contentOffset.x;
		CGFloat width = self.frame.size.width/5.0f;
		int index = (offsetX/width);
		int indexNum =((offsetX - index*ScrollviewHeight) > ScrollviewHeight/2.0f)? (index+1):index;
		[UIView animateWithDuration:0.5f animations:^{
			
			scrollview.contentOffset = CGPointMake(indexNum *ScrollviewHeight, 0);

		}];
	
	}else if (scrollview.tag == leftPortraitTag||scrollview.tag == rightPortraitTag){
		
		CGFloat offsetY = scrollview.contentOffset.y;
		CGFloat width = self.frame.size.width/5.0f;
		int index = (offsetY/width);
		int indexNum =((offsetY - index*ScrollviewHeight) > ScrollviewHeight/2.0f)? (index+1):index;
		[UIView animateWithDuration:0.5f animations:^{
			
			scrollview.contentOffset = CGPointMake(0,indexNum *ScrollviewHeight);
			
		}];


	}
}

@end
