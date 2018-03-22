//
//  ShopDetailedCollectionCell.m
//  GigaProject
//
//  Created by dlwpdlr on 2018/3/9.
//  Copyright © 2018年 GIGA Korea. All rights reserved.
//

#import "ShopDetailedCollectionCell.h"

@implementation ShopDetailedCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
	self.backView.layer.borderColor = RGB(221, 221, 221).CGColor;
	self.backView.layer.borderWidth = 1;
}

- (void)setDic:(NSDictionary *)dic{
	_dic = dic;
	[self.shopImg sd_setImageWithURL:[NSURL URLWithString:_dic[@"image_url"]]];
	[self.shopname setText:_dic[@""]];
	[self.money setText:[NSString stringWithFormat:@"售价:￥%d",[_dic[@"item_p"] intValue]]];
}
@end
