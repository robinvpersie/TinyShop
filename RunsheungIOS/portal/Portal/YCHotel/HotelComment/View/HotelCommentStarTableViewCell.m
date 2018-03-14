//
//  HotelCommentStarTableViewCell.m
//  Portal
//
//  Created by ifox on 2017/4/28.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelCommentStarTableViewCell.h"
#import "UILabel+CreateLabel.h"

@implementation HotelCommentStarTableViewCell {
    UILabel *_scoreLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    UILabel *title = [UILabel createLabelWithFrame:CGRectMake(10, 15, 40, 30) textColor:HotelGrayColor font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft text:NSLocalizedString(@"HotelCommentScore", nil)];
    [self.contentView addSubview:title];
    
    _scoreLabel = [UILabel createLabelWithFrame:CGRectMake(APPScreenWidth - 10 - 40, title.frame.origin.y, 40, title.frame.size.height) textColor:HotelYellowColor font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentRight text:@"5.0分"];
    [self.contentView addSubview:_scoreLabel];
    
    TQStarRatingView *starView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(title.frame), 17, 180, 25) numberOfStar:5];
    starView.delegate = self;
    [self.contentView addSubview:starView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 59, APPScreenWidth, 0.5f)];
    line.backgroundColor = BorderColor;
    [self.contentView addSubview:line];
}

- (void)starRatingView:(TQStarRatingView *)view score:(float)score {
    NSLog(@"%f",score);
    score = score * 5;
    _scoreLabel.text = [NSString stringWithFormat:@"%.1f%@",score,NSLocalizedString(@"HotelScore", nil)];
    if ([self.delegate respondsToSelector:@selector(HotelCommentStarTableViewCellScore:)]) {
        [self.delegate HotelCommentStarTableViewCellScore:score];
    }
}

@end
