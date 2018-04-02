//
//  LZCartEmptyView.m
//  Portal
//
//  Created by linpeng on 2018/1/10.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "LZCartEmptyView.h"
#import "LZConfigFile.h"

@interface LZCartEmptyView() {}

@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UILabel *emptylb;
@property (nonatomic,strong)UIButton *refreshBtn;

@end
@implementation LZCartEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.imageView = [[UIImageView alloc]init];
        self.imageView.image = [[UIImage imageNamed:@"icon_empty_cart"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.centerX.equalTo(self);
            make.width.equalTo(@(100));
            make.height.equalTo(self.imageView.mas_width);
        }];
        
        self.emptylb = [[UILabel alloc]init];
        self.emptylb.textColor = LZColorFromHex(0x706F6F);
        self.emptylb.font = [UIFont systemFontOfSize:15];
        self.emptylb.text = NSLocalizedString(@"购物车为空", nil);
        [self addSubview:self.emptylb];
        [self.emptylb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.mas_bottom).offset(10);
            make.centerX.equalTo(self);
        }];
        
        self.refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.refreshBtn addTarget:self action:@selector(didRefresh) forControlEvents:UIControlEventTouchUpInside];
        [self.refreshBtn setTitle:NSLocalizedString(@"立即刷新", nil)  forState:UIControlStateNormal];
        [self.refreshBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.refreshBtn.layer.cornerRadius = 4;
        self.refreshBtn.layer.backgroundColor = [LZColorFromHex(0x21c043) CGColor];
        [self addSubview:self.refreshBtn];
        [self.refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.width.equalTo(@(150));
            make.height.equalTo(@(40));
            make.top.equalTo(self.emptylb.mas_bottom).offset(15);
        }];
        
    }
    return self;
}

-(CGSize)intrinsicContentSize {
    return CGSizeMake(150, 170);
}

-(void)didRefresh {
    if (self.RefreshAction) {
        self.RefreshAction();
    }
}


@end
