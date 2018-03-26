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
	[self.Headavor sd_setImageWithURL:[NSURL URLWithString:_dic[@"shop_thumnail_image"]]];
	[self.titleLab setText:_dic[@"custom_name"]];
	
	[self.detailedLab setText:[NSString stringWithFormat:@"주문수：%d만+  즐겨찾기 %d+", [_dic[@"cnt"] intValue],[_dic[@"sale_custom_cnt"] intValue]]];
	
	[self.distance setText:_dic[@"distance"]];
		
}

- (void)setStarValue:(CGFloat)starValue{

	_starValue = starValue;
	self.unkownBtn.layer.cornerRadius = 8;
	self.unkownBtn.layer.masksToBounds = YES;

	GigaStarLabel *starview = [[GigaStarLabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.starView.frame), CGRectGetMinY(self.starView.frame), 200, 12) withStarValue:_starValue];
	[self.contentView addSubview:starview];

}


- (IBAction)unkownAction:(UIButton *)sender {

}

@end
