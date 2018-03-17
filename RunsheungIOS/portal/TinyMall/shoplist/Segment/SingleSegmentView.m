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
					  withDic:(NSMutableArray*)alldata
					 withData:(NSMutableArray*)mutableArray
		  withLineBottomColor:(UIColor*)color
					 withflag:(int)flag{
	
	self = [super initWithFrame:frame];
	if (self) {
		self.alldata = alldata;
		self.datas = mutableArray;
		self.lineColor = color;
		self.flag = flag;
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
		self.bottomLine = [[UILabel alloc]initWithFrame:CGRectMake(5,self.scrollview.frame.size.height - 3 , 55, 2)];
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
	
	[UIView animateWithDuration:0.4f animations:^{
		
		self.bottomLine.frame = CGRectMake(5+sender.tag*65,47 , 55, 2);
		
	}];
	
	sender.selected = !sender.selected;
	NSString *itemkey = self.datas[sender.tag];
	if ([self.delegate respondsToSelector:@selector(clickUpItem:)]) {
		[self.delegate clickUpItem:itemkey];
	}
	
	for (NSDictionary *dic in self.alldata) {
		if ([itemkey isEqualToString:dic.allKeys.firstObject]) {
		
			NSArray *datass = (NSArray*)dic.allValues.firstObject;
			NSDictionary *dicss1 = (NSDictionary*)datass.firstObject;
			NSArray *datas1 = (NSArray*)dicss1.allValues.firstObject;
		
			if ([self.delegate respondsToSelector:@selector(clickUpSecItem:)]) {
				[self.delegate clickUpSecItem:(NSMutableArray*)datas1];
			}
		}
	}
	
	
	if (self.flag) {
		if ([self.delegate respondsToSelector:@selector(clickUpThirdItem:)]) {
			NSMutableArray *firstAllKeys = @[].mutableCopy;
			for (NSDictionary *dics in self.alldata) {
				NSArray *allKeys = dics.allKeys;
				[firstAllKeys addObjectsFromArray:allKeys];
			
			}
			for (NSString *keys in firstAllKeys) {
				for (NSDictionary *dics in self.alldata) {
					if ([keys isEqualToString:dics.allKeys.firstObject]) {
						NSArray *dss = dics.allValues.firstObject;
						for (NSDictionary *dics in dss) {
							NSString*Keys = dics.allKeys.firstObject;
							if ([itemkey isEqualToString:Keys]) {
								NSArray *dssss = dics[Keys];
								[self.delegate clickUpThirdItem:dssss];
								
							}
							
						}

					}
				}
			}

		}
		
	}
}


- (void)editAction:(UIButton*)sender{
	[[NSNotificationCenter defaultCenter]postNotificationName:@"EDITACTIONNOTIFICATIONS" object:nil];
}
@end
