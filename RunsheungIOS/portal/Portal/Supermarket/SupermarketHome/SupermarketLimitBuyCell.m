//
//  SupermarketLimitBuyCell.m
//  Portal
//
//  Created by ifox on 2016/12/29.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketLimitBuyCell.h"

@implementation SupermarketLimitBuyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.buyRightNow.layer.cornerRadius = 3.0f;
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:@" 20.00"
                                                                  attributes:@{
                                                                               NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                                                                               NSFontAttributeName:[UIFont systemFontOfSize:14.f],
                                                                               NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                                                               NSStrikethroughColorAttributeName:[UIColor lightGrayColor]                                                             }];
    self.originalPriceLabel.attributedText = attrStr;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
