//
//  ProgressView.m
//  Portal
//
//  Created by ifox on 2016/12/29.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "ProgressView.h"

@implementation ProgressView {
    UIView *_currentProgress;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = RGB(248, 53, 53).CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = self.frame.size.height/2;
    
    _currentProgress = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.frame.size.height)];
    _currentProgress.layer.cornerRadius = self.frame.size.height/2;
    _currentProgress.backgroundColor = RGB(248, 53, 53);
    [self addSubview:_currentProgress];
}

- (void)setProgress:(float)progress {
    _progress = progress;
    
    CGFloat selfWidth = self.frame.size.width;
    CGRect currentProgressFrame = _currentProgress.frame;
    currentProgressFrame.size.width = selfWidth * progress;
    _currentProgress.frame = currentProgressFrame;
}

@end
