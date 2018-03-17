//
//  GigaStarLabel.m
//  GigaProject
//
//  Created by dlwpdlr on 2018/3/13.
//  Copyright © 2018年 GIGA Korea. All rights reserved.
//

#import "GigaStarLabel.h"

@implementation GigaStarLabel

- (instancetype)initWithFrame:(CGRect)frame withStarValue:(double )starValue{
	self = [super initWithFrame: frame];
	if (self) {
		
		[self createStar:starValue];
	}
	return self;
}

- (void)createStar:(double)starValue{
	
	CGFloat scalewidth = starValue/5.0f;
	UIView *starbackDefaultView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, (10 + 5*self.frame.size.height), self.frame.size.height)];
	UIView *starbackYellowView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, (10 + 5*self.frame.size.height)*scalewidth, self.frame.size.height)];

	for (int i = 0; i < 5; i++) {
		UIImageView*star = [[UIImageView alloc]initWithFrame:CGRectMake(i*(self.frame.size.height +2), 0, self.frame.size.height,self.frame.size.height )];
		star.image =[UIImage imageNamed:@"icon_star_default_8"];
		[starbackDefaultView addSubview:star];
		
		UIImageView*highlystar = [[UIImageView alloc]initWithFrame:CGRectMake(i*(self.frame.size.height +2), 0, self.frame.size.height, self.frame.size.height )];
		highlystar.image =[UIImage imageNamed:@"icon_star_yellow_8"];
		starbackYellowView.layer.masksToBounds = YES;
		[starbackYellowView addSubview:highlystar];
		
	}
	[self addSubview:starbackDefaultView];
	[self addSubview:starbackYellowView];
}
@end
