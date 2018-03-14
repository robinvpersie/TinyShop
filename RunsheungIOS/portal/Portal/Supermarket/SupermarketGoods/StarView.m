//
//  StarView.m
//  WXMovie
//
//  Created by wei.chen on 15/8/7.
//  Copyright (c) 2015年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "StarView.h"

/**
 *  视图类:
 1. 创建子视图
 2. 子视图展示数据
 */


@implementation StarView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //创建子视图
        [self _createViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        //创建子视图
        [self _createViews];
    }
    return self;
}


- (void)_createViews {
    
    UIImage *yelloImg = [UIImage imageNamed:@"star_red"];
    UIImage *grayImg = [UIImage imageNamed:@"star_gray"];
    
    //1.创建灰色星星视图
    _grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, grayImg.size.width*5, grayImg.size.height)];
    _grayView.clipsToBounds = YES;
    _grayView.contentMode = UIViewContentModeScaleAspectFit;
    _grayView.backgroundColor = [UIColor colorWithPatternImage:grayImg];
    [self addSubview:_grayView];
    
    //2.创建金色星星视图
    _yelloView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, yelloImg.size.width*5, yelloImg.size.height)];
    _yelloView.backgroundColor = [UIColor colorWithPatternImage:yelloImg];
    _yelloView.contentMode = UIViewContentModeScaleAspectFit;
    _yelloView.clipsToBounds = YES;
    [self addSubview:_yelloView];

}

- (void)setRating:(CGFloat)rating {
    _rating = rating;
    
    CGFloat s = rating/10;
    
    //frame中是修改transform缩放之后的宽、高
    //bound中存的是修改transform缩放之前的宽、高
//    CGFloat w1 = _grayView.frame.size.width;
//    CGFloat w2 = _grayView.bounds.size.width;
    
    CGFloat width = s * _grayView.frame.size.width;
    
    CGRect frame = _yelloView.frame;
    frame.size.width = width;
    _yelloView.frame = frame;
}


//约束设置当前视图的尺寸之后，调用此方法
//视图将要渲染显示的时候，会调用此方法
- (void)layoutSubviews {
    [super layoutSubviews];
    
    
//    //在此方法中修改视图的frame，是不会被自动布局的约束修改
//    CGRect frame = self.frame;
//    frame.size.height = 22.6;
//    self.frame = frame;
    
    
    //3.按照星星视图的比例，计算当前视图的高度
    //星星视图w/星星视图的h = 当前视图的w/当前视图的h(?)
    
    CGFloat s = _grayView.bounds.size.width/_grayView.bounds.size.height;
    CGFloat height = self.bounds.size.width/s;
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
    
//    //4.放大、缩小星星视图
//    CGFloat scale = self.bounds.size.width / _grayView.bounds.size.width;
//    _yelloView.transform = CGAffineTransformMakeScale(scale, scale);
//    _grayView.transform = CGAffineTransformMakeScale(scale, scale);
    
    CGRect frame1 = _grayView.frame;
    CGRect frame2 = _yelloView.frame;
    frame1.origin = CGPointZero;
    frame2.origin = CGPointZero;
    
    _grayView.frame = frame1;
    _yelloView.frame = frame2;
    
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    UITouch *touch = [touches anyObject];
//    CGPoint p = [touch locationInView:self];
//    
//    CGRect frame = _yelloView.frame;
//    frame.size.width = p.x;
//    _yelloView.frame = frame;
//
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    UITouch *touch = [touches anyObject];
//    CGPoint p = [touch locationInView:self];
//    
//    CGRect frame = _yelloView.frame;
//    frame.size.width = p.x;
//    _yelloView.frame = frame;
//    
//}


@end
