//
//  TinyShopDetailedView.m
//  Portal
//
//  Created by dlwpdlr on 2018/3/20.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "TinyShopDetailedView.h"

@implementation TinyShopDetailedView

- (instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		
	}
	return self;
}
- (void)setDic:(NSDictionary *)dic{
	_dic = dic;
	[self createSubviews];
}

- (void)createSubviews{
	
	self.backgroundColor = [UIColor whiteColor];
	self.layer.borderColor = RGB(221, 221, 221).CGColor;
	self.layer.borderWidth = 1;
	//文字显示
	NSArray *showtitles = @[_dic[@"score"],@"최근리뷰",@"사장님댓글",@"거리"];
	NSArray *showtext = @[_dic[@"sale_custom_cnt"],_dic[@"cnt"],[NSString stringWithFormat:@"%@km",_dic[@"distance"]]];
	for (int i = 0;i<showtitles.count;i++) {
		NSString *title = showtitles[i];
		if (i == 0) {
		
			UILabel *lbl = [self createwithtext:title withframe:CGRectZero withfont:34 withtextColor:RGB(198, 0, 18)];
			[self addSubview:lbl];
			[lbl mas_makeConstraints:^(MASConstraintMaker *make) {
				make.leading.mas_equalTo(i*SCREEN_WIDTH/4);
				make.top.mas_equalTo(10);
				make.width.mas_equalTo(SCREEN_WIDTH/4);
				make.height.mas_equalTo(30);
			}];
			
			UIView *starView = [UIView new];
			[self addSubview:starView];
			[starView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.leading.mas_equalTo(SCREEN_WIDTH/8- 35);
				make.top.mas_equalTo(lbl.mas_bottom).offset(13);
				make.width.mas_equalTo(70);
				make.height.mas_equalTo(14);
			}];
			[self createStarScore:[_dic[@"score"] floatValue] withSuperView:starView];
			
		}else{

			UILabel *lbl = [self createwithtext:title withframe:CGRectZero withfont:15 withtextColor:RGB(178, 178, 178)];
			[self addSubview:lbl];
			[lbl mas_makeConstraints:^(MASConstraintMaker *make) {
				make.leading.mas_equalTo(i*SCREEN_WIDTH/4);
				make.top.mas_equalTo(5);
				make.width.mas_equalTo(SCREEN_WIDTH/4);
				make.height.mas_equalTo(30);
			}];
			
			NSString *text = showtext[i-1];
			UILabel *lbl1 = [self createwithtext:text withframe:CGRectZero withfont:15 withtextColor:RGB(15, 15, 15)];
			[self addSubview:lbl1];
			[lbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
				make.leading.mas_equalTo(i*SCREEN_WIDTH/4);
				make.top.mas_equalTo(lbl.mas_bottom).offset(10);
				make.width.mas_equalTo(lbl.mas_width);
				make.height.mas_equalTo(lbl.mas_height);
			}];
			
			
			
			
			
		}
	}
	
	NSArray *btnarray = @[@"메뉴",@"정보"];
	UIButton *leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
	leftbtn.selected = YES;
	leftbtn.tag= 0;
	leftbtn.layer.borderColor = RGB(221, 221, 221).CGColor;
	leftbtn.layer.borderWidth = 1.0f;
	[leftbtn setTitleColor:RGB(198, 0, 18) forState:UIControlStateSelected];
	[leftbtn setTitleColor:RGB(15, 15, 15) forState:UIControlStateNormal];
	[leftbtn setTitle:btnarray.firstObject forState:UIControlStateNormal];
	[leftbtn setBackgroundImage:[UIImage imageNamed:@"selectbox_round"] forState:UIControlStateSelected];
	[leftbtn setBackgroundImage:[UIImage imageNamed:@"bullet_grey"] forState:UIControlStateNormal];
	[leftbtn addTarget:self action:@selector(selectionAction:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:leftbtn];
	[leftbtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.mas_bottom);
		make.leading.mas_equalTo(30);
		make.height.mas_equalTo(30);
		make.trailing.mas_equalTo(self.mas_centerX).offset(-5);
		
	}];
	
	UIButton *rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
	rightbtn.tag= 1;
	rightbtn.layer.borderColor = RGB(221, 221, 221).CGColor;
	rightbtn.layer.borderWidth = 1.0f;
	[rightbtn setTitleColor:RGB(198, 0, 18) forState:UIControlStateSelected];
	[rightbtn setTitleColor:RGB(15, 15, 15) forState:UIControlStateNormal];
	[rightbtn setTitle:btnarray.lastObject forState:UIControlStateNormal];
	[rightbtn setBackgroundImage:[UIImage imageNamed:@"selectbox_round"] forState:UIControlStateSelected];
	[rightbtn setBackgroundImage:[UIImage imageNamed:@"bullet_grey"] forState:UIControlStateNormal];
	[rightbtn addTarget:self action:@selector(selectionAction:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:rightbtn];
	[rightbtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.mas_bottom);
		make.trailing.mas_equalTo(self.mas_trailing).offset(-30);
		make.height.mas_equalTo(leftbtn.mas_height);
		make.leading.mas_equalTo(self.mas_centerX).offset(5);
		
	}];

}
- (void)selectionAction:(UIButton*)sender{
	
	NSArray *subviews = [self subviews];
	for (int i = 0; i<subviews.count; i ++) {
		id viewss = subviews[i];
		if ([viewss isMemberOfClass:[UIButton class]]) {
			UIButton *but = (UIButton*)viewss;
			but.selected = NO;
		}
	}
	
	sender.selected = !sender.selected;
	
	if ([self.delegete respondsToSelector:@selector(clickSegment:)]) {
		[self.delegete clickSegment:(int)sender.tag];
	}
	
	
	
}



- (void)createStarScore:(CGFloat)starValue withSuperView:(UIView*)superview {
	CGFloat scale = starValue/5.0f;
	
	UIView *starViewdefault =[UIView new];
	[self addSubview:starViewdefault ];
	[starViewdefault mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.top.equalTo(self);
		make.width.mas_equalTo(70);
		make.height.mas_equalTo(14);
	}];

	for (int i = 0; i<5; i++) {
		UIImageView*star = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_star_default_8"]];
		[superview addSubview:star];
		[star mas_makeConstraints:^(MASConstraintMaker *make) {
			make.leading.mas_equalTo(i*15);
			make.height.width.mas_equalTo(10);
			make.top.mas_equalTo(superview.mas_top).offset(2);
		}];
		
	}
		
	UIView *starViewyellow =[UIView new];
	starViewyellow.layer.masksToBounds = YES;
	[superview addSubview:starViewyellow ];
	[starViewyellow mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.top.equalTo(superview);
		make.width.mas_equalTo(70 *scale);
		make.height.mas_equalTo(14);
	}];
	for (int i = 0; i<5; i++) {
		UIImageView*star = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_star_yellow_8"]];
		[starViewyellow addSubview:star];
		[star mas_makeConstraints:^(MASConstraintMaker *make) {
			make.leading.mas_equalTo(i*15);
			make.height.width.mas_equalTo(10);
			make.top.mas_equalTo(superview.mas_top).offset(2);
		}];

	}
	

	
}

- (UILabel*)createwithtext:(NSString *)text  withframe:(CGRect)frame withfont:(CGFloat)font withtextColor:(UIColor*)textColor{
	UILabel *label = [[UILabel alloc]initWithFrame:frame];
	label.font = [UIFont systemFontOfSize:font];
	label.text = text;
	label.textAlignment = NSTextAlignmentCenter;
	label.textColor = textColor;
	
	return label;
}

@end

