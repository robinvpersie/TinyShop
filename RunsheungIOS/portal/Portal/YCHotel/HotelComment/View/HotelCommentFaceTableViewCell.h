//
//  HotelCommentFaceTableViewCell.h
//  Portal
//
//  Created by ifox on 2017/4/28.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HotelCommentFaceTableViewCell;

@protocol HotelCommentFaceTableViewCellDelegate <NSObject>

@optional

- (void)cellRating:(NSInteger)rating andCell:(HotelCommentFaceTableViewCell *)cell;

@end

@interface HotelCommentFaceTableViewCell : UITableViewCell

@property(nonatomic, weak) id<HotelCommentFaceTableViewCellDelegate> delegate;

@property(nonatomic, copy) NSString *cellTitle;

@end
