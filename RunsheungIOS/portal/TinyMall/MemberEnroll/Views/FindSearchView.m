
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
	
	UIView *backview1 = [UIView new];
	backview1.backgroundColor = [UIColor whiteColor];
	[self addSubview:backview1];
	[backview1 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.top.mas_equalTo(20);
		make.width.mas_equalTo(80);
		make.height.mas_equalTo(40);
	}];
	
	UILabel *locationName = [UILabel new];
	locationName.text = @"단체명";
	[backview1 addSubview:locationName];
	[locationName mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.leading.equalTo(@5);
		make.bottom.mas_equalTo(-5);
		make.width.equalTo(@55);
		
	}];

	UIButton *locationarrow = [UIButton new];
	[locationarrow setImage:[UIImage imageNamed:@"icon_arrow_bottom"] forState:UIControlStateNormal];
	[backview1 addSubview:locationarrow];
	[locationarrow mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(locationName.mas_trailing);
		make.trailing.mas_equalTo(-5);
		make.bottom.mas_equalTo(-10);
		make.top.mas_equalTo(10);
	}];

	UIView *backview2 = [UIView new];
	backview2.backgroundColor = [UIColor whiteColor];
	[self addSubview:backview2];
	[backview2 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(backview1.mas_trailing).offset(10);
		make.top.bottom.mas_equalTo(backview1);
		make.trailing.mas_equalTo(-20);
	}];

	UITextField *searchfield = [UITextField new];
	searchfield.returnKeyType = UIReturnKeySearch;
	searchfield.placeholder = @"검색어를 입력해 주세요";
	searchfield.tintColor = RGB(132, 251, 232);
	[backview2 addSubview:searchfield];
	[searchfield mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.top.equalTo(@10);
		make.trailing.equalTo(@40);
		make.bottom.mas_equalTo(-10);
		
	}];

	UIButton *searchIcon = [UIButton new];
	[searchIcon setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
	[backview2 addSubview:searchIcon];
	[searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
		make.trailing.mas_equalTo(-5);
		make.top.mas_equalTo(5);
		make.width.height.mas_equalTo(30);
	}];

}
@end
