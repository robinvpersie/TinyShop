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
	
	NSString *content = @"영등포구영등포동";
	NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:16]};
	CGSize contentSize = [content boundingRectWithSize:CGSizeMake(MAXFLOAT,30) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
	UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width - contentSize.width)/2.0f, 0, contentSize.width, 30)];
	label.text = content;
	label.textColor = [UIColor whiteColor];
	label.textAlignment = NSTextAlignmentCenter;
	label.font = [UIFont systemFontOfSize:16];
	[self addSubview:label];
	
	UIImageView *redlocation = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"location"]];
	redlocation.frame = CGRectMake(CGRectGetMinX(label.frame)-16, 8, 12, 14);
	[self addSubview:redlocation];
	
	UIImageView *arrowImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_down"]];
	arrowImg.frame = CGRectMake(CGRectGetMaxX(label.frame) +3, 13 , 10, 8);
	[self addSubview:arrowImg];

	
}
@end
