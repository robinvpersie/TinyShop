//
//  SegmentItem.m
//  GigaProject
//
//  Created by dlwpdlr on 2018/3/14.
//  Copyright © 2018年 GIGA Korea. All rights reserved.
//

#import "SegmentItem.h"

@implementation SegmentItem

- (instancetype)initWithFrame:(CGRect)frame withData:(NSMutableArray*)data{
	self = [super initWithFrame: frame];
	if (self) {
		self.dataArray = data;
		self.backgroundColor = RGB(254, 254, 254);
		self.layer.borderWidth = 0.6f;
		self.layer.borderColor = RGB(221, 221, 221).CGColor;
		[self createSubviews];
	}
	return self;
}

- (void)createSubviews{
	for (int i = 0; i<self.dataArray.count; i++) {
		UIButton *buton = [[UIButton alloc]initWithFrame:CGRectMake(5 + i*65, 10, 55, 30)];
		buton.layer.borderColor = RGB(221, 221, 221).CGColor;
		buton.layer.borderWidth = 0.8;
		[buton setTitle:self.dataArray[i] forState:UIControlStateNormal];
		[buton setTitleColor:RGB(25, 25, 25) forState:UIControlStateNormal];
		[buton.titleLabel setFont:[UIFont systemFontOfSize:13]];
		
		[self addSubview:buton];
	}
}
@end
