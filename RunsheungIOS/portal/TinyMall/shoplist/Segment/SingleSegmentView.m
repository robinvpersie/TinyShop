//
//  SingleSegmentView.m
//  GigaProject
//
//  Created by dlwpdlr on 2018/3/14.
//  Copyright © 2018年 GIGA Korea. All rights reserved.
//

#import "SingleSegmentView.h"

@implementation SingleSegmentView

- (instancetype)initWithFrame:(CGRect)frame
					  withdata:(NSMutableArray*)alldata
		  withLineBottomColor:(UIColor*)color{

	self = [super initWithFrame:frame];
	if (self) {
		self.datas = alldata;
		self.lineColor = color;
		[self createSubview];
	}
	return self;
}

- (void)createSubview{
	
	//第一级
	UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPScreenWidth, 50)];
	firstView.backgroundColor = [UIColor whiteColor];
	firstView.layer.borderColor = RGB(221, 221, 221).CGColor;
	firstView.layer.borderWidth = 1.0f;
	[self addSubview:firstView];
	
	UIButton *editBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 70, 0, 70, 50)];
	[editBtn setTitle:@"更多" forState:UIControlStateNormal];
	editBtn.backgroundColor = [UIColor whiteColor];
	[editBtn setTitleColor:RGB(25, 35, 35) forState:UIControlStateNormal];
	editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
	[editBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
	[firstView addSubview:editBtn];
	
	UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(5, 15, 1, 20)];
	line.backgroundColor = RGB(221, 221, 221);
	[editBtn addSubview:line];
	
	self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width- 71, 50)];
	self.scrollview.backgroundColor = [UIColor whiteColor];
	self.scrollview.showsHorizontalScrollIndicator = NO;
	[firstView addSubview:self.scrollview];
	
	if (self.bottomLine == nil) {
		self.bottomLine = [[UILabel alloc]initWithFrame:CGRectMake(10,self.scrollview.frame.size.height - 3 , 45, 2)];
		self.bottomLine.backgroundColor = self.lineColor;
		[self.scrollview addSubview:self.bottomLine];
		
	}
	
	for (int i = 0; i<self.datas.count; i++) {
		NSString *titles = self.datas[i];
		UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*65, 0, 65, 47)];
		[btn setTitle:titles forState:UIControlStateNormal];
		btn.backgroundColor = [UIColor whiteColor];
		btn.tag = i;
		if (i == 0) {
			btn.selected = YES;
		}
		
		[btn setTitleColor: self.lineColor forState:UIControlStateSelected];
		[btn setTitleColor:RGB(201, 201, 201) forState:UIControlStateNormal];
		[btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
		btn.titleLabel.font = [UIFont systemFontOfSize:14];
		[self.scrollview addSubview:btn];
		
	}
	
	
	self.scrollview .contentSize = CGSizeMake(self.datas.count * 65, 50);
	
	
}

- (void)clickAction:(UIButton*)sender{
	
	NSArray *btnarray = [self.scrollview subviews];
	for (int i = 0;i<btnarray.count;i++) {
		id btn = btnarray[i];
		if ([btn isMemberOfClass:[UIButton class]]) {
			UIButton *button = (UIButton*)btn;
			button.selected = NO;
		}
	}
	NSString *firstItem = self.datas[(int)sender.tag];
	[UIView animateWithDuration:0.4f animations:^{
		
		self.bottomLine.frame = CGRectMake(5+sender.tag*65,47 , 55, 2);
		
	}];
	
	sender.selected = !sender.selected;
	
	if ([self.delegate respondsToSelector:@selector(clickItem:)]) {
		[self.delegate clickItem:firstItem];
	}
	
	
}


- (void)editAction:(UIButton*)sender{
	if (self.frame.origin.y > 30) {
		[[NSNotificationCenter defaultCenter]postNotificationName:@"EDITACTIONNOTIFICATIONS" object:@"0"];

	}else{
		[[NSNotificationCenter defaultCenter]postNotificationName:@"EDITACTIONNOTIFICATIONS" object:@"1"];
	}
}
@end
