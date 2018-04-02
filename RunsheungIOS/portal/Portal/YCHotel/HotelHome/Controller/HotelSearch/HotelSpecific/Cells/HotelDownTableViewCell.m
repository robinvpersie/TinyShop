//
//  HotelDownTableViewCell.m
//  Portal
//
//  Created by 王五 on 2017/4/8.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelDownTableViewCell.h"
#import "HotelConfirmOrderViewController.h"

@implementation HotelDownTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setUI];
}

- (void)setUI{
    
    self.specificEnjoy.layer.borderColor = PurpleColor.CGColor;
    self.specificEnjoy.layer.borderWidth = 0.5;
    self.specificEnjoy.layer.cornerRadius = 1.5f;
    self.specificEnjoy.layer.masksToBounds = YES;
    self.todaySpecific.layer.borderColor = PurpleColor.CGColor;
    self.todaySpecific.layer.borderWidth = 0.5;
    self.todaySpecific.layer.cornerRadius = 1.5f;
    self.todaySpecific.layer.masksToBounds = YES;
    self.callBack.layer.borderColor = PurpleColor.CGColor;
    self.callBack.layer.borderWidth = 0.5;
    self.callBack.layer.cornerRadius = 1.5f;
    self.callBack.layer.masksToBounds = YES;
    self.OrderBtn.layer.cornerRadius = 3.0f;
    self.OrderBtn.layer.masksToBounds = YES;
    
    [self.reserveBtn addTarget:self action:@selector(confirmOrder) forControlEvents:UIControlEventTouchUpInside];
}

- (void)confirmOrder {
    HotelConfirmOrderViewController *confirmOrder = [[HotelConfirmOrderViewController alloc] init];
    [self.viewController.navigationController pushViewController:confirmOrder animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
