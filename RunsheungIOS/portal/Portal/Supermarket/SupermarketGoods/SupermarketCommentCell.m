//
//  SupermarketCommentCell.m
//  Portal
//
//  Created by ifox on 2016/12/17.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketCommentCell.h"
#import "StarView.h"
#import "CWStarRateView.h"
#import "UILabel+WidthAndHeight.h"
#import "SupermarketCommentPicCollectionView.h"
#import "UILabel+CreateLabel.h"
#import "UIImageView+ImageCache.h"

#define ImageViewHeight     100
#define AvatarViewHeight    30
#define Space               15
#define BackgroudHiegh      140

@implementation SupermarketCommentCell {
    UIImageView                         *_avatarImageView;
    UILabel                             *_nickNameLabel;
    CWStarRateView                      *_starView;
    UILabel                             *_contentLabel;
    UILabel                             *_timeLabel;//发送时间
    UIButton                            *_likeButton;//点赞按钮
    UIButton                            *_likeContentButton;//点赞文字按钮
    SupermarketCommentPicCollectionView *_commentCollectionView;
    
    UIView                              *_commentWithPicBgView;//用于放图片和点赞按钮
    UILabel                             *_viewTimeLabel;//浏览次数
    
    NSString                            *_commentId;
    
    UIView                              *_goodBGView;
    UIImageView                         *_iconImage;
    UILabel                             *_goodsName;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)initView {
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Space, 8, AvatarViewHeight, AvatarViewHeight)];
        _avatarImageView.clipsToBounds = YES;
        _avatarImageView.image = [UIImage imageNamed:@"avatar"];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.layer.cornerRadius = AvatarViewHeight/2;
    }
    [self.contentView addSubview:_avatarImageView];
    
    if (_nickNameLabel == nil) {
        _nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_avatarImageView.frame)+10, _avatarImageView.frame.origin.y,120, AvatarViewHeight)];
        _nickNameLabel.font = [UIFont systemFontOfSize:13];
        _nickNameLabel.textColor = [UIColor darkGrayColor];
        _nickNameLabel.text = @"青涩年代";
    }
    [self.contentView addSubview:_nickNameLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(_avatarImageView.frame.origin.x, CGRectGetMaxY(_avatarImageView.frame)+10, APPScreenWidth - Space, 1)];
    line.backgroundColor = BGColor;
    [self.contentView addSubview:line];
    
    if (_starView == nil) {
        _starView = [[CWStarRateView alloc] initWithFrame:CGRectMake(Space, CGRectGetMaxY(line.frame)+10, 120, 15)];
        _starView.userInteractionEnabled = NO;
        _starView.scorePercent = 0.8;
    }
    [self.contentView addSubview:_starView];
    
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(Space,CGRectGetMaxY(_starView.frame)+5, APPScreenWidth - Space - 10, 30)];
        _contentLabel.textColor = [UIColor darkGrayColor];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
        _contentLabel.text = @"非常满意,发货飞速,快递也飞速,辣椒有啦邮箱,非常满意,发货飞速,快递也飞速,辣椒有啦邮箱";
    }
    [self.contentView addSubview:_contentLabel];
    
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(Space, CGRectGetMaxY(_contentLabel.frame), 200, 20)];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.text = @"2016-11-14";
    }
    [self.contentView addSubview:_timeLabel];
    
    //以下为带图片的视图
    if (_commentWithPicBgView == nil) {
        _commentWithPicBgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_timeLabel.frame), APPScreenWidth, 0)];
        _commentWithPicBgView.backgroundColor = [UIColor whiteColor];
    }
    _commentWithPicBgView.hidden = YES;
    [self.contentView addSubview:_commentWithPicBgView];
    
    if (_commentCollectionView == nil) {
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
        layOut.minimumInteritemSpacing = 0;
        layOut.minimumLineSpacing = 0;
        layOut.itemSize = CGSizeMake(ImageViewHeight, ImageViewHeight);
        layOut.sectionInset = UIEdgeInsetsMake(2, 0, 2, 0);
        layOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _commentCollectionView = [[SupermarketCommentPicCollectionView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, ImageViewHeight) collectionViewLayout:layOut];
        _commentCollectionView.contentInset = UIEdgeInsetsMake(0, Space, 0, Space);
    }
    [_commentWithPicBgView addSubview:_commentCollectionView];
    
    if (_likeButton == nil) {
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeButton.frame = CGRectMake(APPScreenWidth - 10 - 20, 0, 20, 20);
        [_likeButton setImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateSelected];
        [_likeButton addTarget:self action:@selector(clikeLikeButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    [_commentWithPicBgView addSubview:_likeButton];
    
    if (_likeContentButton == nil) {
        _likeContentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeContentButton.frame = CGRectZero;
        [_likeContentButton setTitle:NSLocalizedString(@"SMCommentLikeButtonTitle", nil) forState:UIControlStateNormal];
        [_likeContentButton setTitle:NSLocalizedString(@"SMCommentAlreadyLikeButtonTitle", nil) forState:UIControlStateSelected];
        [_likeContentButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_likeContentButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        _likeContentButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _likeContentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_likeContentButton addTarget:self action:@selector(clikeLikeButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    [_commentWithPicBgView addSubview:_likeContentButton];
    
    if (_viewTimeLabel == nil) {
        _viewTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _viewTimeLabel.textColor = [UIColor lightGrayColor];
        _viewTimeLabel.font = [UIFont systemFontOfSize:12];
        _viewTimeLabel.text = @"浏览23次";
        _viewTimeLabel.hidden = YES;
    }
    [_commentWithPicBgView addSubview:_viewTimeLabel];
    
    if (_goodBGView == nil) {
        _goodBGView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, APPScreenWidth - 30, 75)];
        _goodBGView.backgroundColor = RGB(245, 245, 245);
        _goodBGView.hidden = YES;
    }
    [self.contentView addSubview:_goodBGView];
    
    if (_iconImage == nil) {
        _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 55, 55)];
    }
    [_goodBGView addSubview:_iconImage];
    
    if (_goodsName == nil) {
        _goodsName = [UILabel createLabelWithFrame:CGRectMake(CGRectGetMaxX(_iconImage.frame)+10, _iconImage.frame.origin.y, _goodBGView.frame.size.width - 10 - 10 - 55 - 10, 55) textColor:[UIColor darkcolor] font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft text:@""];
        _goodsName.numberOfLines = 0;
    }
    [_goodBGView addSubview:_goodsName];
}

-(void)setModel:(SPCommentModel *)model {
    _contentLabel.text = model.saleContent;
    _nickNameLabel.text = model.nickname;
    _timeLabel.text = model.regdate;
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.imagePath]];
    [_likeContentButton setTitle:model.rnm forState:UIControlStateNormal];
    _goodsName.text = model.customname;
}

- (void)setCommentData:(SupermarketCommentData *)commentData {
    _contentLabel.text = commentData.content;
    _nickNameLabel.text = commentData.userID;
    _commentId = [NSString stringWithFormat:@"%@",commentData.commentID];
    _timeLabel.text = commentData.sendTime;
    [_likeContentButton setTitle:[NSString stringWithFormat:@"%ld",commentData.likeAmount] forState:UIControlStateNormal];
    if (commentData.hasLikes.integerValue == 1) {
        _likeButton.selected = YES;
        _likeContentButton.selected = YES;
        [_likeContentButton setTitle:[NSString stringWithFormat:@"%ld",commentData.likeAmount] forState:UIControlStateNormal];
    }
    [UIImageView setimageWithImageView:_avatarImageView UrlString:commentData.avatarUrlString imageVersion:nil];
    
    if (commentData.type == ContentOnly) {
        [self resetContentOnlyFrameWithData:commentData];
    }
    
    if (commentData.type == ContentWithImages) {
        [self resetContentOnlyFrameWithData:commentData];
        [self resetContentWithImagesWithData:commentData];
        _commentCollectionView.imageArray = commentData.images;
    }
    if (self.commentControllerType == 1) {
        _goodBGView.hidden = NO;
        _goodBGView.frame = CGRectMake(15, commentData.height, APPScreenWidth - 30, 75);
        [UIImageView setimageWithImageView:_iconImage UrlString:commentData.image_url imageVersion:nil];
        _goodsName.text = commentData.item_name;
    }
    
}

- (void)resetContentOnlyFrameWithData:(SupermarketCommentData *)commentData {
    _starView.scorePercent = commentData.rating;
    
    CGRect contentLabelFrame = _contentLabel.frame;
    CGFloat height = [UILabel getHeightByWidth:_contentLabel.frame.size.width title:commentData.content font:_contentLabel.font];
    contentLabelFrame.size.height = height;
    _contentLabel.frame = contentLabelFrame;
    
    CGRect timeFrame = _timeLabel.frame;
    timeFrame.origin.y = CGRectGetMaxY(_contentLabel.frame);
    _timeLabel.frame = timeFrame;
}

- (void)resetContentWithImagesWithData:(SupermarketCommentData *) commentData {
    _commentWithPicBgView.hidden = NO;
    _commentWithPicBgView.frame = CGRectMake(0, CGRectGetMaxY(_timeLabel.frame)+5, APPScreenWidth, BackgroudHiegh);
    
    _viewTimeLabel.frame = CGRectMake(Space, CGRectGetMaxY(_commentCollectionView.frame)+10, 120, 20);
    _likeButton.frame = CGRectMake(APPScreenWidth - 10 - 20, _viewTimeLabel.frame.origin.y, 20, _viewTimeLabel.frame.size.height);
    _likeContentButton.frame = CGRectMake(CGRectGetMinX(_likeButton.frame)-40-10, _likeButton.frame.origin.y, 40, _likeButton.frame.size.height);
	CGRect timeFrame = _timeLabel.frame;
	timeFrame.origin.y = CGRectGetMaxY(_commentWithPicBgView.frame) - 30;
	_timeLabel.frame = timeFrame;
	
	UILabel *timelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetHeight(_commentWithPicBgView.frame) - 36, 200, 30)];
	timelabel.textColor = RGB(171, 171, 171);
	timelabel.font = [UIFont systemFontOfSize:12];
	timelabel.text = commentData.sendTime;
	[_commentWithPicBgView addSubview:timelabel];
}

- (void)clikeLikeButton:(UIButton *)button {
    if (button.selected == YES) {
        return;
    }
    button.selected = !button.selected;
    
    NSLog(@"%@",self.commentData);
    
    if (button.selected) {
        [KLHttpTool sendLikeToSupermarketGoodsCommentsWithCommentsID:[NSString stringWithFormat:@"%@",_commentId] success:^(id response) {
            NSLog(@"%@",response);
        } failure:^(NSError *err) {
            
        }];
    }
    if (button == _likeButton) {
        _likeContentButton.selected = button.selected;
    }
    
    if (button == _likeContentButton) {
        _likeButton.selected = button.selected;
    }
}

@end
