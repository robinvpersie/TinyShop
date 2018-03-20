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
					  withData:(NSMutableDictionary*)dict
				 withresponse:(NSDictionary*)response{
	self = [super initWithFrame: frame];
	if (self) {
		self.layer.borderColor = RGB(221, 221, 221).CGColor;
		self.layer.borderWidth = 1.0f;
		self.backgroundColor = RGB(250, 250, 250);
		self.dataDic = dict;
		self.responseDic = response;
		[self createSubviews];
	}
	return self;
}
- (void)setDataDic:(NSMutableDictionary *)dataDic{
	_dataDic = dataDic;
	[self createSubviews];
}

- (void)createSubviews{
	
	NSArray *allkeyData = self.dataDic.allKeys;
	NSString*firstDicKey = self.dataDic.allKeys.firstObject;
	NSArray *firstData = self.dataDic[firstDicKey];
	
		self.SingleSegment = [[SingleSegmentView alloc]initWithFrame:CGRectMake(0, 0, APPScreenWidth, 50) withdata:allkeyData withLineBottomColor:RGB(33, 192, 67)];
		self.SingleSegment.delegate = self;
		[self addSubview:self.SingleSegment];
		self.SingleSegmentSecond = [[SingleSegmentView alloc]initWithFrame:CGRectMake(0, 60, APPScreenWidth, 50) withdata:firstData withLineBottomColor:RGB(33, 192, 67)];
		[self addSubview:self.SingleSegmentSecond];
}


- (void)clickItem:(NSString*)key{
	NSArray *data = _dataDic[key];

	NSArray *leve2s = self.responseDic[@"lev2s"];
	
	for (int i = 0; i<leve2s.count; i++) {
		NSDictionary *dic2 = leve2s[i];
		NSString *currentStr = dic2[@"lev_name"];
		
		if ([currentStr isEqualToString:key]) {
			[[NSUserDefaults standardUserDefaults] setObject:dic2[@"lev"] forKey:@"lev2"];
			[[NSUserDefaults standardUserDefaults] synchronize];
			if ([self.delegate respondsToSelector:@selector(ChoiceDelegateaction:)]) {
				[self.delegate ChoiceDelegateaction:dic2[@"lev"]];
			}
		}
	}
	
	
	
	
	self.SingleSegmentSecond = [[SingleSegmentView alloc]initWithFrame:CGRectMake(0, 60, APPScreenWidth, 50) withdata:data withLineBottomColor:RGB(33, 192, 67)];
	[self addSubview:self.SingleSegmentSecond];

	
}
@end
