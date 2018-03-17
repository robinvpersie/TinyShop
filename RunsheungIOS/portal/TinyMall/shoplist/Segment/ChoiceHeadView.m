//
//  ChoiceHeadView.m
//  GigaProject
//
//  Created by dlwpdlr on 2018/3/8.
//  Copyright © 2018年 GIGA Korea. All rights reserved.
//

#import "ChoiceHeadView.h"

@implementation ChoiceHeadView

- (instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		[self createSubviews];
	}
	return self;
}

- (void)createSubviews{
	UIImageView *redlocation = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_location"]];
	redlocation.frame = CGRectMake(0, 9, 10, 12);
	[self addSubview:redlocation];
	
	UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(redlocation.frame)+3, 0, self.frame.size.width - 40, 30)];
	label.text = @"서울 특별시 영등포구 영등포동";
	label.textAlignment = NSTextAlignmentCenter;
	label.font = [UIFont systemFontOfSize:13];
	[self addSubview:label];
	
	UIImageView *arrowImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_arrow_bottom"]];
	arrowImg.frame = CGRectMake(self.frame.size.width - 16, 12 , 8, 6);
	[self addSubview:arrowImg];

	
}
@end
