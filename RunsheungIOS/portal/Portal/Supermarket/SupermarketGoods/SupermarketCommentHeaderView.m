//
//  SupermarketCommentHeaderView.m
//  Portal
//
//  Created by ifox on 2016/12/17.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketCommentHeaderView.h"

@implementation SupermarketCommentHeaderView {
    UIView *_nowSelectedView;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createView];
    }
    return self;
}

- (void)createView {
    
    CGFloat itemWith = self.frame.size.width/5;
    
    for (int i = 0; i < 5; i++) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(i*itemWith, 0, itemWith, self.frame.size.height)];
        [self addSubview:bgView];
        
        bgView.tag = 100+i;
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height/2)];
        title.font = [UIFont systemFontOfSize:12];
        title.textColor = [UIColor darkGrayColor];
        title.textAlignment = NSTextAlignmentCenter;
        switch (i) {
            case 0:
                title.text = NSLocalizedString(@"SMCommentAll", nil);
                break;
            case 1:
                title.text = NSLocalizedString(@"SMCommentGood", nil);
                break;
            case 2:
                title.text = NSLocalizedString(@"SMCommentMid", nil);
                break;
            case 3:
                title.text = NSLocalizedString(@"SMCommentBad", nil);
                break;
            case 4:
                title.text = NSLocalizedString(@"SMCommentPic", nil);
                break;
            default:
                break;
        }
        
        [bgView addSubview:title];
        
        bgView.userInteractionEnabled = YES;
        
        UILabel *amount = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(title.frame), bgView.frame.size.width, bgView.frame.size.height/2)];
        amount.textColor = [UIColor darkGrayColor];
        amount.textAlignment = NSTextAlignmentCenter;
        amount.text = @"999";
        amount.tag = 1000;
        amount.font = [UIFont systemFontOfSize:11];
        [bgView addSubview:amount];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderAtIndex:)];
        [bgView addGestureRecognizer:tap];
        
        if (i == 0) {
            _nowSelectedView = bgView;
            title.textColor = [UIColor redColor];
            amount.textColor = [UIColor redColor];
        }

    }
}

- (void)setAllCommentAmount:(NSString *)allCommentAmount {
    _allCommentAmount = allCommentAmount;
    for (UIView *view in self.subviews) {
        if (view.tag == 100) {
            UILabel *good = [view viewWithTag:1000];
            good.text = allCommentAmount;
        }
    }
}

- (void)setGoodCommentAmount:(NSString *)goodCommentAmount {
    _goodCommentAmount = goodCommentAmount;
    for (UIView *view in self.subviews) {
        if (view.tag == 101) {
            UILabel *good = [view viewWithTag:1000];
            good.text = goodCommentAmount;
        }
    }
}

- (void)setMidCommentAmount:(NSString *)midCommentAmount {
    _midCommentAmount = midCommentAmount;
    for (UIView *view in self.subviews) {
        if (view.tag == 102) {
            UILabel *good = [view viewWithTag:1000];
            good.text = midCommentAmount;
        }
    }
}

- (void)setBadCommentAmount:(NSString *)badCommentAmount {
    _badCommentAmount = badCommentAmount;
    for (UIView *view in self.subviews) {
        if (view.tag == 103) {
            UILabel *good = [view viewWithTag:1000];
            good.text = badCommentAmount;
        }
    }
}

- (void)setPicCommentAmount:(NSString *)picCommentAmount {
    _picCommentAmount = picCommentAmount;
    for (UIView *view in self.subviews) {
        if (view.tag == 104) {
            UILabel *good = [view viewWithTag:1000];
            good.text = picCommentAmount;
        }
    }
}

- (void)tapHeaderAtIndex:(UITapGestureRecognizer *)tap {
    UIView *view = tap.view;
    NSLog(@"%ld",view.tag);
    for (UIView *subView in _nowSelectedView.subviews ) {
        if ([subView isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subView;
            label.textColor = [UIColor darkGrayColor];
        }
    }
    
    _nowSelectedView = view;
    for (UIView *subView in _nowSelectedView.subviews ) {
        if ([subView isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subView;
            label.textColor = [UIColor redColor];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(clickHeaderAtIndex:)]) {
        [_delegate clickHeaderAtIndex:view.tag - 100];
    }
}

@end
