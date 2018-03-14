//
//  HotelSearchFilterView.m
//  Portal
//
//  Created by ifox on 2017/4/7.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelSearchFilterView.h"
#import "UIButton+CreateButton.h"

#define ButtonWidth APPScreenWidth/4.0

@interface HotelSearchFilterView ()

@property(nonatomic, strong) UIButton *location;//区域位置
@property(nonatomic, strong) UIButton *price;//价格星级
@property(nonatomic, strong) UIButton *sort;//排序
@property(nonatomic, strong) UIButton *filter;//筛选

@end

@implementation HotelSearchFilterView {
    NSArray *_titles;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titles = @[@"区域位置▼",@"价格/星级▼",@"默认排序▼",@"筛选▼"];
        
        [self createButton];
    }
    return self;
}

- (void)createButton {
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    for (int i = 0; i < 4; i++) {
        UIButton *button = [UIButton createButtonWithFrame:CGRectMake(i*ButtonWidth, 0, ButtonWidth, 40) title:_titles[i] titleColor:HotelGrayColor titleFont:[UIFont systemFontOfSize:13] backgroundColor:[UIColor whiteColor]];
        [self addSubview:button];
    }
}

@end
