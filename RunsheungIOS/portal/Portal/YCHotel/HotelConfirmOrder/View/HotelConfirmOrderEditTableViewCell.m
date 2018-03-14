//
//  HotelConfirmOrderEditTableViewCell.m
//  Portal
//
//  Created by ifox on 2017/4/12.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelConfirmOrderEditTableViewCell.h"
#import "UILabel+CreateLabel.h"

@implementation HotelConfirmOrderEditTableViewCell

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
    
    if (_rightTextField == nil) {
        _rightTextField = [[UITextField alloc] initWithFrame:CGRectMake(APPScreenWidth - APPScreenWidth/2, _leftLabel.frame.origin.y, APPScreenWidth/2 - 10 - 25, _leftLabel.frame.size.height)];
        _rightTextField.font = _leftLabel.font;
        _rightTextField.textColor = HotelBlackColor;
    }
    [self.contentView addSubview:_rightTextField];
    
    if (_icon == nil) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(APPScreenWidth - 10 - 30, 10, 25, 25)];
        _icon.contentMode = UIViewContentModeScaleAspectFit;
        _icon.userInteractionEnabled = YES;
    }
    [self.contentView addSubview:_icon];
    
}

@end
