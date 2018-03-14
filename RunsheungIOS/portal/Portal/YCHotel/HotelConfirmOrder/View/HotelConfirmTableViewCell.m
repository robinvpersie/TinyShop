//
//  HotelConfirmTableViewCell.m
//  Portal
//
//  Created by ifox on 2017/4/11.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelConfirmTableViewCell.h"
#import "UILabel+CreateLabel.h"

@implementation HotelConfirmTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    if (_leftLabel == nil) {
        _leftLabel = [UILabel createLabelWithFrame:CGRectMake(15, 0, 200, 45) textColor:HotelGrayColor font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft text:@""];
    }
    [self.contentView addSubview:_leftLabel];
    
    if (_rightLabel == nil) {
        _rightLabel = [UILabel createLabelWithFrame:CGRectMake(APPScreenWidth - APPScreenWidth/2, 0, APPScreenWidth/2, _leftLabel.frame.size.height) textColor:HotelBlackColor font:_leftLabel.font textAlignment:NSTextAlignmentLeft text:@""];
    }
    [self.contentView addSubview:_rightLabel];
}

@end
