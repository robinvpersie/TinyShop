//
//  KLVoteActionView.m
//  Portal
//
//  Created by 左梓豪 on 2016/12/3.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "KLVoteActionView.h"
#import "VoteData.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define kAppScreenWidth [UIScreen mainScreen].bounds.size.width

@implementation KLVoteActionView {
    UIImageView *imageView1;
    UIImageView *imageView2;
    UIImageView *imageView3;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    UIView *recommendBg = [[UIView alloc] initWithFrame:CGRectMake(0,0, kAppScreenWidth, 40)];
    recommendBg.backgroundColor = [UIColor whiteColor];
    [self addSubview:recommendBg];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
    icon.image = [UIImage imageNamed:@"icon_vote"];
    [recommendBg addSubview:icon];
    
    UILabel *recommendLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+10, icon.frame.origin.y, 100, icon.frame.size.height)];
    recommendLabel.text = @"投票活动";
    recommendLabel.font = [UIFont systemFontOfSize:15];
    [recommendBg addSubview:recommendLabel];
    
//    UIButton *moreArrow = [UIButton buttonWithType:UIButtonTypeCustom];
//    moreArrow.frame = CGRectMake(kAppScreenWidth - 20 - 15, icon.frame.origin.y, 20, 20);
//    [moreArrow setImage:[UIImage imageNamed:@"icon_more_001"] forState:UIControlStateNormal];
//    [moreArrow addTarget:self action:@selector(getMoreVoteAction) forControlEvents:UIControlEventTouchUpInside];
//    [recommendBg addSubview:moreArrow];
    
//    UIButton *moreTitle = [UIButton buttonWithType:UIButtonTypeCustom];
//    moreTitle.frame = CGRectMake(CGRectGetMinX(moreArrow.frame) - 30, 7, 30, 25);
//    [moreTitle setTitle:@"更多" forState:UIControlStateNormal];
//    moreTitle.titleLabel.font = [UIFont systemFontOfSize:13];
//    [moreTitle setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [recommendBg addSubview:moreTitle];
    
    imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(icon.frame.origin.x, CGRectGetMaxY(recommendBg.frame), kAppScreenWidth - 40, 150)];
    imageView1.layer.cornerRadius = 5.0f;
    imageView1.clipsToBounds = YES;
    imageView1.userInteractionEnabled = YES;
//    imageView1.image = [UIImage imageNamed:@"256252.jpg"];
    [self addSubview:imageView1];
    
    imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(icon.frame.origin.x, CGRectGetMaxY(imageView1.frame)+10, (kAppScreenWidth-60)/2+5, 110)];
    imageView2.layer.cornerRadius = 5.0f;
    imageView2.clipsToBounds = YES;
    imageView2.userInteractionEnabled = YES;
//    imageView2.image = [UIImage imageNamed:@"256252.jpg"];
    [self addSubview:imageView2];
    
    imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView2.frame)+10, CGRectGetMaxY(imageView1.frame)+10, (kAppScreenWidth-60)/2+5, 110)];
    imageView3.layer.cornerRadius = 5.0f;
    imageView3.clipsToBounds = YES;
    imageView3.userInteractionEnabled = YES;
//    imageView3.image = [UIImage imageNamed:@"256252.jpg"];
    [self addSubview:imageView3];
    
    CGRect frame = self.frame;
    frame.size.height = CGRectGetMaxY(imageView2.frame);
    self.frame = frame;
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    [self reloadImageData];
}

- (void)reloadImageData {
    VoteData *theData;
//    for (VoteData *data in _dataArray) {
//        NSString *bigOrS = data.type;
//        if ([bigOrS isEqualToString:@"b"]) {
//            [imageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",data.imgUrl]]];
//            theData = data;
//            
//        }
//    }
//    [_dataArray removeObject:theData];
// 
//    for (int i = 0; i < 2; i++) {
//        if (i == 0) {
//            VoteData *data = _dataArray[i];
//            [imageView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",data.imgUrl]]];
//        } else {
//            VoteData *data = _dataArray[i];
//            [imageView3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",data.imgUrl]]];
//        }
//        
//    }
    for (int i = 0; i < 3; i++) {
        if (i == 0) {
            VoteData *data = _dataArray[i];
            [imageView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",data.imgUrl]]];
        }else if ( i == 1) {
            VoteData *data = _dataArray[i];
            [imageView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",data.imgUrl]]];
        }
        else
        {
            VoteData *data = _dataArray[i];
            [imageView3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",data.imgUrl]]];
        }
        
    }
}

- (void)getMoreVoteAction {
    
}

@end
