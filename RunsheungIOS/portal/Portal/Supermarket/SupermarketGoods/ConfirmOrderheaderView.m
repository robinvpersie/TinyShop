//
//  ConfirmOrderheaderView.m
//  Portal
//
//  Created by ifox on 2016/12/26.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "ConfirmOrderheaderView.h"

@implementation ConfirmOrderheaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)setupUI {
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 20, 20)];
    icon.image = [UIImage imageNamed:@"icon_commoditylist"];
    [self.contentView addSubview:icon];
    
    UILabel *goodsList = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+10, icon.frame.origin.y, 120, icon.frame.size.height)];
    goodsList.text = NSLocalizedString(@"SMConfirmOrderHeaderTitle", nil);
    goodsList.textColor = [UIColor darkGrayColor];
    goodsList.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:goodsList];
    
    UIButton *down = [UIButton buttonWithType:UIButtonTypeCustom];
    down.frame = CGRectMake(APPScreenWidth - 25 - 10, icon.frame.origin.y, 20, 20);
    [down setImage:[UIImage imageNamed:@"icon-_down"] forState:UIControlStateNormal];
    [self.contentView addSubview:down];
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 40)];
    bg.backgroundColor = [UIColor whiteColor];
    [self.contentView insertSubview:bg belowSubview:icon];
}

@end
