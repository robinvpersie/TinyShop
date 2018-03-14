//
//  HotelIntroPhoneCell.m
//  Portal
//
//  Created by ifox on 2017/4/8.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelIntroPhoneCell.h"
#import "HotelDetailInfoModel.h"

@implementation HotelIntroPhoneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(HotelDetailInfoModel *)model{
    _model = model;
    [self.hotelNameLab setText:model.hotelName];
    [self.hotelTypeLab setText:@"高档型"];
}
- (IBAction)callaction:(UIButton *)sender {
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
