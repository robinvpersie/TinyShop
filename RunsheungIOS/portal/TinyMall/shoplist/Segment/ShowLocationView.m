//
//  ShowLocationView.m
//  Portal
//
//  Created by 이정구 on 2018/3/19.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "ShowLocationView.h"

@interface ShowLocationView ()

@property (nonatomic, strong) UIView * blackContainerView;
@property (nonatomic, strong) UIView * whiteContainerView;

@end

@implementation ShowLocationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.blackContainerView = [[UIView alloc] init];
        self.blackContainerView.backgroundColor = [UIColor darkTextColor];
        [self addSubview:self.blackContainerView];
        [self.blackContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        [tap addTarget:self action:@selector(hide)];
        [self.blackContainerView addGestureRecognizer:tap];
        
        self.whiteContainerView = [[UIView alloc] init];
        self.whiteContainerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.whiteContainerView];
        [self.whiteContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.equalTo(@270);
            make.height.equalTo(@163);
        }];
        
        UILabel *toplb = [[UILabel alloc] init];
        toplb.textColor = [UIColor darkTextColor];
        toplb.font = [UIFont systemFontOfSize:15];
        toplb.text = @"내 위치 지정";
        toplb.textAlignment = NSTextAlignmentCenter;
        toplb.numberOfLines = 0;
        [self.whiteContainerView addSubview:toplb];
        [toplb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.whiteContainerView).with.offset(10);
            make.leading.equalTo(self.whiteContainerView).with.offset(10);
            make.trailing.equalTo(self.whiteContainerView).with.offset(-10);
        }];
        
        UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [locationBtn setImage:[UIImage imageNamed:@"icon_popup_position"] forState:UIControlStateNormal];
        [locationBtn addTarget:self action:@selector(didlocation) forControlEvents:UIControlEventTouchUpInside];
        [self.whiteContainerView addSubview:locationBtn];
        [locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@40);
            make.height.equalTo(@35);
            make.top.equalTo(toplb.mas_bottom).with.offset(25);
            make.leading.equalTo(self.whiteContainerView).with.offset(62);
        }];
        
        UILabel *locationlb = [[UILabel alloc]init];
        locationlb.text = @"현재위치로 재검색";
        locationlb.textColor = [UIColor darkTextColor];
        locationlb.font = [UIFont systemFontOfSize:13];
        [self.whiteContainerView addSubview:locationlb];
        [locationlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(locationBtn);
            make.top.equalTo(locationBtn.mas_bottom).offset(16);
        }];
        
        UIButton *mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [mapBtn setImage:[UIImage imageNamed:@"icon_popup_map"] forState:UIControlStateNormal];
        [mapBtn addTarget:self action:@selector(didmap) forControlEvents:UIControlEventTouchUpInside];
        [self.whiteContainerView addSubview:mapBtn];
        [mapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.top.equalTo(locationBtn);
            make.trailing.equalTo(self.whiteContainerView).with.offset(-62);
        }];
        
        UILabel *maplb = [[UILabel alloc] init];
        maplb.textColor = [UIColor darkTextColor];
        maplb.font = [UIFont systemFontOfSize:13];
        maplb.text = @"지도로 위치지정";
        [self.whiteContainerView addSubview:maplb];
        [maplb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(mapBtn);
            make.top.equalTo(locationlb);
        }];
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setImage:[UIImage imageNamed:@"btn_close_white"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBtn];
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.whiteContainerView.mas_top).with.offset(-10);
            make.trailing.equalTo(self.whiteContainerView);
            make.width.equalTo(@18);
            make.height.equalTo(@20);
        }];
        
    }
    return self;
}

-(void)didmap {
    [self hide];
    if (_map != nil) {
        _map();
    }
    
}

-(void)didlocation {
    [self hide];
    if (_location != nil) {
        _location();
    }
}

-(void)didMoveToSuperview {
    [UIView animateWithDuration:0.3 animations:^{
        self.blackContainerView.alpha = 0.4;
        self.whiteContainerView.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}


-(void)showInView:(UIView *)superView {
    [superView addSubview:self];
    self.frame = superView.bounds;
}

-(void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.blackContainerView.alpha = 0;
        self.whiteContainerView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
  
}



@end
