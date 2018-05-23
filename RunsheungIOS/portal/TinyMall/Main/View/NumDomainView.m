//
//  NumDomainView.m
//  demo
//
//  Created by dlwpdlr on 2018/3/21.
//  Copyright © 2018年 wangchengshan. All rights reserved.
//

#import "NumDomainView.h"
#import "TSCategoryController.h"
#import <AFNetworking/AFNetworking.h>
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
		self.backgroundColor = RGB(242, 244, 246);
		[self createPickerviews];
		[self createCollectViews];
		
	}
	return self;
}
#pragma mark -- 创建UIPickerView

- (void)createPickerviews{
	
	
	self.inputBg = [UIView new];
	self.inputBg.backgroundColor = [UIColor whiteColor];
	self.inputBg.layer.cornerRadius = 5;
	self.inputBg.layer.masksToBounds = YES;
	[self addSubview:self.inputBg];
	[self.inputBg mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.mas_equalTo(60);
		make.leading.equalTo(@15);
		make.top.equalTo(self.mas_top).offset(10);
		make.width.mas_equalTo(SCREEN_WIDTH - 30);
	}];
	
	const double width = self.frame.size.width - ScrollviewHeight;
	UIButton *ok = [UIButton buttonWithType:UIButtonTypeCustom];
	[ok setTitle:@"선택" forState:UIControlStateNormal];
	[ok.titleLabel setFont:[UIFont systemFontOfSize:15]];
	[ok setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	ok.backgroundColor = RGB(0, 128, 64);
	ok.layer.cornerRadius = 4;
	ok.layer.masksToBounds = YES;
	[ok addTarget:self action:@selector(okAction:) forControlEvents:UIControlEventTouchUpInside];
	[self.inputBg addSubview:ok];
	[ok mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(10);
		make.trailing.mas_equalTo(-10);
		make.width.mas_equalTo(ScrollviewHeight-20);
		make.height.mas_equalTo(40);
		
	}];
	
	self.BigCategoresArray= @[@"음식",@"재래시장",@"여행/레저",@"가정,생활",@"건축,인테리어",@"교육,취업",@"교통,이사",@"부동산",@"미용,패션",@"법률,회계",@"쇼핑,이벤트",@"광고,출판",@"건강,의료",@"취미,오락",@"컴퓨터,정보통신"];
	self.showColors = @[RGB(255, 86, 100),RGB(220, 211, 57),RGB(62, 220, 108),RGB(37, 126, 220),RGB(10, 34, 60)];
	
	self.fieldArray = [NSMutableArray array];
	for (int j= 0; j<5; j++) {
		UIView *sigleview = [UIView new];
		[self.inputBg addSubview:sigleview];
		[sigleview mas_makeConstraints:^(MASConstraintMaker *make) {
			make.leading.mas_equalTo(j*width/5.5);
			make.top.mas_equalTo(0);
			make.width.mas_equalTo((j<4?(width/5.5):1.5*width/5.5));
			make.height.mas_equalTo(60);
		}];
		
		UITextField *inputview = [UITextField new];
		inputview.textColor = self.showColors[j];
		inputview.textAlignment = NSTextAlignmentCenter;
		inputview.font = [UIFont systemFontOfSize:20 weight:1.2f];
		inputview.returnKeyType = UIReturnKeyDone;
		inputview.delegate = self;
		inputview.tag = j;
		inputview.backgroundColor = RGB(242, 244, 246);
		inputview.layer.cornerRadius = 3;
		inputview.layer.masksToBounds = YES;
		inputview.tintColor = self.showColors[j];
		
		inputview.keyboardType =  UIKeyboardTypeNumberPad;
		inputview.text = [NSString stringWithFormat:@"%d",self.pickerIndex1];
		[sigleview addSubview:inputview];
		[self.fieldArray addObject:inputview];
		[inputview mas_makeConstraints:^(MASConstraintMaker *make) {
			make.leading.top.mas_equalTo(10);
			make.bottom.mas_equalTo(-10);
			make.width.mas_equalTo(@40);
		}];
	}
	
	
	
}

#pragma mark --- 代理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
	
	if (textField.text.length > 1) {
		textField.text = [textField.text substringToIndex:1];
	}
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
	switch (textField.tag) {
		case 0:
		{
			self.pickerIndex1 = [textField.text intValue];
		}
			break;
		case 1:
		{
			self.pickerIndex2 = [textField.text intValue];
		}
			break;
			
		case 2:
		{
			self.pickerIndex3 = [textField.text intValue];
		}
			break;
			
			
		default:
			break;
	}
	
	
}


- (void)okAction:(UIButton*)sender{
	
	[self endEditing:NO];
	
	TSCategoryController *cateVC = [[TSCategoryController alloc]init];
	cateVC.hidesBottomBarWhenPushed = YES;
	cateVC.leves = @[[NSString stringWithFormat:@"%d",self.pickerIndex1],[NSString stringWithFormat:@"%d",self.pickerIndex2],[NSString stringWithFormat:@"%d",self.pickerIndex3]].mutableCopy;
	[self.viewController.navigationController pushViewController:cateVC animated:YES];
	
	
}
- (void)layoutSubviews{
	[super layoutSubviews];
	self.topLandScopeCollectView.layer.backgroundColor = [UIColor whiteColor].CGColor;
	self.leftPortraitCollectView.layer.backgroundColor = [UIColor whiteColor].CGColor;
	self.rightPortraitCollectView.layer.backgroundColor = [UIColor whiteColor].CGColor;
	self.bottomLandScopeCollectView.layer.backgroundColor = [UIColor whiteColor].CGColor;
	self.centerShowCollectView.layer.backgroundColor = [UIColor whiteColor].CGColor;


}

#pragma mark --- 创建上下左右滑动视图
/**
 *创建上下左右滑动视图
 */
- (void)createCollectViews{
	
	if (self.topLandScopeCollectView == nil) {
		UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
		layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		self.topLandScopeCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 90, ScrollviewHeight*5, ScrollviewHeight) collectionViewLayout:layout];
		self.topLandScopeCollectView.tag = topLandScropeTag;
		[self.topLandScopeCollectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellID"];
		self.topLandScopeCollectView.showsVerticalScrollIndicator = NO;
		self.topLandScopeCollectView.showsHorizontalScrollIndicator = NO;
		self.topLandScopeCollectView.delegate = self;
		self.topLandScopeCollectView.dataSource = self;
		self.topLandScopeCollectView.backgroundColor = [UIColor colorWithRed:60/255.0f green:60/255.0f blue:60/255.0f alpha:1.0f];
		[self addSubview:self.topLandScopeCollectView];
	}
	
	
	if (self.leftPortraitCollectView == nil) {
		UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
		layout.scrollDirection = UICollectionViewScrollDirectionVertical;
		self.leftPortraitCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.topLandScopeCollectView.frame), ScrollviewHeight, 3*ScrollviewHeight) collectionViewLayout:layout];
		self.leftPortraitCollectView.tag = leftPortraitTag;
		[self.leftPortraitCollectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellID"];

		self.leftPortraitCollectView.showsVerticalScrollIndicator = NO;
		self.leftPortraitCollectView.showsHorizontalScrollIndicator = NO;
		self.leftPortraitCollectView.delegate = self;
		self.leftPortraitCollectView.dataSource = self;
		self.leftPortraitCollectView.backgroundColor = [UIColor colorWithRed:60/255.0f green:60/255.0f blue:60/255.0f alpha:1.0f];
		[self addSubview:self.leftPortraitCollectView];
	}
	if (self.bottomLandScopeCollectView == nil) {
		UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
		layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		self.bottomLandScopeCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.leftPortraitCollectView.frame), ScrollviewHeight*5, ScrollviewHeight) collectionViewLayout:layout];
		self.bottomLandScopeCollectView.tag = bottomLandScropeTag;
		[self.bottomLandScopeCollectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellID"];
		self.bottomLandScopeCollectView.showsVerticalScrollIndicator = NO;
		self.bottomLandScopeCollectView.showsHorizontalScrollIndicator = NO;
		self.bottomLandScopeCollectView.delegate = self;
		self.bottomLandScopeCollectView.dataSource = self;
		self.bottomLandScopeCollectView.backgroundColor = [UIColor colorWithRed:60/255.0f green:60/255.0f blue:60/255.0f alpha:1.0f];
		[self addSubview:self.bottomLandScopeCollectView];
	}
	
	if (self.rightPortraitCollectView == nil) {
		
		
		UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
		layout.scrollDirection = UICollectionViewScrollDirectionVertical;
		self.rightPortraitCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(self.frame.size.width - ScrollviewHeight,CGRectGetMaxY(self.topLandScopeCollectView.frame), ScrollviewHeight,3* ScrollviewHeight) collectionViewLayout:layout];
		self.rightPortraitCollectView.tag = rightPortraitTag;
		[self.rightPortraitCollectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellID"];
		self.rightPortraitCollectView.showsVerticalScrollIndicator = NO;
		self.rightPortraitCollectView.showsHorizontalScrollIndicator = NO;
		self.rightPortraitCollectView.delegate = self;
		self.rightPortraitCollectView.dataSource = self;
		self.rightPortraitCollectView.backgroundColor = [UIColor colorWithRed:60/255.0f green:60/255.0f blue:60/255.0f alpha:1.0f];
		[self addSubview:self.rightPortraitCollectView];
	}
	
	if (self.centerShowCollectView == nil) {
		
		UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
		layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		
		self.centerShowCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(ScrollviewHeight, CGRectGetMaxY(self.topLandScopeCollectView.frame), 3*(SCREEN_WIDTH ) / 5.0 , 3*(SCREEN_WIDTH )/5.0) collectionViewLayout:layout];
		self.centerShowCollectView.layer.cornerRadius = 5;
		self.centerShowCollectView.layer.masksToBounds = YES;
		self.centerShowCollectView.tag = centerScrollViewTag;
		[self.centerShowCollectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellID"];
		self.centerShowCollectView.showsVerticalScrollIndicator = NO;
		self.centerShowCollectView.showsHorizontalScrollIndicator = NO;
		self.centerShowCollectView.delegate = self;
		self.centerShowCollectView.dataSource = self;
		[self addSubview:self.centerShowCollectView];
	}
	
}

-(void)request {
	AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
	manger.requestSerializer = [AFJSONRequestSerializer serializer];
	manger.responseSerializer = [AFJSONResponseSerializer serializer];
	
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:@"kor" forKey:@"lang_type"];
	[parameters setObject:@"" forKey:@"memid"];
	[parameters setObject:@"" forKey:@"token"];
	[parameters setObject:self.fieldArray[0].text forKey:@"t_num"];
	[parameters setObject:self.fieldArray[1].text forKey:@"l_num"];
	[parameters setObject:self.fieldArray[2] forKey:@"r_num"];
	[parameters setObject:self.fieldArray[3] forKey:@"b_num"];
	[parameters setObject:@"www" forKey:@"visit_sub_domain"];
	[parameters setObject:@"gigaroom.com" forKey:@"visit_domain"];
	
	[manger POST:@"http://apiAD.gigaroom.com:80/api/apiSpecialAD/requestMainInfo" parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
		
	} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSArray *data = responseObject[@"data"];
		[data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			
		}];
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		
	}];
	
}


#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
	if (collectionView.tag == topLandScropeTag || collectionView.tag == bottomLandScropeTag||collectionView.tag == leftPortraitTag || collectionView.tag == rightPortraitTag) {
		return 16;
	}
	
	return self.BigCategoresArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
	
	
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCellID" forIndexPath:indexPath];
	for (UIView *view in cell.contentView.subviews)
	{
		[view removeFromSuperview];
	}
	
	UIView *bg_cell = [[UIView alloc]initWithFrame:CGRectMake(0, 0,ScrollviewHeight , ScrollviewHeight )];
	bg_cell.backgroundColor = [UIColor whiteColor];
	[cell.contentView addSubview:bg_cell];
	
	NSString *topImgNamed,*centerImgNamed;
	if ((collectionView.tag == topLandScropeTag)) {
		if (indexPath.row < 9) {
			topImgNamed = [NSString stringWithFormat:@"top0%d.png",(int)indexPath.row+1];
		}else{
			topImgNamed = [NSString stringWithFormat:@"top%d.png",(int)indexPath.row+1];
		}
		UIImageView *numberImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:topImgNamed]];
		numberImg.frame = CGRectMake(15, 15, ScrollviewHeight-30, ScrollviewHeight-30);
		[bg_cell addSubview:numberImg];
		
		
	} else if (collectionView.tag == bottomLandScropeTag) {
		if (indexPath.row < 9) {
			topImgNamed = [NSString stringWithFormat:@"bottom0%d.png",(int)indexPath.row+1];
		}else{
			topImgNamed = [NSString stringWithFormat:@"bottom%d.png",(int)indexPath.row+1];
		}
		UIImageView *numberImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:topImgNamed]];
		numberImg.frame = CGRectMake(15, 15, ScrollviewHeight-30, ScrollviewHeight-30);
		[bg_cell addSubview:numberImg];
		
		
	}
	else if (collectionView.tag == leftPortraitTag) {
		if (indexPath.row < 9) {
			topImgNamed = [NSString stringWithFormat:@"left0%d.png",(int)indexPath.row+1];
		}else{
			topImgNamed = [NSString stringWithFormat:@"left%d.png",(int)indexPath.row+1];
		}
		UIImageView *numberImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:topImgNamed]];
		numberImg.frame = CGRectMake(15, 15, ScrollviewHeight-30, ScrollviewHeight-30);
		[bg_cell addSubview:numberImg];
		
		
	}
	else if (collectionView.tag == rightPortraitTag) {
		if (indexPath.row < 9) {
			topImgNamed = [NSString stringWithFormat:@"right0%d.png",(int)indexPath.row+1];
		}else{
			topImgNamed = [NSString stringWithFormat:@"right%d.png",(int)indexPath.row+1];
		}
		UIImageView *numberImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:topImgNamed]];
		numberImg.frame = CGRectMake(15, 15, ScrollviewHeight-30, ScrollviewHeight-30);
		[bg_cell addSubview:numberImg];
		
		
	}else{
		if ((int)indexPath.row < 9) {
			centerImgNamed = [NSString stringWithFormat:@"icons_0%d_home.png",(int)indexPath.row+1];
		}else{
			centerImgNamed = [NSString stringWithFormat:@"icons_%d_home.png", (int)indexPath.row+1];
		}
		UIImageView *numberImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:centerImgNamed]];
		numberImg.frame = CGRectMake(15, 10, ScrollviewHeight-30, ScrollviewHeight-30);
		[bg_cell addSubview:numberImg];
		
		UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(numberImg.frame)+5, ScrollviewHeight, 10)];
		title.textColor = RGB(60, 60, 60);
		title.text = self.BigCategoresArray[indexPath.row];
		title.textAlignment = NSTextAlignmentCenter;
		title.font = [UIFont systemFontOfSize:12];
		[bg_cell addSubview:title];
		
	}
	
	
	
	
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	
	if (collectionView.tag == topLandScropeTag) {
		UITextField *top = self.fieldArray[0];
		top.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
	} else if (collectionView.tag == leftPortraitTag) {
		UITextField *left = self.fieldArray[1];
		left.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
		
	} else if (collectionView.tag == rightPortraitTag) {
		
		UITextField *right = self.fieldArray[3];
		right.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
		
	} else if (collectionView.tag == bottomLandScropeTag) {
		
		UITextField *bottom = self.fieldArray[2];
		bottom.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
		
	} else {
		
		UITextField *center = self.fieldArray[4];
		center.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
	}
	
	
	switch (indexPath.row) {
		case 0:
			self.pickerIndex1 = 13;
			self.pickerIndex2 = 1;
			self.pickerIndex3 = 1;
			break;
		case 1:
			self.pickerIndex1 = 8;
			self.pickerIndex2 = 1;
			self.pickerIndex3 = 1;
			break;
		case 2:
			self.pickerIndex1 = 1;
			self.pickerIndex2 = 1;
			self.pickerIndex3 = 1;
			break;
		case 3:
			self.pickerIndex1 = 2;
			self.pickerIndex2 = 1;
			self.pickerIndex3 = 1;
			break;
		case 4:
			self.pickerIndex1 = 14;
			self.pickerIndex2 = 1;
			self.pickerIndex3 = 1;
			break;
		case 5:
			self.pickerIndex1 = 4;
			self.pickerIndex2 = 3;
			self.pickerIndex3 = 1;
			break;
		case 6:
			self.pickerIndex1 = 13;
			self.pickerIndex2 = 3;
			self.pickerIndex3 = 1;
			break;
		case 7:
			self.pickerIndex1 = 2;
			self.pickerIndex2 = 2;
			self.pickerIndex3 = 1;
		case 8:
			self.pickerIndex1 = 5;
			self.pickerIndex2 = 2;
			self.pickerIndex3 = 1;
			break;
		case 9:
			self.pickerIndex1 = 14;
			self.pickerIndex2 = 1;
			self.pickerIndex3 = 4;
			break;
		case 10:
			self.pickerIndex1 = 14;
			self.pickerIndex2 = 4;
			self.pickerIndex3 = 1;
			break;
		case 11:
			self.pickerIndex1 = 15;
			self.pickerIndex2 = 1;
			self.pickerIndex3 = 1;
			break;
		default:
			break;
			
	}
	
	if (collectionView.tag == centerScrollViewTag) {
		TSCategoryController *cateVC = [[TSCategoryController alloc]init];
		cateVC.hidesBottomBarWhenPushed = YES;
		cateVC.leves = @[[NSString stringWithFormat:@"%d",self.pickerIndex1],[NSString stringWithFormat:@"%d",self.pickerIndex2],[NSString stringWithFormat:@"%d",self.pickerIndex3]].mutableCopy;
		[self.viewController.navigationController pushViewController:cateVC animated:YES];
		
		
	}
	
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
				  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	float width = (self.frame.size.width)/5.0f ;
	float height =width ;
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
	if (scrollview.tag == topLandScropeTag||scrollview.tag == bottomLandScropeTag) {
		
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
		
		
	}else if (scrollview.tag == centerScrollViewTag){
		
		CGFloat offsetX = scrollview.contentOffset.x;
		CGFloat width = self.frame.size.width/3.0f;
		int index = (offsetX/width);
		int indexNum =((offsetX - index*ScrollviewHeight) > ScrollviewHeight/2.0f)? (index+1):index;
		[UIView animateWithDuration:0.5f animations:^{
			
			scrollview.contentOffset = CGPointMake(indexNum *ScrollviewHeight, 0);
			
		}];

	}

}

@end
