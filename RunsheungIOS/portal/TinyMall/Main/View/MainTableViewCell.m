//
//  MainTableViewCell.m
//  Portal
//
//  Created by dlwpdlr on 2018/3/19.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "MainTableViewCell.h"
#import "GigaStarLabel.h"

@implementation MainTableViewCell

- (void)setStarView:(UIView *)starView{
	
	GigaStarLabel *star = [[GigaStarLabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(starView.frame), CGRectGetHeight(starView.frame)) withStarValue:3.2];
	[starView addSubview:star];
	
}
@end
