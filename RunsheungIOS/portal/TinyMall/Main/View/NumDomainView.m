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
		self.backgroundColor = [UIColor colorWithRed:60/255.0f green:60/255.0f blue:60/255.0f alpha:1.0f];
		[self createPickerviews];
		[self createCollectViews];
		
	}
	return self;
}
#pragma mark -- 创建UIPickerView

- (void)createPickerviews{
	
	self.pickbackImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dial_num"]];
	self.pickbackImg.userInteractionEnabled = YES;
	self.pickbackImg.image = [UIImage imageNamed:@"dial_num"];
	[self addSubview:self.pickbackImg];
	const double width = self.frame.size.width - ScrollviewHeight;
	[self.pickbackImg mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.equalTo(@60);
		make.leading.equalTo(@15);
		make.top.equalTo(self.mas_top);
		make.width.mas_equalTo(width);
	} ];
	

	UIButton *ok = [UIButton buttonWithType:UIButtonTypeCustom];
	[ok setTitle:@"선택" forState:UIControlStateNormal];
	[ok.titleLabel setFont:[UIFont systemFontOfSize:15]];
	[ok setBackgroundImage:[UIImage imageNamed:@"dial_btn"] forState:UIControlStateNormal];
	[ok setTitleColor:[UIColor colorWithRed:38/255.0f green:199/255.0f blue:48/255.0f alpha:1.0f] forState:UIControlStateNormal];
	ok.layer.cornerRadius = 5;
	ok.layer.masksToBounds = YES;
	[ok addTarget:self action:@selector(okAction:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:ok];
	[ok mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.bottom.mas_equalTo(self.pickbackImg);
		make.leading.mas_equalTo(self.pickbackImg.mas_trailing);
		make.trailing.mas_equalTo(-8);
	}];
	
	self.BigCategoresArray= @[@"음식",@"미용",@"재래시장",@"숙박",@"오락",@"인테리어",@"제과제빵",@"레저스포츠",@"학원",@"애완동물",@"음악",@"컴퓨터",@"음식",@"취미",@"컴퓨터",@"보건소"];
//    self.BigCategoresArray= @[@"음식",@"미용",@"여행",@"금융",@"건강",@"취미",@"쇼핑",@"컴퓨터"];
	self.BigCategoresImgs = @[@"m_icon15",@"m_icon16",@"m_icon14",@"m_icon02",@"m_icon13",@"m_icon03",@"m_icon06",@"m_icon04",@"m_icon09",@"m_icon08",@"m_icon10",@"m_icon07"];
	self.showColors = @[RGB(255, 86, 100),RGB(220, 211, 57),RGB(62, 220, 108),RGB(37, 126, 220),RGB(10, 34, 60)];
	self.pickerNumbers = @[@"1", @"2", @"3",@"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16"];
	
//	for (int i = 0; i<4; i++) {
//		UIPickerView *pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(i*(CGFloat)CGRectGetWidth(pickbackImg.frame)/5.5,0, (CGFloat)CGRectGetWidth(pickbackImg.frame)/5.5, 60)];
//		pickView.dataSource = self;
//		pickView.delegate = self;
//		pickView.tag = i;
//		[pickbackImg addSubview:pickView];
//	}
	
	self.fieldArray = [NSMutableArray array];
	for (int j= 0; j<5; j++) {
		
		UITextField *inputview = [UITextField new];
		inputview.textColor = self.showColors[j];
		inputview.textAlignment = NSTextAlignmentCenter;
		inputview.font = [UIFont systemFontOfSize:20 weight:1.2f];
		inputview.returnKeyType = UIReturnKeyDone;
		inputview.delegate = self;
		inputview.tag = j;
		inputview.tintColor = self.showColors[j];
        
		inputview.keyboardType =  UIKeyboardTypeNumberPad;
		inputview.text = [NSString stringWithFormat:@"%d",self.pickerIndex1];
		[self.pickbackImg addSubview:inputview];
		[self.fieldArray addObject:inputview];
		[inputview mas_makeConstraints:^(MASConstraintMaker *make) {
			make.leading.mas_equalTo(j*width/5.5);
			make.top.mas_equalTo(0);
			make.width.mas_equalTo((j<4?(width/5.5):1.5*width/5.5));
			make.height.mas_equalTo(60);
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

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
	
	UILabel *label = [[UILabel alloc] init];
	label.text = [NSString stringWithFormat:@"%d",(int)row+1];
	label.textAlignment= NSTextAlignmentCenter;
	label.font = [UIFont systemFontOfSize:20 weight:1.2f];
	label.textColor = self.showColors[pickerView.tag];
	[[pickerView.subviews objectAtIndex:1] setHidden:TRUE];
	[[pickerView.subviews objectAtIndex:2] setHidden:TRUE];
	return label;
	
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
	
	[self endEditing:NO];
    
	TSCategoryController *cateVC = [[TSCategoryController alloc]init];
	cateVC.hidesBottomBarWhenPushed = YES;
	cateVC.leves = @[[NSString stringWithFormat:@"%d",self.pickerIndex1],[NSString stringWithFormat:@"%d",self.pickerIndex2],[NSString stringWithFormat:@"%d",self.pickerIndex3]].mutableCopy;
	[self.viewController.navigationController pushViewController:cateVC animated:YES];
		
	
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
//        [self addSubview:self.topLandScopeCollectView];
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
//        [self addSubview:self.bottomLandScopeCollectView];
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
//        [self addSubview:self.leftPortraitCollectView];
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
//        [self addSubview:self.rightPortraitCollectView];
    }

	if (self.centerShowCollectView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.centerShowCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, 3 * ScrollviewHeight) collectionViewLayout:layout];
        self.centerShowCollectView.tag = centerScrollViewTag;
        [self.centerShowCollectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellID"];
        self.centerShowCollectView.showsVerticalScrollIndicator = NO;
        self.centerShowCollectView.showsHorizontalScrollIndicator = NO;
        self.centerShowCollectView.delegate = self;
        self.centerShowCollectView.dataSource = self;
        self.centerShowCollectView.backgroundColor = [UIColor colorWithRed:60/255.0f green:60/255.0f blue:60/255.0f alpha:1.0f];
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
	if (collectionView.tag == topLandScropeTag || collectionView.tag == bottomLandScropeTag) {
		return 16;
	}else if (collectionView.tag == leftPortraitTag || collectionView.tag == rightPortraitTag){
		return 10;
	}
//    return 16;
    //return self.BigCategoresArray.count;
    return self.BigCategoresImgs.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
	

	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCellID" forIndexPath:indexPath];
	for (UIView *view in cell.contentView.subviews)
	{
		[view removeFromSuperview];
	}
    
//    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, ScrollviewHeight - 30, ScrollviewHeight - 30)];
//    title.font = [UIFont systemFontOfSize:20];
//    title.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
//    title.layer.cornerRadius = (ScrollviewHeight - 30)/2;
//    title.textColor = UIColor.whiteColor;
//    title.textAlignment = NSTextAlignmentCenter;
//    [cell.contentView addSubview:title];

    
    NSString *topImgNamed;
	if (collectionView.tag == topLandScropeTag) {
        //title.layer.backgroundColor = self.showColors[0].CGColor;
        if (indexPath.row < 9) {
            topImgNamed = [NSString stringWithFormat:@"top_r0%d.png",(int)indexPath.row+1];
        }else{
            topImgNamed = [NSString stringWithFormat:@"top_r%d.png",(int)indexPath.row+1];
        }

    } else if (collectionView.tag == leftPortraitTag) {
//        title.layer.backgroundColor = self.showColors[1].CGColor;
        
    } else if (collectionView.tag == rightPortraitTag) {
//        title.layer.backgroundColor = self.showColors[3].CGColor;
        
    } else if(collectionView.tag == bottomLandScropeTag){
//        title.layer.backgroundColor = self.showColors[2].CGColor;
//        if (indexPath.row < 9) {
//            topImgNamed = [NSString stringWithFormat:@"left_r0%d.png",(int)indexPath.row+1];
//        }else{
//            topImgNamed = [NSString stringWithFormat:@"left_r%d.png",(int)indexPath.row+1];
//        }

	}else{
//        title.layer.backgroundColor = self.showColors[4].CGColor;
        if ((int)indexPath.row < 9) {
            topImgNamed = [NSString stringWithFormat:@"m_icon0%d.png",(int)indexPath.row+1];
        }else{
            topImgNamed = [NSString stringWithFormat:@"m_icon%d.png", (int)indexPath.row+1];
        }
//        topImgNamed = self.BigCategoresImgs[indexPath.row];
	}
    UIImageView *numberImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:self.BigCategoresImgs[indexPath.row]]];
    numberImg.frame = CGRectMake(15, 8, ScrollviewHeight-30, ScrollviewHeight-30);
    [cell.contentView addSubview:numberImg];

    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(numberImg.frame)+3, ScrollviewHeight, 15)];
    title.text = self.BigCategoresArray[indexPath.row];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:title];
	
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (collectionView.tag == topLandScropeTag) {
//        UITextField *top = self.fieldArray[0];
//        top.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
//    } else if (collectionView.tag == leftPortraitTag) {
//        UITextField *left = self.fieldArray[1];
//        left.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
//
//    } else if (collectionView.tag == rightPortraitTag) {
//
//        UITextField *right = self.fieldArray[3];
//        right.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
//
//    } else if (collectionView.tag == bottomLandScropeTag) {
//
//        UITextField *bottom = self.fieldArray[2];
//        bottom.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
//
//    } else {
//
//        UITextField *center = self.fieldArray[4];
//        center.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
//    }

        TSCategoryController *cateVC = [[TSCategoryController alloc]init];
        cateVC.hidesBottomBarWhenPushed = YES;
//        self.pickerIndex1 =(int)indexPath.row+1;
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
        cateVC.leves = @[[NSString stringWithFormat:@"%d",self.pickerIndex1],[NSString stringWithFormat:@"%d",self.pickerIndex2],[NSString stringWithFormat:@"%d",self.pickerIndex3]].mutableCopy;
        [self.viewController.navigationController pushViewController:cateVC animated:YES];
	
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
				  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == centerScrollViewTag) {

        float width = (self.frame.size.width)/4.0f ;
        float height = (self.frame.size.width)/5.0f ;
        return CGSizeMake(width, height);

    }
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


	}
}

@end
