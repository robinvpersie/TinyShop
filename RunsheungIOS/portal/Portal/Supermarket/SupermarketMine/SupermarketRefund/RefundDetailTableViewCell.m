//
//  RefundDetailTableViewCell.m
//  Portal
//
//  Created by ifox on 2017/3/17.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "RefundDetailTableViewCell.h"
#import "UILabel+CreateLabel.h"

#define BGGREEN @"ajbg"
#define BGGRAY  @"mabg"
#define BGRED   @"hjbg"
#define BGWIDTH (APPScreenWidth - 15 * 2)

@implementation RefundDetailTableViewCell {
    UILabel *_title;
    UILabel *_msg;
    UIView *_line;
    UIImageView *_backGround;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    if (_backGround == nil) {
        _backGround = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, BGWIDTH, 70)];
        _backGround.image = [UIImage imageNamed:BGGREEN];
    }
    [self.contentView addSubview:_backGround];
    
    if (_title == nil) {
        _title = [UILabel createLabelWithFrame:CGRectMake(15 + 5, 0, APPScreenWidth - 15*2 -10, 35) textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:17] textAlignment:NSTextAlignmentLeft text:nil];
        _title.text = @"卖家已同意申请";
        _title.numberOfLines = 0;
    }
    [self.contentView addSubview:_title];
    
    if (_line == nil) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(15 + 5, CGRectGetMaxY(_title.frame), APPScreenWidth - 15*2 - 10, 0.5f)];
        _line.backgroundColor = [UIColor whiteColor];
    }
    [self.contentView addSubview:_line];
    
    if (_msg == nil) {
        _msg = [UILabel createLabelWithFrame:CGRectZero textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft text:nil];
        _msg.numberOfLines = 0;
    }
    [self.contentView addSubview:_msg];
}

- (void)setData:(RefundDetailModel *)data {
    _data = data;
    switch (data.operateType) {
        case RefundOperateTypeSeller:
            _title.text = data.stepStatus;
            _backGround.image = [UIImage imageNamed:BGGREEN];  
            _msg.frame = CGRectMake(_title.frame.origin.x, CGRectGetMaxY(_line.frame), _title.frame.size.width, data.contentHeight+20);
            _msg.text = data.content;
            _backGround.frame = CGRectMake(10, 0, BGWIDTH, CGRectGetMaxY(_msg.frame));
            break;
            
        case RefundOperateTypeBuyer:
            _title.text = data.stepStatus;
            _backGround.image = [UIImage imageNamed:BGGRAY];
            _msg.frame = CGRectMake(_title.frame.origin.x, CGRectGetMaxY(_line.frame), _title.frame.size.width, data.contentHeight+20);
            _msg.text = data.content;
            _backGround.frame = CGRectMake(15, 0, BGWIDTH + 5, CGRectGetMaxY(_msg.frame));
            
            _title.textColor = [UIColor darkcolor];
            _msg.textColor = [UIColor darkGrayColor];
            _line.backgroundColor = RGB(225, 225, 225);
            break;
            
        case RefundOperateTypeSystem:
            _title.text = data.stepStatus;
            _backGround.image = [UIImage imageNamed:BGGREEN];
            _msg.frame = CGRectMake(_title.frame.origin.x, CGRectGetMaxY(_line.frame), _title.frame.size.width, data.contentHeight+20);
            
            _msg.text = data.content;
            _backGround.frame = CGRectMake(10, 0, BGWIDTH, CGRectGetMaxY(_msg.frame));
            break;
            
        default:
            break;
    }
    
    if (data.finished.integerValue == 1) {
        _backGround.image = [UIImage imageNamed:BGRED];
    }
    _title.text = data.stepStatus;
}


@end
