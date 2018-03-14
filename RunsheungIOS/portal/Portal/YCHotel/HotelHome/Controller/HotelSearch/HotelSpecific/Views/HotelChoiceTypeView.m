//
//  HotelChoiceTypeView.m
//  Portal
//
//  Created by 王五 on 2017/4/9.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelChoiceTypeView.h"

#define width  40
@implementation HotelChoiceTypeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI:frame];
    }
    return self;
}

- (void)createUI:(CGRect)frame{
    [self setBackgroundColor: [UIColor whiteColor]];
    self.data = @[@"含早",@"大床",@"双床",@"可订",@"可取消"].mutableCopy;
    for (int i = 0; i<self.data.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((CGRectGetWidth(frame) - 50*self.data.count)/2.0f + i*(width+10) + 5.0f, 7, width, 26)];
        [button setTitle:self.data[i] forState:UIControlStateNormal];
        [button setTitleColor:PurpleColor forState:UIControlStateNormal];
        button.font = [UIFont systemFontOfSize:12];
        button.tag = i;
        button.layer.cornerRadius = 2;
        button.layer.masksToBounds = YES;
        button.layer.borderColor = PurpleColor.CGColor;
        button.layer.borderWidth = 0.6f;
        [button addTarget:self action:@selector(choiceBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
    }
    
}

- (void)choiceBtn:(UIButton*)choiceBtn{
    if ([self.delegate respondsToSelector:@selector(choiceHotelType:)]) {
        [self.delegate choiceHotelType:choiceBtn];
    }
}
@end
