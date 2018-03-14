//
//  HotelCommentFaceTableViewCell.m
//  Portal
//
//  Created by ifox on 2017/4/28.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelCommentFaceTableViewCell.h"
#import "CWStarRateView.h"
#import "UILabel+CreateLabel.h"

@interface HotelCommentFaceTableViewCell ()<CWStarRateViewDelegate>

@property(nonatomic, strong) UILabel *title;
@property(nonatomic, strong) CWStarRateView *starView;
@property(nonatomic, strong) UILabel *rateLabel;

@end

@implementation HotelCommentFaceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _title = [UILabel createLabelWithFrame:CGRectMake(10, 10, 40, 20) textColor:HotelGrayColor font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft text:NSLocalizedString(@"HotelCommentService", nil)];
    [self.contentView addSubview:_title];
    
    _starView = [[CWStarRateView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_title.frame), 7, 180, 25) numberOfFaces:5];
    _starView.delegate = self;
    [self.contentView addSubview:_starView];
    
    _rateLabel = [UILabel createLabelWithFrame:CGRectMake(APPScreenWidth - 10 - 40 , _title.frame.origin.y, 40, _title.frame.size.height) textColor:HotelYellowColor font:_title.font textAlignment:NSTextAlignmentRight text:NSLocalizedString(@"HotelCommentRateExc", nil)];
    [self.contentView addSubview:_rateLabel];
    
    
}

- (void)setCellTitle:(NSString *)cellTitle {
    _cellTitle = cellTitle;
    _title.text = cellTitle;
}

- (void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent {
    NSLog(@"%f",newScorePercent);
    if (newScorePercent == 0.2) {
        _rateLabel.text = NSLocalizedString(@"HotelCommentTer", nil);
    } else if (newScorePercent == 0.4) {
        _rateLabel.text = NSLocalizedString(@"HotelCommentRateBad", nil);
    } else if (newScorePercent == 0.6) {
        _rateLabel.text = NSLocalizedString(@"HotelCommentRateNor", nil);
    } else if (newScorePercent == 0.8) {
        _rateLabel.text = NSLocalizedString(@"HotelCommentRateGood", nil);
    } else {
        _rateLabel.text = NSLocalizedString(@"HotelCommentRateExc", nil);
    }
    if ([self.delegate respondsToSelector:@selector(cellRating:andCell:)]) {
        [self.delegate cellRating:newScorePercent*5 andCell:self];
    }
}

@end
