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
	self.lastlabel.layer.cornerRadius = 10;
	self.lastlabel.layer.masksToBounds = YES;
	UIView *bgv = [UIView new];
	bgv.layer.cornerRadius = 5;
	bgv.layer.masksToBounds = YES;
	bgv.layer.borderColor = RGB(234, 234, 234).CGColor;
	bgv.layer.borderWidth = 2;
	[self.contentView insertSubview:bgv atIndex:0];
	[bgv mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(10);
		make.top.mas_equalTo(5);
		make.trailing.mas_equalTo(-10);
		make.bottom.mas_equalTo(-5);
	}];
	
	[self.korAddress setText:_dic[@"kor_addr"]];
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
