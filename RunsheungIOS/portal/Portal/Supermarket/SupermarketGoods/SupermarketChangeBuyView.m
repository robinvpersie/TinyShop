//
//  SupermarketChangeBuyView.m
//  Portal
//
//  Created by 左梓豪 on 2016/12/9.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketChangeBuyView.h"

@implementation SupermarketChangeBuyView {
    UILabel *msg;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, self.frame.size.height-16, self.frame.size.height-16)];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    icon.image = [UIImage imageNamed:@"icon_buy"];
//    [self addSubview:icon];
	
    UILabel *buy = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+5, 10, 45, self.frame.size.height-20)];
    buy.font = [UIFont systemFontOfSize:16];
    buy.textColor = [UIColor darkGrayColor];
    buy.text = @"换购:";
//    [self addSubview:buy];
	
    msg = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(buy.frame), 10, self.frame.size.width,self.frame.size.height-20)];
    msg.text = @"满99元可换购香脆玉米,2元换购白豆腐";
    msg.textColor = [UIColor darkGrayColor];
    msg.font = [UIFont systemFontOfSize:13];
//    [self addSubview:msg];
}

- (void)setChangeBuyTitle:(NSString *)changeBuyTitle {
    _changeBuyTitle = changeBuyTitle;
    msg.text = changeBuyTitle;
}

@end
