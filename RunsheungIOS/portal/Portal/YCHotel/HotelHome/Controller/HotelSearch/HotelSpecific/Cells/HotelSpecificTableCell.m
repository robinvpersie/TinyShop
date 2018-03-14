//
//  HotelSpecificTableCell.m
//  Portal
//
//  Created by 王五 on 2017/4/7.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelSpecificTableCell.h"
#import "UIView+ViewController.h"
#import "HotelRoomTypeModel.h"
#import "HotelConfirmOrderViewController.h"

@implementation HotelSpecificTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUI];
}
- (IBAction)orderBtn:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(sumbitAction:)]) {
        HotelConfirmOrderViewController *confirmOrder = [[HotelConfirmOrderViewController alloc] init];
        confirmOrder.hotelID = self.hotelID;
        confirmOrder.roomModel = self.roommodel;
        confirmOrder.hotelName = self.hotelName;

        [self.delegate sumbitAction:confirmOrder];
    }
//    HotelConfirmOrderViewController *confirmOrder = [[HotelConfirmOrderViewController alloc] init];
//    confirmOrder.hotelID = self.hotelID;
//    confirmOrder.roomModel = self.roommodel;
//    confirmOrder.hotelName = self.hotelName;
   
}

- (void)setRoommodel:(HotelRoomTypeModel *)roommodel{
    _roommodel = roommodel;

    [UIImageView hotelSetImageWithImageView:self.iconImg UrlString:_roommodel.iconUrl imageVersion:nil];
     [self.roomTypeLab setText:_roommodel.roomTypeName];
     [self.priceLab setText:[NSString stringWithFormat:@"￥%@",_roommodel.MemeberPrice]];
     [self.roomDeviceLab setText:_roommodel.remark];
}

- (void)setUI{
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.orderbutton.layer.cornerRadius = 1.5f;
    self.orderbutton.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
