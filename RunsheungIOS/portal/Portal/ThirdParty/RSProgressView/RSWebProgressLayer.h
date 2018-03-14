//
//  RSWebProgressLayer.h
//  Portal
//
//  Created by zhengzeyou on 2018/1/18.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
@interface RSWebProgressLayer : CAShapeLayer
+ (instancetype)layerWithFrame:(CGRect)frame;

- (void)finishedLoad;
- (void)startLoad;
- (void)closeTimer;
@end
