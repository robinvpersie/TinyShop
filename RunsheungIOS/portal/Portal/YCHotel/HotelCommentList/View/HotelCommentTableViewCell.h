//
//  HotelCommentTableViewCell.h
//  Portal
//
//  Created by ifox on 2017/5/3.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelCommentModel.h"

@class HotelCommentTableViewCell;

@protocol HotelCommentTableViewCellDeletage <NSObject>

@optional

- (void)hotelCommentReplyExpandingWithCell:(HotelCommentTableViewCell *)cell
                               commentData:(HotelCommentModel *)commentData;

@end

@interface HotelCommentTableViewCell : UITableViewCell

@property(nonatomic, strong) HotelCommentModel *commentModel;

@property(nonatomic, weak) id<HotelCommentTableViewCellDeletage> delegate;

@end
