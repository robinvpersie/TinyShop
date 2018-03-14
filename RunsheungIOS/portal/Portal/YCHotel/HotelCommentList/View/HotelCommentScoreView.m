//
//  HotelCommentScoreView.m
//  Portal
//
//  Created by ifox on 2017/5/4.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelCommentScoreView.h"
#import "TQStarRatingView.h"
#import "UILabel+CreateLabel.h"
#import "UILabel+WidthAndHeight.h"

@implementation HotelCommentScoreView {
    TQStarRatingView *_starView;
    
    UIProgressView *_serviceProgress;
    UIProgressView *_facilityProgress;
    UIProgressView *_locationProgress;
    UIProgressView *_hygieneProgress;
    
    UILabel *_totalScoreLabel;
    
    UILabel *_serviceScoreLabel;
    UILabel *_facilityScoreLabel;
    UILabel *_locationScoreLabel;
    UILabel *_hygieneScoreLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BGColor;
        [self createView];
    }
    return self;
}

- (void)createView {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 0)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    _starView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(15, 10, 150, 15) numberOfStar:5];
    _starView.userInteractionEnabled = NO;
    [bgView addSubview:_starView];
    
    _totalScoreLabel = [UILabel createLabelWithFrame:CGRectMake(CGRectGetMaxX(_starView.frame)+5, 5, 50, 30) textColor:HotelYellowColor font:[UIFont systemFontOfSize:17] textAlignment:NSTextAlignmentLeft text:@"4.0分"];
    [bgView addSubview:_totalScoreLabel];
    
    CGFloat titleWidth = [UILabel getWidthWithTitle:NSLocalizedString(@"HotelCommentService", nil) font:[UIFont systemFontOfSize:13]];
    CGFloat progressWidth = APPScreenWidth/2 - 15 - titleWidth - 60;
    NSArray *titles = @[NSLocalizedString(@"HotelCommentService", nil),NSLocalizedString(@"HotelCommentFacility", nil),NSLocalizedString(@"HotelCommentEnv", nil),NSLocalizedString(@"HotelCommentHygiene", nil)];
    for (int i = 0; i < 4; i++) {
        UILabel *label = [UILabel createLabelWithFrame:CGRectZero textColor:HotelBlackColor font:[UIFont systemFontOfSize:13] textAlignment:NSTextAlignmentLeft text:titles[i]];
        label.frame = CGRectMake(15*((i+1)%2) + APPScreenWidth/2*(i%2), 25*(i/2)+CGRectGetMaxY(_totalScoreLabel.frame), titleWidth, 25);
        [bgView addSubview:label];
        
        UIProgressView *progress = [[UIProgressView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+5, label.frame.origin.y+12, progressWidth, 1.2f)];
        progress.tintColor = HotelYellowColor;
        progress.trackTintColor = BorderColor;
        progress.progress = 0.8;
        [bgView addSubview:progress];
        
        UILabel *scoreLabel = [UILabel createLabelWithFrame:CGRectMake(CGRectGetMaxX(progress.frame)+5, label.frame.origin.y, 40, label.frame.size.height) textColor:HotelYellowColor font:[UIFont systemFontOfSize:13] textAlignment:NSTextAlignmentLeft text:@"4.2"];
        [bgView addSubview:scoreLabel];
        if (i == 0) {
            _serviceProgress = progress;
            _serviceScoreLabel = scoreLabel;
        }
    
        if (i == 1) {
            _facilityProgress = progress;
            _facilityScoreLabel = scoreLabel;
        }
        
        if (i == 2) {
           _locationProgress = progress;
            _locationScoreLabel = scoreLabel;
        }
        
        if (i == 3) {
            _hygieneProgress = progress;
            _hygieneScoreLabel = scoreLabel;
        }
    }
    
    CGRect bgFrame = bgView.frame;
    bgFrame.size.height = CGRectGetMaxY(_locationScoreLabel.frame)+15;
    bgView.frame = bgFrame;
    
    CGRect selfFrame = self.frame;
    selfFrame.size.height = CGRectGetMaxY(bgFrame)+15;
    self.frame = selfFrame;
}

- (void)setTotalScore:(float)totalScore {
    _totalScore = totalScore;
    [_starView setScore:totalScore/5 withAnimation:NO];
    _totalScoreLabel.text = [NSString stringWithFormat:@"%.1f",totalScore];
}

- (void)setServiceScore:(float)serviceScore {
    _serviceScore = serviceScore;
    _serviceScoreLabel.text = [NSString stringWithFormat:@"%.1f",serviceScore];
    _serviceProgress.progress = serviceScore/5.0;
}

- (void)setFacilityScore:(float)facilityScore {
    _facilityScore = facilityScore;
    _facilityScoreLabel.text = [NSString stringWithFormat:@"%.1f",facilityScore];
    _facilityProgress.progress = facilityScore/5.0;
}

- (void)setLocationScore:(float)locationScore {
    _locationScore = locationScore;
    _locationScoreLabel.text = [NSString stringWithFormat:@"%.1f",locationScore];
    _locationProgress.progress = locationScore/5.0;
}

- (void)setHygieneScore:(float)hygieneScore {
    _hygieneScore = hygieneScore;
    _hygieneScoreLabel.text = [NSString stringWithFormat:@"%.1f",hygieneScore];
    _hygieneProgress.progress = hygieneScore/5.0;
}

@end
