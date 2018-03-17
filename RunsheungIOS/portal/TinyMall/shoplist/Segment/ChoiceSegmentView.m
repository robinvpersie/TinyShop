//
//  ChoiceSegmentView.m
//  GigaProject
//
//  Created by dlwpdlr on 2018/3/8.
//  Copyright © 2018年 GIGA Korea. All rights reserved.
//

#import "ChoiceSegmentView.h"

@implementation ChoiceSegmentView

- (instancetype)initWithFrame:(CGRect)frame
					  withData:(NSMutableArray*)data{
	self = [super initWithFrame: frame];
	if (self) {
		self.layer.borderColor = RGB(221, 221, 221).CGColor;
		self.layer.borderWidth = 1.0f;
		self.backgroundColor = RGB(250, 250, 250);
		self.dataArray = data;
		[self createSubviews];
	}
	return self;
}

- (void)createSubviews{
	
	NSMutableArray *datas = @[].mutableCopy;
	for (NSDictionary*dict in self.dataArray) {
		
		NSString *keyValue = dict.allKeys.firstObject;
		[datas addObject:keyValue];
	}
	if (self.SingleSegment == nil) {
		self.SingleSegment = [[SingleSegmentView alloc]initWithFrame:CGRectMake(0, 0, APPScreenWidth, 50) withDic:self.dataArray withData:datas withLineBottomColor:RGB(33, 192, 67) withflag:0];
		self.SingleSegment.delegate = self;
		[self addSubview:self.SingleSegment];
	}
	
	NSDictionary *dict = self.dataArray.firstObject;
	NSString *keyValue = dict.allKeys.firstObject;
		NSMutableArray *dats = dict[keyValue];
	
		NSMutableArray *da = @[].mutableCopy;
		for (NSDictionary*dic in dats) {
			
			[da addObject:dic.allKeys.firstObject];
		}
	if (self.SingleSegmentSecond == nil) {
		
		self.SingleSegmentSecond = [[SingleSegmentView alloc]initWithFrame:CGRectMake(0, 60, APPScreenWidth, 50)withDic:self.dataArray withData:da withLineBottomColor:RGB(33, 192, 67) withflag:1];
		self.SingleSegmentSecond.delegate = self;
		[self addSubview:self.SingleSegmentSecond];
	}
	
	
	//item 按钮
	NSDictionary *dict1 = self.dataArray.firstObject;
	NSMutableArray *dats1 = dict1.allValues.firstObject;
	NSDictionary *dic1 = dats1.firstObject;
	NSMutableArray *data1 = dic1.allValues.firstObject;
	if (self.SegmentItem == nil) {
		self.SegmentItem = [[SegmentItem alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.SingleSegmentSecond.frame)+10, APPScreenWidth, 50) withData:data1];
		[self addSubview:self.SegmentItem];
	}
}

- (void)clickUpItem:(NSString *)upitem{
	NSMutableArray *datas = @[].mutableCopy;
	for (NSDictionary*dict in self.dataArray) {
		
		NSString *keyValue = dict.allKeys.firstObject;
		[datas addObject:keyValue];
	}

	
	self.SingleSegmentSecond = nil;
	for (NSDictionary*dict in self.dataArray) {
		
		NSString *keyValue = dict.allKeys.firstObject;
		if ([upitem isEqualToString:keyValue]) {
			NSMutableArray *dats = dict[keyValue];
			
			NSMutableArray *da = @[].mutableCopy;
			for (NSDictionary*dic in dats) {
				
				[da addObject:dic.allKeys.firstObject];
			}
			if (self.SingleSegmentSecond == nil) {
				self.SingleSegmentSecond = [[SingleSegmentView alloc]initWithFrame:CGRectMake(0, 60, APPScreenWidth, 50) withDic:self.dataArray withData:da withLineBottomColor:RGB(33, 192, 67) withflag:1];
				[self addSubview:self.SingleSegmentSecond];
			}
		}
	}
		
	
	
}

- (void)clickUpSecItem:(NSMutableArray *)upsecitems{
	NSMutableArray *datas = @[].mutableCopy;
	for (NSDictionary*dict in self.dataArray) {
		NSString *keyValue = dict.allKeys.firstObject;
		[datas addObject:keyValue];
	}
	
	self.SegmentItem = nil;
			if (self.SegmentItem == nil) {
				self.SegmentItem = [[SegmentItem alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.SingleSegmentSecond.frame)+10, APPScreenWidth, 50) withData:upsecitems];
				[self addSubview:self.SegmentItem];
			}

	
}
- (void)clickUpThirdItem:(NSMutableArray *)upthirditems{
	
}
@end
