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
					  withdit:(NSDictionary*)alldit
					 withData:(NSArray*)showarray
		  withLineBottomColor:(UIColor*)color{
	
	self = [super initWithFrame:frame];
	if (self) {
		self.alldit = alldit;
		self.showarray = showarray;
		self.lineColor = color;
		[self createSubview];
	}
	return self;
}

- (void)createSubview{
	
	//第一级
	UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPScreenWidth, 50)];
	firstView.backgroundColor = [UIColor whiteColor];
	[self addSubview:firstView];
	
	self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
	self.scrollview.backgroundColor = [UIColor whiteColor];
	self.scrollview.showsHorizontalScrollIndicator = NO;
	[firstView addSubview:self.scrollview];
	
	if (self.bottomLine == nil) {
		self.bottomLine = [[UILabel alloc]initWithFrame:CGRectMake(10,self.scrollview.frame.size.height - 8 , 45, 2)];
		self.bottomLine.backgroundColor = self.lineColor;
		[self.scrollview addSubview:self.bottomLine];
		
	}
	
	for (int i = 0; i<self.showarray.count; i++) {
		NSString *titles = self.showarray[i];
		UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*65, 0, 65, 47)];
		[btn setTitle:titles forState:UIControlStateNormal];
		[btn setTitleColor:self.lineColor forState:UIControlStateSelected];
		
		btn.tag = i;
		NSString *isOne = GetUserDefault(@"Level1");
		NSString *isTwo = GetUserDefault(@"Level2");
		if ([isOne isEqualToString:@"1"]) {
			if (i+1 == isTwo.intValue) {
				btn.selected = YES;
				[UIView animateWithDuration:0.4f animations:^{
					self.bottomLine.frame = CGRectMake(5+i*65,47 , 55, 2);
				}];
			}
		}else {
			if (i == 0) {
				btn.selected = YES;
			}

		}
		
		[btn setTitleColor:RGB(2, 2, 2) forState:UIControlStateNormal];
		[btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
		btn.titleLabel.font = [UIFont systemFontOfSize:15];
		[self.scrollview addSubview:btn];
		
	}
	self.scrollview .contentSize = CGSizeMake(self.showarray.count * 65, 50);
	
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
	[UIView animateWithDuration:0.4f animations:^{
		self.bottomLine.frame = CGRectMake(5+sender.tag*65,47 , 55, 2);
	}];
	
	if ([self.delegate respondsToSelector:@selector(clickItem:)]) {
		[self.delegate clickItem:(int)sender.tag];
	}
	
	
	sender.selected = !sender.selected;
}



@end
