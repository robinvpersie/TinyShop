//
//  SegmentView.m
//  Portal
//
//  Created by zhengzeyou on 2017/12/27.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "SegmentView.h"

@implementation SegmentView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
       
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, APPScreenWidth/2.0f, CGRectGetHeight(self.frame) - 16)];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.tag = 1001;
    [self addSubview:loginBtn];
    
    UIButton *addMemberBtn = [[UIButton alloc]initWithFrame:CGRectMake(APPScreenWidth/2.0f, 0, APPScreenWidth/2.0f, CGRectGetHeight(self.frame) - 16)];
    [addMemberBtn setTitle:@"注册" forState:UIControlStateNormal];
    [addMemberBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addMemberBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    addMemberBtn.tag = 1002;
    [self addSubview:addMemberBtn];
    
    UIImageView *arrowImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_selected_triangle"]];
    arrowImg.tag = 1003;
    arrowImg.frame = CGRectMake(CGRectGetWidth(loginBtn.frame)/2-15, CGRectGetHeight(loginBtn.frame), 30, 16 );
    [self addSubview:arrowImg];
    
}

- (void)clickBtn:(UIButton*)sender{
    UIImageView *arrow = (UIImageView*)[self viewWithTag:1003];
    if (sender.tag == 1001) {
        [UIView animateWithDuration:0.4 animations:^{
            if (CGRectGetMinX(arrow.frame) >APPScreenWidth/2) {
                arrow.transform = CGAffineTransformTranslate(arrow.transform, -APPScreenWidth/2, 0);
            }
        }];
        
    } else {
        [UIView animateWithDuration:0.4 animations:^{
            if (CGRectGetMinX(arrow.frame) <APPScreenWidth/2) {
                arrow.transform = CGAffineTransformTranslate(arrow.transform, APPScreenWidth/2, 0);
            }
        }];
    }
    if ([self.delegate respondsToSelector:@selector(click:)]) {
        
        [self.delegate click:(int)sender.tag];
    }
}

- (void)setDisoffx:(float)disoffx{
    _disoffx = disoffx;
    UIImageView *arrow = (UIImageView*)[self viewWithTag:1003];
    CGRect frams = arrow.frame;
    frams.origin.x = APPScreenWidth/4.0f-15 + _disoffx/2.0f;
    arrow.frame = frams;
}
@end
