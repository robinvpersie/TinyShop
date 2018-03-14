//
//  SupermarketTasteNewCell.m
//  Portal
//
//  Created by ifox on 2016/12/28.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketTasteNewCell.h"

@implementation SupermarketTasteNewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.buyRightNow.layer.cornerRadius = 3.0f;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
