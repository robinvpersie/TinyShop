//
//  HotelCheckQRCodeCell.m
//  Portal
//
//  Created by ifox on 2017/4/22.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelCheckQRCodeCell.h"

@implementation HotelCheckQRCodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.roomNum.textColor = HotelBlackColor;
    self.roomCode.textColor = HotelBlackColor;
    [self.checkQRCode setTitleColor:PurpleColor forState:UIControlStateNormal];
    self.line.backgroundColor = BorderColor;
    
    [self.checkQRCode addTarget:self action:@selector(clickCheckQRCodeButton) forControlEvents:UIControlEventTouchUpInside];
    // Initialization code
}

- (void)clickCheckQRCodeButton {
    if ([self.delegate respondsToSelector:@selector(checkQRCodeButtonClick:)]) {
        [self.delegate checkQRCodeButtonClick:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
