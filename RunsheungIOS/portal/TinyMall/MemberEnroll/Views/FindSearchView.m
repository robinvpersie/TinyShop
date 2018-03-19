
//
//  FindSearchView.m
//  Portal
//
//  Created by dlwpdlr on 2018/3/19.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "FindSearchView.h"

@implementation FindSearchView

- (instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = RGB(132, 251, 232);
		[self initUI];
		
	}
	return self;
}

- (void)initUI{
	
	UIView *bg1 = [[UIView alloc]initWithFrame:CGRectMake(15, 20 , 120, 40)];
	bg1.backgroundColor = [UIColor whiteColor];
	[self addSubview:bg1];
	
	UILabel *locationName = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 40)];
	locationName.text = @"단체명";
	locationName.textAlignment = NSTextAlignmentCenter;
	[bg1 addSubview:locationName];
	
	UIButton *locationarrow = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(bg1.frame)-25, 10, 20, 20)];
	[locationarrow setImage:[UIImage imageNamed:@"icon_arrow_bottom"] forState:UIControlStateNormal];
	[bg1 addSubview:locationarrow];
	
	
	UIView *bg2 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bg1.frame)+10,20 , APPScreenWidth - CGRectGetWidth(bg1.frame) - 30, 40)];
	bg2.backgroundColor = [UIColor whiteColor];
	[self addSubview:bg2];
	
	UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(10, 0,CGRectGetWidth(bg2.frame) - 40, 40)];
	field.placeholder = @"검색어를 입력해 주세요";
	
	[bg2 addSubview:field];
	
	UIButton *search = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(bg2.frame)- 50, 0, 40, 40)];
	[search setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
	[bg2 addSubview:search];

	
	
	
}
@end
