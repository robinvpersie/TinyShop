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
			UILabel *lbl = [self createwithtext:title withframe:CGRectMake(i*SCREEN_WIDTH/4, 10, SCREEN_WIDTH/4, 30) withfont:34 withtextColor:RGB(198, 0, 18)];
			[self addSubview:lbl];
			
			UIView *starView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/8- 35, CGRectGetMaxY(lbl.frame)+ 13, 70, 14)];
			[self addSubview:starView];
			[self createStarScore:[_dic[@"score"] floatValue] withSuperView:starView];
			
		}else{
			UILabel *lbl = [self createwithtext:title withframe:CGRectMake(i*SCREEN_WIDTH/4, 5, SCREEN_WIDTH/4, 30) withfont:15 withtextColor:RGB(178, 178, 178)];
			[self addSubview:lbl];
			
			NSString *text = showtext[i-1];
			UILabel *lbl1 = [self createwithtext:text withframe:CGRectMake(i*SCREEN_WIDTH/4,CGRectGetMaxY(lbl.frame)+ 10, SCREEN_WIDTH/4, 30) withfont:15 withtextColor:RGB(15, 15, 15)];
			[self addSubview:lbl1];
			
			
			
			
		}
	}
	
	//两个按钮
	self.backView = [[UIView alloc]initWithFrame:CGRectMake(0 ,self.frame.size.height - 30, SCREEN_WIDTH, 30)];
	[self addSubview:self.backView];
	
	NSArray *btnarray = @[@"메뉴",@"정보"];
	for (int i = 0; i<btnarray.count; i++) {
		NSString *title = btnarray[i];
		
		UIButton *selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(30+i*(SCREEN_WIDTH/2 -20), 0, (SCREEN_WIDTH-80)/2, 30)];
		if (i == 0) {
			selectBtn.selected = YES;
		}
		[selectBtn setTitle:title forState:UIControlStateNormal];
		selectBtn.tag= i;
		selectBtn.layer.borderColor = RGB(221, 221, 221).CGColor;
		selectBtn.layer.borderWidth = 1.0f;
		[selectBtn setTitleColor:RGB(198, 0, 18) forState:UIControlStateSelected];
		[selectBtn setTitleColor:RGB(15, 15, 15) forState:UIControlStateNormal];
		[selectBtn setBackgroundImage:[UIImage imageNamed:@"selectbox_round"] forState:UIControlStateSelected];
		[selectBtn setBackgroundImage:[UIImage imageNamed:@"bullet_grey"] forState:UIControlStateNormal];
		[selectBtn addTarget:self action:@selector(selectionAction:) forControlEvents:UIControlEventTouchUpInside];
		[self.backView addSubview:selectBtn];
	}
	
}
- (void)selectionAction:(UIButton*)sender{
	
	NSArray *subviews = [self.backView subviews];
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
	
	UIView *starViewdefault =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 70, 14)];
	for (int i = 0; i<5; i++) {
		UIImageView*star = [[UIImageView alloc]initWithFrame:CGRectMake(i*15, 2, 10, 10)];
		star.image =[UIImage imageNamed:@"icon_star_default_8"];
		[superview addSubview:star];
		
	}
	
	[self addSubview:starViewdefault ];
	
	UIView *starViewyellow =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 70 *scale, 14)];
	starViewyellow.layer.masksToBounds = YES;
	for (int i = 0; i<5; i++) {
		UIImageView*star = [[UIImageView alloc]initWithFrame:CGRectMake(i*15, 2, 10, 10)];
		star.image =[UIImage imageNamed:@"icon_star_yellow_8"];
		[starViewyellow addSubview:star];
		
	}
	
	[superview addSubview:starViewyellow ];
	
	
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

