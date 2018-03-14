//
//  HotelCommentTableViewCell.m
//  Portal
//
//  Created by ifox on 2017/5/3.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelCommentTableViewCell.h"
#import "TQStarRatingView.h"
#import "UILabel+CreateLabel.h"
#import "UIButton+CreateButton.h"
#import "UILabel+WidthAndHeight.h"
#import "SupermarketCommentPicCollectionView.h"

#define Space               12
#define BackgroundHeight    140
#define ImageViewHeight     100

@implementation HotelCommentTableViewCell {
    UILabel                             *_nameLabel;
    TQStarRatingView                    *_starView;
    UILabel                             *_timeLabel;
    UILabel                             *_roomTypeName;
    UILabel                             *_contentLabel;
    SupermarketCommentPicCollectionView *_commentCollectionView;
    
    UIButton                            *_checkReply;//查看酒店回复
    UIView                              *_replayBGView;
    UILabel                             *_replyLabel;//酒店回复
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)createSubView {
    if (_nameLabel == nil) {
        _nameLabel = [UILabel createLabelWithFrame:CGRectMake(Space, 8, 70, 30) textColor:HotelBlackColor font:[UIFont systemFontOfSize:13] textAlignment:NSTextAlignmentLeft text:@"牧濑红莉栖"];
    }
    [self.contentView addSubview:_nameLabel];
    
    if (_starView == nil) {
        _starView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nameLabel.frame), _nameLabel.frame.origin.y+8, 100, 13) numberOfStar:5];
        _starView.userInteractionEnabled = NO;
    }
    [self.contentView addSubview:_starView];
    
    if (_timeLabel == nil) {
        _timeLabel = [UILabel createLabelWithFrame:CGRectMake(APPScreenWidth - Space - 120, _nameLabel.frame.origin.y, 120, _nameLabel.frame.size.height) textColor:HotelLightGrayColor font:[UIFont systemFontOfSize:10] textAlignment:NSTextAlignmentRight text:@"2017-03-16"];
    }
    [self.contentView addSubview:_timeLabel];
    
    if (_contentLabel == nil) {
        _contentLabel = [UILabel createLabelWithFrame:CGRectMake(_nameLabel.frame.origin.x, CGRectGetMaxY(_nameLabel.frame)+5, APPScreenWidth - Space*2, 0) textColor:HotelGrayColor font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft text:@"酒店很好很好,五楼的小姐姐很可爱,服务也很好,下次还选99号!!特别爱她的小嘴!!"];
        _contentLabel.numberOfLines = 0;
    }
    [self.contentView addSubview:_contentLabel];
    
    if (_commentCollectionView == nil) {
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
        layOut.minimumInteritemSpacing = 0;
        layOut.minimumLineSpacing = 0;
        layOut.itemSize = CGSizeMake(ImageViewHeight, ImageViewHeight);
        layOut.sectionInset = UIEdgeInsetsMake(2, 0, 2, 0);
        layOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _commentCollectionView = [[SupermarketCommentPicCollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_contentLabel.frame), APPScreenWidth, 0) collectionViewLayout:layOut];
        _commentCollectionView.contentInset = UIEdgeInsetsMake(0, Space, 0, Space);
    }
    [self.contentView addSubview:_commentCollectionView];

    
    if (_roomTypeName == nil) {
        _roomTypeName = [UILabel createLabelWithFrame:CGRectMake(_nameLabel.frame.origin.x, CGRectGetMaxY(_contentLabel.frame)+5, 100, 20) textColor:HotelLightGrayColor font:[UIFont systemFontOfSize:10] textAlignment:NSTextAlignmentLeft text:@"高级大床房"];
    }
    [self.contentView addSubview:_roomTypeName];
    
    if (_checkReply == nil) {
        CGFloat width = [UILabel getWidthWithTitle:NSLocalizedString(@"HotelCheckCommentTitle", nil) font:[UIFont systemFontOfSize:12]];
        _checkReply = [UIButton createButtonWithFrame:CGRectMake(APPScreenWidth - Space - width, _roomTypeName.frame.origin.y, width, 20) title:NSLocalizedString(@"HotelCheckCommentTitle", nil) titleColor:PurpleColor titleFont:[UIFont systemFontOfSize:12] backgroundColor:[UIColor whiteColor]];
        [_checkReply setTitle:NSLocalizedString(@"HotelCloseCommentTitle", nil) forState:UIControlStateSelected];
        [_checkReply addTarget:self action:@selector(checkHotelReply:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.contentView addSubview:_checkReply];
    
    if (_replayBGView == nil) {
        _replayBGView = [[UIView alloc] initWithFrame:CGRectZero];
        _replayBGView.backgroundColor = BGColor;
        _replayBGView.layer.cornerRadius = 4.0f;
        _replayBGView.hidden = YES;
    }
    [self.contentView addSubview:_replayBGView];
    
    if (_replyLabel == nil) {
        _replyLabel = [UILabel createLabelWithFrame:CGRectMake(8, 5, APPScreenWidth - 8*2 - Space*2, 0) textColor:HotelGrayColor font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft text:@""];
        _replyLabel.numberOfLines = 0;
    }
    [_replayBGView addSubview:_replyLabel];
}

- (void)checkHotelReply:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected == YES) {
        self.commentModel.isExpanding = YES;
        _replayBGView.hidden = NO;
    } else {
        self.commentModel.isExpanding = NO;
        _replayBGView.hidden = YES;
    }
    
    if ([self.delegate respondsToSelector:@selector(hotelCommentReplyExpandingWithCell:commentData:)]) {
        [self.delegate hotelCommentReplyExpandingWithCell:self commentData:self.commentModel];
    }
}

- (void)setCommentModel:(HotelCommentModel *)commentModel {
    _commentModel = commentModel;
    
    if (commentModel.isExpanding == YES) {
        _checkReply.selected = YES;
        _replayBGView.hidden = NO;
    }
    
    _nameLabel.text = commentModel.userName;
    [_starView setScore:commentModel.score/5 withAnimation:NO];
    _timeLabel.text = commentModel.commentTime;
    _roomTypeName.text = commentModel.roomTypeName;
    if (!commentModel.hasHotelReply) {
        _checkReply.hidden = YES;
    }
    
    if (commentModel.commentType == HotelCommentTypeContentOnly) {
        _contentLabel.text = commentModel.content;
        _replyLabel.text = commentModel.hotelReply;
        [self resetContentOnlyFrame];
    } else {
        _contentLabel.text = commentModel.content;
        _replyLabel.text = commentModel.hotelReply;
        [self resetContentWithImageFrame];
    }
}

- (void)resetContentOnlyFrame {
    CGRect contentFrame = _contentLabel.frame;
    contentFrame.size.height = _commentModel.contentHeight;
    _contentLabel.frame = contentFrame;
    _roomTypeName.frame = CGRectMake(_nameLabel.frame.origin.x, CGRectGetMaxY(_contentLabel.frame)+5, 100, 20);
    _checkReply.frame = CGRectMake(APPScreenWidth - Space - _checkReply.frame.size.width, _roomTypeName.frame.origin.y, _checkReply.frame.size.width, 20);
    _replayBGView.frame = CGRectMake(Space, CGRectGetMaxY(_checkReply.frame)+5, APPScreenWidth - Space * 2, self.commentModel.replyHeight+10);
    CGRect replyFrame = _replyLabel.frame;
    replyFrame.size.height = self.commentModel.replyHeight;
    _replyLabel.frame = replyFrame;
}

- (void)resetContentWithImageFrame {
    CGRect contentFrame = _contentLabel.frame;
    contentFrame.size.height = _commentModel.contentHeight;
    _contentLabel.frame = contentFrame;
    
    _commentCollectionView.frame = CGRectMake(0, CGRectGetMaxY(_contentLabel.frame), APPScreenWidth, ImageViewHeight);
    _commentCollectionView.imageArray = self.commentModel.images;
    _roomTypeName.frame = CGRectMake(_nameLabel.frame.origin.x, CGRectGetMaxY(_commentCollectionView.frame)+5, 100, 20);
    _checkReply.frame = CGRectMake(APPScreenWidth - Space - _checkReply.frame.size.width, _roomTypeName.frame.origin.y, _checkReply.frame.size.width, 20);
//    _replyLabel.frame = CGRectMake(Space, CGRectGetMaxY(_checkReply.frame)+5, APPScreenWidth - Space * 2, self.commentModel.replyHeight);
    _replayBGView.frame = CGRectMake(Space, CGRectGetMaxY(_checkReply.frame)+5, APPScreenWidth - Space * 2, self.commentModel.replyHeight+10);
    CGRect replyFrame = _replyLabel.frame;
    replyFrame.size.height = self.commentModel.replyHeight;
    _replyLabel.frame = replyFrame;
}

@end
