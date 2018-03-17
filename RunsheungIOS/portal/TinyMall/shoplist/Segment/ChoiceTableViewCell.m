//
//  ChoiceTableViewCell.m
//  GigaProject
//
//  Created by dlwpdlr on 2018/3/8.
//  Copyright © 2018年 GIGA Korea. All rights reserved.
//

#import "ChoiceTableViewCell.h"
#import "GigaStarLabel.h"

@implementation ChoiceTableViewCell
- (void)setDic:(NSDictionary *)dic{
	_dic = dic;
	
}

- (void)setStarValue:(CGFloat)starValue{

	_starValue = starValue;
	self.unkownBtn.layer.cornerRadius = 8;
	self.unkownBtn.layer.masksToBounds = YES;

	GigaStarLabel *starview = [[GigaStarLabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.starView.frame), CGRectGetMinY(self.starView.frame), 200, 12) withStarValue:3.3];
	[self.contentView addSubview:starview];

}
- (IBAction)unkownAction:(UIButton *)sender {
	}

@end
