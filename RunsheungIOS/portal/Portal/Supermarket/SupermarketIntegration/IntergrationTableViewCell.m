//
//  IntergrationTableViewCell.m
//  Portal
//
//  Created by ifox on 2017/1/9.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "IntergrationTableViewCell.h"

@implementation IntergrationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setPointModel:(SupermarketPointModel *)pointModel {
    _pointModel = pointModel;
    float money = [pointModel.trade_money floatValue];
    if (money > 0) {
        _numberLabel.textColor = RGB(2, 169, 239);
    }else {
        _numberLabel.textColor = [UIColor redColor];
    }
    _numberLabel.text = pointModel.trade_money;
    _titleLabel.text = pointModel.trade_type;
    _timeLabel.text = pointModel.trade_date;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
