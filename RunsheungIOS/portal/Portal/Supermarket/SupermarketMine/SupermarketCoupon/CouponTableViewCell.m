//
//  CouponTableViewCell.m
//  Portal
//
//  Created by ifox on 2017/1/11.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "CouponTableViewCell.h"
#import "UILabel+CreateLabel.h"

@implementation CouponTableViewCell {
    UIImageView *bgView;
    UIImageView *useIcon;
    
    UILabel *_titleLabel;
    UILabel *_timeLabel;
    UILabel *_moneyLabel;
    UILabel *_qualificationLabel;
    UILabel *_qualifiedLabel;//差xxx可使用该券
    
    UIButton *_useNowButton;
    
    UIButton *_check;
    
    UIView *_maskView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = RGB(242, 242, 242);
        [self createSubView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)createSubView {
    bgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, APPScreenWidth - 30, 80)];
    bgView.image = [UIImage imageNamed:@"redbg"];
    bgView.userInteractionEnabled = YES;
    [self.contentView addSubview:bgView];
    
//    UITapGestureRecognizer
    
    useIcon = [[UIImageView alloc] initWithFrame:CGRectMake(50, 15, 50, 50)];
    useIcon.image = [UIImage imageNamed:@"icon_used"];
    [bgView addSubview:useIcon];
    
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, APPScreenWidth, 25)];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textColor = [UIColor darkcolor];
        _titleLabel.text = @"奢厨优惠券";
    }
    [bgView addSubview:_titleLabel];
    
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, CGRectGetMaxY(_titleLabel.frame)+10, 300, 20)];
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.text = @"2016.12.30-2017.12.30";
        _timeLabel.font = [UIFont systemFontOfSize:11];
    }
    [bgView addSubview:_timeLabel];
    
    if (_moneyLabel == nil) {
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgView.frame.size.width - 15 - 80 + 5, _titleLabel.frame.origin.y, 80, 40)];
        _moneyLabel.textColor = [UIColor whiteColor];
        _moneyLabel.text = @"15";
        _moneyLabel.font = [UIFont systemFontOfSize:32];
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
    }
    [bgView addSubview:_moneyLabel];
    
    if (_qualificationLabel == nil) {
        _qualificationLabel = [[UILabel alloc] initWithFrame:CGRectMake(_moneyLabel.frame.origin.x, CGRectGetMaxY(_moneyLabel.frame), _moneyLabel.frame.size.width, 20)];
        _qualificationLabel.textColor = [UIColor whiteColor];
        _qualificationLabel.font = [UIFont systemFontOfSize:13];
        _qualificationLabel.text = @"满99可用";
        _qualificationLabel.numberOfLines = 0;
        _qualificationLabel.textAlignment = NSTextAlignmentCenter;
    }
    [bgView addSubview:_qualificationLabel];
    
    if (_qualifiedLabel == nil) {
        _qualifiedLabel = [UILabel createLabelWithFrame:CGRectMake(_timeLabel.frame.origin.x, 80, APPScreenWidth, 25) textColor:[UIColor darkGrayColor] font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft text:@"差57.20元可用该券"];
    }
    _qualifiedLabel.hidden = YES;
    [bgView addSubview:_qualifiedLabel];
    
    if (_useNowButton == nil) {
        _useNowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _useNowButton.frame = CGRectMake(bgView.frame.size.width - 10 - 15, _moneyLabel.frame.origin.y, 17, 55);
        [_useNowButton setTitle:@"立即使用" forState:UIControlStateNormal];
         _useNowButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _useNowButton.titleLabel.numberOfLines = 0;
        _useNowButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [_useNowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _useNowButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _useNowButton.layer.borderWidth = 1.0f;
        _useNowButton.layer.cornerRadius = 17/2.0;
        _useNowButton.hidden = YES;
    }
//    [bgView addSubview:_useNowButton];
    
    if (_check == nil) {
        _check = [UIButton buttonWithType:UIButtonTypeCustom];
        _check.frame = CGRectMake(10, bgView.center.y - 20, 20, 20);
        [_check setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
        [_check setImage:[UIImage imageNamed:@"cart_selected_btn"] forState:UIControlStateSelected];
        [_check addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
        _check.userInteractionEnabled = YES;
    }
    _check.hidden = YES;
    [bgView addSubview:_check];
    
    if (_maskView == nil) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height)];
        _maskView.backgroundColor = [UIColor whiteColor];
        _maskView.alpha = 0.75;
        _maskView.hidden = YES;
    }
    [bgView addSubview:_maskView];
    

}

- (void)setCouponStatus:(NSInteger)couponStatus {
    _couponStatus = couponStatus;
    if (couponStatus == 0) {
        useIcon.hidden = YES;
        _check.hidden = NO;
        
        CGRect titleFrame = _titleLabel.frame;
        titleFrame.origin.x += 25;
        _titleLabel.frame = titleFrame;
        
        CGRect timeFrame = _timeLabel.frame;
        timeFrame.origin.x += 25;
        _timeLabel.frame = timeFrame;
    }
    if (couponStatus == 1) {
        useIcon.hidden = NO;
    }
    if (couponStatus == 2) {
        bgView.image = [UIImage imageNamed:@"graybg"];
        useIcon.hidden = YES;
    }
    if (couponStatus == 3) {
        bgView.image = [UIImage imageNamed:@"bgCantUse"];
        bgView.frame = CGRectMake(15, 10, APPScreenWidth - 30, 105);
        useIcon.hidden = YES;
        _qualifiedLabel.hidden = NO;
    }
    if (couponStatus == 4) {
        _moneyLabel.frame = CGRectMake(bgView.frame.size.width - 15 - 80 - 5, _titleLabel.frame.origin.y, 95, 40);
        _qualificationLabel.frame = CGRectMake(_moneyLabel.frame.origin.x, CGRectGetMaxY(_moneyLabel.frame), _moneyLabel.frame.size.width, 15);
        _useNowButton.hidden = NO;
        useIcon.hidden = YES;
    }
}

- (void)setCoupon:(CouponModel *)coupon {
    _coupon = coupon;
    _timeLabel.text = [NSString stringWithFormat:@"%@至%@",coupon.startDate,coupon.endDate];
    _titleLabel.text = coupon.couponRangeMsg;
    _qualificationLabel.text = coupon.overMsg;
    _moneyLabel.text = coupon.couponName;
    if (coupon.cantSelected == YES) {
        _maskView.hidden = NO;
    }
    
    if (coupon.isSelected == YES) {
        _check.selected = YES;
    } else {
        _check.selected = NO;
    }
}

- (void)checkAction:(UIButton *)button {
    button.selected = !button.selected;
    if ([self.delegate respondsToSelector:@selector(selectCoupon:isSelected:)]) {
        [_delegate selectCoupon:self isSelected:button.selected];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
