//
//  HotelMineHeaderView.m
//  Portal
//
//  Created by ifox on 2017/4/23.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelMineHeaderView.h"
#import "UILabel+CreateLabel.h"

@implementation HotelMineHeaderView {
    UIImageView *avatar;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.image = [UIImage imageNamed:@"hotel_headerbg"];
        
        [self createView];
    }
    return self;
}

- (void)createView {
    avatar = [[UIImageView alloc] initWithFrame:CGRectMake(30, self.frame.size.height/2 - 30, 60, 60)];
    avatar.layer.cornerRadius = 30;
    avatar.image = [UIImage imageNamed:@"avatar"];
    avatar.clipsToBounds = YES;
    [self addSubview:avatar];
    
    UIVisualEffectView *avatarBg = [[UIVisualEffectView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
    avatarBg.layer.cornerRadius = 32;
    avatarBg.clipsToBounds = YES;
    avatarBg.center = avatar.center;
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    avatarBg.effect = effect;
    [self insertSubview:avatarBg belowSubview:avatar];
    
    UILabel *phone = [UILabel createLabelWithFrame:CGRectMake(CGRectGetMaxX(avatar.frame)+20, avatar.center.y - 15, 200, 30) textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:20] textAlignment:NSTextAlignmentLeft text:@""];
    YCAccountModel *model = [YCAccountModel getAccount];
    if (model.memid) {
        phone.text = model.memid;
        [UIImageView hotelSetImageWithImageView:avatar UrlString:model.avatarPath imageVersion:nil];
    } else {
        phone.text = @"立即登录";
    }
    [self addSubview:phone];
}

@end
