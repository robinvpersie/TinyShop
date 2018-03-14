//
//  ExpressCell.m
//  Portal
//
//  Created by ifox on 2017/1/10.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "ExpressCell.h"

@implementation ExpressCell {
    UILabel *_timeLabel;
    UILabel *_statusLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return  self;
}

- (void)createView {
    if (_timeLabel == nil) {
//        _timeLabel = [UILabel alloc] initWithFrame:<#(CGRect)#>
    }
    [self.contentView addSubview:_timeLabel];
    
    if (_statusLabel == nil) {
        
    }
    [self.contentView addSubview:_statusLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
