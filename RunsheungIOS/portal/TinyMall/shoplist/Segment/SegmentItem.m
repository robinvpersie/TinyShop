//
//  SegmentItem.m
//  GigaProject
//
//  Created by dlwpdlr on 2018/3/14.
//  Copyright © 2018年 GIGA Korea. All rights reserved.
//

#import "SegmentItem.h"

@implementation SegmentItem

- (instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame: frame];
	if (self) {
		self.dataArray = @[@"销量最高",@"离我最近",@"平台推荐"].mutableCopy;
		self.backgroundColor = RGB(254, 254, 254);
		self.layer.borderWidth = 0.6f;
		self.layer.borderColor = RGB(221, 221, 221).CGColor;
		[self createSubviews];
	}
	return self;
}

- (void)createSubviews{
	
	self.buttonArray = @[].mutableCopy;
	for (int i = 0; i<self.dataArray.count; i++) {
		UIButton *buton = [[UIButton alloc]initWithFrame:CGRectMake(10 + i*75, 10, 65, 30)];
		if (i == 0) {
			buton.selected = YES;
		}
		buton.layer.cornerRadius = 15;
		buton.tag = i;
		buton.layer.masksToBounds = YES;
		[buton addTarget:self action:@selector(ItemThird:) forControlEvents:UIControlEventTouchUpInside];
		[buton setTitle:self.dataArray[i] forState:UIControlStateNormal];
		[buton setTitleColor:RGB(175, 175, 175) forState:UIControlStateNormal];
		[buton setTitleColor:RGB(255, 255, 255) forState:UIControlStateSelected];
		[buton setBackgroundImage:[UIImage imageNamed:@"green"] forState:UIControlStateSelected];
		[buton setBackgroundImage:[UIImage imageNamed:@"white1"] forState:UIControlStateNormal];
		[buton.titleLabel setFont:[UIFont systemFontOfSize:13]];
		
		[self addSubview:buton];
	}
}

- (void)ItemThird:(UIButton*)sender{
	NSArray *btnarray = [self subviews];
	for (int i = 0;i<btnarray.count;i++) {
		id btn = btnarray[i];
		if ([btn isMemberOfClass:[UIButton class]]) {
			UIButton *button = (UIButton*)btn;
			button.selected = NO;
		}
	}
	sender.selected = YES;
	if ([self.delegate respondsToSelector:@selector(clickSegment:)]) {
		[self.delegate clickSegment:(int)sender.tag];
	}
	
}
@end
