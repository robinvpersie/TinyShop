//
//  HotelSearchResultTableViewCell.m
//  Portal
//
//  Created by ifox on 2017/4/5.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelSearchResultTableViewCell.h"
#import "UILabel+CreateLabel.h"
#import "UILabel+WidthAndHeight.h"

@implementation HotelSearchResultTableViewCell {
    UIImageView *_iconImageView;
    UILabel *_titleLabel;
    UILabel *_pointLabel;
    UILabel *_commentLabel;
    UILabel *_typeLabel;//高档型
    UILabel *_locationLabel;
    
    UILabel *_availableTimeLabel;//可入住时间
    
    UILabel *_reserveLabel;
    UILabel *_priceLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createView];
    }
    return self;
}

- (void)createView {
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, APPScreenWidth/3, 105)];
    _iconImageView.clipsToBounds = YES;
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    _iconImageView.image = [UIImage imageNamed:@"hotel.jpg"];
    [self.contentView addSubview:_iconImageView];
    
    _titleLabel = [UILabel createLabelWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, _iconImageView.frame.origin.y, 200, 25) textColor:HotelBlackColor font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft text:@"长沙宇成国际酒店"];
    [self.contentView addSubview:_titleLabel];
    
    CGFloat pointWidth = [UILabel getWidthWithTitle:@"8.8" font:[UIFont systemFontOfSize:15]];
    _pointLabel = [UILabel createLabelWithFrame:CGRectMake(_titleLabel.frame.origin.x, CGRectGetMaxY(_titleLabel.frame), pointWidth, 20) textColor:RGB(252, 214, 60) font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft text:@"4.3"];
    [self.contentView addSubview:_pointLabel];;
    
    _commentLabel = [UILabel createLabelWithFrame:CGRectMake(CGRectGetMaxX(_pointLabel.frame)+20, _pointLabel.frame.origin.y+2, 200, 18) textColor:HotelLightGrayColor font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft text:@"123条点评"];
    [self.contentView addSubview:_commentLabel];
    
    UILabel *point = [UILabel createLabelWithFrame:CGRectMake(CGRectGetMaxX(_pointLabel.frame), _commentLabel.frame.origin.y, 20, _commentLabel.frame.size.height) textColor:_pointLabel.textColor font:_commentLabel.font textAlignment:NSTextAlignmentLeft text:@"分"];
    [self.contentView addSubview:point];
    
    _typeLabel = [UILabel createLabelWithFrame:CGRectMake(_titleLabel.frame.origin.x, CGRectGetMaxY(_pointLabel.frame), 100, 20) textColor:_commentLabel.textColor font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft text:@"高档型"];
    [self.contentView addSubview:_typeLabel];
    
    _locationLabel = [UILabel createLabelWithFrame:CGRectMake(_titleLabel.frame.origin.x, CGRectGetMaxY(_typeLabel.frame), 200, _typeLabel.frame.size.height) textColor:_typeLabel.textColor font:_typeLabel.font textAlignment:NSTextAlignmentLeft text:@"芙蓉区"];
    [self.contentView addSubview:_locationLabel];
    
    _availableTimeLabel = [UILabel createLabelWithFrame:_locationLabel.frame textColor:_locationLabel.textColor font:_locationLabel.font textAlignment:NSTextAlignmentLeft text:@"6:00-18:00可住"];
    _availableTimeLabel.hidden = YES;
    [self.contentView addSubview:_availableTimeLabel];
    
    _reserveLabel = [UILabel createLabelWithFrame:CGRectMake(APPScreenWidth - 200 - 10, _typeLabel.frame.origin.y, 200, _typeLabel.frame.size.height) textColor:_typeLabel.textColor font:_typeLabel.font textAlignment:NSTextAlignmentRight text:@"1小时前有人预定"];
    [self.contentView addSubview:_reserveLabel];
    
    _priceLabel = [UILabel createLabelWithFrame:CGRectMake(APPScreenWidth - 200 - 10, CGRectGetMinY(_reserveLabel.frame) - 25, 200, 25) textColor:[UIColor redColor] font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentRight text:@"￥259"];
    [self.contentView addSubview:_priceLabel];
}

- (void)setRommType:(int)rommType {
    _rommType = rommType;
    if (rommType == 0) {
        _availableTimeLabel.hidden = YES;
    } else if (rommType == 1) {
        _availableTimeLabel.hidden = NO;
        CGRect locationFrame = _locationLabel.frame;
        locationFrame.origin.y = CGRectGetMaxY(_availableTimeLabel.frame);
        _locationLabel.frame = locationFrame;
    }
}

- (void)setData:(HotelHomeListModel *)data {
    _data = data;
    _titleLabel.text = data.hotleName;
    [UIImageView hotelSetImageWithImageView:_iconImageView UrlString:data.photoUrl imageVersion:nil];
    _pointLabel.text = [NSString stringWithFormat:@"%.1f",data.score];
    _commentLabel.text = [NSString stringWithFormat: @"%ld条点评",data.rateCount];
    _typeLabel.text = data.hotelLev;
    _locationLabel.text = data.district;
    _priceLabel.text = [NSString stringWithFormat:@"￥%ld",data.noMemeberPrice.integerValue];
}

@end
