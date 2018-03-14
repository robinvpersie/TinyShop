//
//  HotelCommentStarTableViewCell.h
//  Portal
//
//  Created by ifox on 2017/4/28.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStarRatingView.h"

@protocol HotelCommentStarTableViewCellDelegate <NSObject>

@optional

- (void)HotelCommentStarTableViewCellScore:(float)score;

@end

@interface HotelCommentStarTableViewCell : UITableViewCell<StarRatingsViewDelegate>

@property(nonatomic, weak) id<HotelCommentStarTableViewCellDelegate> delegate;

@end
