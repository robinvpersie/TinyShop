//
//  HNCodeScannerMatchView.m
//  惠农码
//
//  Created by Liangpx on 13-12-14.
//  Copyright (c) 2013年 HuiNongKeJi. All rights reserved.
//

#import "HNCodeScannerMatchView.h"
#import <QuartzCore/QuartzCore.h>

@implementation HNCodeScannerMatchView {
    BOOL _set;
    CAShapeLayer *_shapeLayer;
}

static NSString * const matchAnimationID = @"animateMatch";
static NSString * const scanningAnimationID = @"animateScanning";
static NSString * const flashAnimationID = @"animateFlash";

- (void)dealloc
{
    _matchFoundColor = nil;
    _scanningColor = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = frame;
        self.matchFoundColor = [UIColor greenColor];
        self.scanningColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        
        self.minMatchBoxHeight = 10.0f;
        
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.fillColor = [[UIColor clearColor] CGColor];
        _shapeLayer.strokeColor = [self.scanningColor CGColor];
        _shapeLayer.lineWidth = 2.0;
        _shapeLayer.fillRule = kCAFillRuleNonZero;
        _shapeLayer.frame = self.bounds;
        [self.layer addSublayer:_shapeLayer];
        
        [self reset];
    }
    return self;
}

- (CGPoint)halfWayPointFromPoint:(CGPoint)point1 andPoint:(CGPoint)point2 {
    return CGPointMake((point1.x + point2.x)/2.0, (point1.y + point2.y)/2.0);
}

- (CGFloat)distanceBetweenPoint:(CGPoint)point1 andPoint:(CGPoint)point2 {
    CGFloat distance = sqrtf((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y));
    return distance;
}

- (void)extraPolatePoint:(CGPoint *)point1 andPoint:(CGPoint *)point2 {
    CGFloat distance = [self distanceBetweenPoint:*point1 andPoint:*point2];
    CGFloat extraPolateHeight = (self.minMatchBoxHeight - distance)/2.0;
    
    if (extraPolateHeight > 0.0) {
        CGPoint modifiedPoint1 = CGPointMake(((*point1).x - (*point2).x) * extraPolateHeight + (*point1).x, ((*point1).y - (*point2).y) * extraPolateHeight + (*point1).y);
        CGPoint modifiedPoint2 = CGPointMake(((*point2).x - (*point1).x) * extraPolateHeight + (*point2).x, ((*point2).y - (*point1).y) * extraPolateHeight + (*point2).y);
        *point1 = modifiedPoint1;
        *point2 = modifiedPoint2;
    }
}

- (CGPathRef)createPathWithTopLeftPoint:(CGPoint)topLeftPoint topRightPoint:(CGPoint)topRightPoint bottomLeftPoint:(CGPoint)bottomLeftPoint bottomRightPoint:(CGPoint)bottomRightPoint {
    
    [self extraPolatePoint:&topLeftPoint andPoint:&bottomLeftPoint];
    [self extraPolatePoint:&topRightPoint andPoint:&bottomRightPoint];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, topLeftPoint.x, topLeftPoint.y);
    CGPathAddLineToPoint(path, NULL, topRightPoint.x, topRightPoint.y);
    CGPathAddLineToPoint(path, NULL, bottomRightPoint.x, bottomRightPoint.y);
    CGPathAddLineToPoint(path, NULL, bottomLeftPoint.x, bottomLeftPoint.y);
    CGPathCloseSubpath(path);
    
    CGPoint halfPoint = [self halfWayPointFromPoint:topLeftPoint andPoint:topRightPoint];
    CGPathMoveToPoint(path, NULL, halfPoint.x, halfPoint.y);
    CGPathAddLineToPoint(path, NULL, halfPoint.x, halfPoint.y + 5.0);
    
    halfPoint = [self halfWayPointFromPoint:topLeftPoint andPoint:bottomLeftPoint];
    CGPathMoveToPoint(path, NULL, halfPoint.x, halfPoint.y);
    CGPathAddLineToPoint(path, NULL, halfPoint.x + 5.0, halfPoint.y);
    
    halfPoint = [self halfWayPointFromPoint:topRightPoint andPoint:bottomRightPoint];
    CGPathMoveToPoint(path, NULL, halfPoint.x, halfPoint.y);
    CGPathAddLineToPoint(path, NULL, halfPoint.x - 5.0, halfPoint.y);
    
    halfPoint = [self halfWayPointFromPoint:bottomLeftPoint andPoint:bottomRightPoint];
    CGPathMoveToPoint(path, NULL, halfPoint.x, halfPoint.y);
    CGPathAddLineToPoint(path, NULL, halfPoint.x, halfPoint.y - 5.0);
    
    return path;
}

- (void)startScanningAnimating {
    if (![_shapeLayer animationForKey:scanningAnimationID]) {
        [_shapeLayer removeAllAnimations];

        CGFloat marginX =  (self.frame.size.width - 160)/2.0; //   80.0f;//5.0f;
        CGFloat marginY = (self.frame.size.height - 160 )/2.0;//25.0f;
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        {
            marginX = 50.0f;
            marginY = 250.0f;
        }

        CGPathRef fromPath = [self createPathWithTopLeftPoint:CGPointMake(marginX, marginY)
                                                topRightPoint:CGPointMake(self.bounds.size.width - marginX, marginY)
                                              bottomLeftPoint:CGPointMake(marginX, self.bounds.size.height - marginY)
                                             bottomRightPoint:CGPointMake(self.bounds.size.width - marginX, self.bounds.size.height - marginY)];

        marginX = 40.0f;//25.0f;
        marginY = (self.frame.size.height - 80)/2;//5.0f;
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        {
            marginX = 150.0f;
            marginY = 150.0f;
        }

        CGPathRef toPath = [self createPathWithTopLeftPoint:CGPointMake(marginX, marginY)
                                              topRightPoint:CGPointMake(self.bounds.size.width - marginX, marginY)
                                            bottomLeftPoint:CGPointMake(marginX, self.bounds.size.height - marginY)
                                           bottomRightPoint:CGPointMake(self.bounds.size.width - marginX, self.bounds.size.height - marginY)];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
        animation.duration = 1.0;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.repeatCount = CGFLOAT_MAX;
        animation.autoreverses = YES;
        animation.fromValue = (__bridge id)fromPath;
        animation.toValue = (__bridge id)toPath;
        [_shapeLayer addAnimation:animation forKey:scanningAnimationID];
        
        CFRelease(fromPath);
        CFRelease(toPath);
    }
}

- (void)animateToMatchWithTopLeftPoint:(CGPoint)topLeftPoint topRightPoint:(CGPoint)topRightPoint bottomLeftPoint:(CGPoint)bottomLeftPoint bottomRightPoint:(CGPoint)bottomRightPoint  {
    if (![_shapeLayer animationForKey:matchAnimationID]) {
        [_shapeLayer removeAllAnimations];
        
        CAShapeLayer *currentLayerState = [_shapeLayer presentationLayer];
        
        CGPathRef toPath = [self createPathWithTopLeftPoint:topLeftPoint
                                              topRightPoint:topRightPoint
                                            bottomLeftPoint:bottomLeftPoint
                                           bottomRightPoint:bottomRightPoint];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
        animation.duration = 0.3;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.repeatCount = 1;
        animation.autoreverses = NO;
        animation.fromValue = (__bridge id)currentLayerState.path;
        animation.toValue = (__bridge id)toPath;
        animation.delegate = self;
        _shapeLayer.path = toPath;
        [_shapeLayer addAnimation:animation forKey:matchAnimationID];
        CFRelease(toPath);
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [_shapeLayer removeAllAnimations];
        
        _shapeLayer.strokeColor = [self.matchFoundColor CGColor];
        
        //Flash the stroke color
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeColor"];
        animation.duration = 0.1;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.repeatCount = 3;
        animation.autoreverses = YES;
        animation.fromValue         = (id) [self.matchFoundColor CGColor];
        animation.toValue           = (id) [self.scanningColor CGColor];
        [_shapeLayer addAnimation:animation forKey:flashAnimationID];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_set) {
        [self startScanningAnimating];
    }
}

- (void)reset {
    [_shapeLayer removeAllAnimations];
    _shapeLayer.strokeColor = [self.scanningColor CGColor];
    _set = NO;
    [self setNeedsLayout];
}

- (void)setFoundMatchWithTopLeftPoint:(CGPoint)topLeftPoint topRightPoint:(CGPoint)topRightPoint bottomLeftPoint:(CGPoint)bottomLeftPoint bottomRightPoint:(CGPoint)bottomRightPoint {
    _set = YES;
    [self animateToMatchWithTopLeftPoint:topLeftPoint topRightPoint:topRightPoint bottomLeftPoint:bottomLeftPoint bottomRightPoint:bottomRightPoint];
}

@end
