//
//  HNCodeScannerMatchView.h
//  惠农码
//
//  Created by Liangpx on 13-12-14.
//  Copyright (c) 2013年 HuiNongKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNCodeScannerMatchView : UIView

@property (nonatomic, strong) UIColor *matchFoundColor;
@property (nonatomic, strong) UIColor *scanningColor;
@property (nonatomic, assign) CGFloat minMatchBoxHeight;

- (void)setFoundMatchWithTopLeftPoint:(CGPoint)topLeftPoint topRightPoint:(CGPoint)topRightPoint bottomLeftPoint:(CGPoint)bottomLeftPoint bottomRightPoint:(CGPoint)bottomRightPoint;
- (void)reset;

@end
