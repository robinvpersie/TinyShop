//
//  HNCodeScannerCoverView.m
//  StarlinkApp
//
//  Created by lpx on 15/6/1.
//  Copyright (c) 2015年 starlink. All rights reserved.
//

#import "HNCodeScannerCoverView.h"

#define scanRect CGRectMake(50 , (APPScreenHeight - (APPScreenWidth - 100))/2 - 20 , APPScreenWidth - 100, APPScreenWidth - 100)

static NSString * const scanningAnimationID = @"animateScanning";

@interface HNCodeScannerCoverView ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndeicatorView;

@property (nonatomic, strong) UIImageView *animationImageView;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UILabel *loadingLabel;

@end


@implementation HNCodeScannerCoverView


- (void)dealloc
{
    _activityIndeicatorView = nil;
    _animationImageView = nil;
    _contentLabel = nil;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.activityIndeicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.activityIndeicatorView setCenter:CGPointMake(CGRectGetMidX(scanRect), CGRectGetMidY(scanRect))];
        
        UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 20)];
        loadingLabel.textAlignment = NSTextAlignmentCenter;
        loadingLabel.text = @"正在加载...";
        loadingLabel.textColor = [UIColor whiteColor];
        loadingLabel.font = [UIFont systemFontOfSize:15];
        loadingLabel.center = CGPointMake(APPScreenWidth / 2, self.activityIndeicatorView.center.y + 60);
        self.loadingLabel = loadingLabel;
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 20)];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.text = @"将二维码放入框内，即可自动扫描。";
        contentLabel.textColor = [UIColor whiteColor];
        contentLabel.font = [UIFont systemFontOfSize:14];
        contentLabel.center = CGPointMake(APPScreenWidth / 2, APPScreenWidth / 2 +  CGRectGetMaxY(scanRect) / 2);
        self.contentLabel = contentLabel;
        
    }
    return self;
}


- (UIImageView *)animationImageView
{
    if(!_animationImageView){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(scanRect), CGRectGetMinY(scanRect) + 5, CGRectGetWidth(scanRect), 12)];
        imageView.image = [[UIImage imageNamed:@"scanLine"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 117, 0, 117) resizingMode:UIImageResizingModeStretch];
        _animationImageView = imageView;
        return imageView;
    }
    return _animationImageView;
}


- (void)drawBackgroundView:(CGRect)rect
{
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0 alpha:0.5].CGColor);
    
    CGContextFillRect(context, rect);
    
    CGContextMoveToPoint(context, 30, 30);
    CGContextAddLineToPoint(context, 30, 110);
    CGContextAddLineToPoint(context, 110, 110);
    CGContextAddLineToPoint(context, 110, 30);
    CGContextAddLineToPoint(context, 30, 30);
    
    CGContextClearRect(context, CGRectMake(50 , (APPScreenWidth - (APPScreenWidth - 100))/2 - 20 , APPScreenWidth - 100, APPScreenWidth - 100));
    
    
    //从Context中获取图像，并显示在界面上
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    [self addSubview:imgView];
    
}




- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    switch (self.scannerState) {
        case kScannerStateStart:
        {
            CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
            CGContextFillRect(context, rect);
        }
            break;
        case kScannerStateScanning:
        case kScannerStateStop:
        {
            
            CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0 alpha:0.5].CGColor);
            CGContextFillRect(context, rect);
            CGContextSetLineWidth(context, 1);
            CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
            CGContextStrokeRect(context, scanRect);
            CGContextClearRect(context, scanRect);
            CGContextSetLineWidth(context, 2);
            CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
            
            //画四个角
            CGContextMoveToPoint(context, CGRectGetMinX(scanRect), CGRectGetMinY(scanRect) + 15);
            CGContextAddLineToPoint(context, CGRectGetMinX(scanRect),  CGRectGetMinY(scanRect));
            CGContextAddLineToPoint(context, CGRectGetMinX(scanRect) + 15,  CGRectGetMinY(scanRect));
            
            CGContextMoveToPoint(context, CGRectGetMaxX(scanRect), CGRectGetMinY(scanRect) + 15);
            CGContextAddLineToPoint(context, CGRectGetMaxX(scanRect),  CGRectGetMinY(scanRect));
            CGContextAddLineToPoint(context, CGRectGetMaxX(scanRect) - 15,  CGRectGetMinY(scanRect));
            
            CGContextMoveToPoint(context, CGRectGetMinX(scanRect), CGRectGetMaxY(scanRect) - 15);
            CGContextAddLineToPoint(context, CGRectGetMinX(scanRect),  CGRectGetMaxY(scanRect));
            CGContextAddLineToPoint(context, CGRectGetMinX(scanRect) + 15,  CGRectGetMaxY(scanRect));
            
            CGContextMoveToPoint(context, CGRectGetMaxX(scanRect), CGRectGetMaxY(scanRect) - 15);
            CGContextAddLineToPoint(context, CGRectGetMaxX(scanRect),  CGRectGetMaxY(scanRect));
            CGContextAddLineToPoint(context, CGRectGetMaxX(scanRect) - 15,  CGRectGetMaxY(scanRect));
            
            CGContextStrokePath(context);
            
        }
            break;
            
        default:
            break;
    }
}



- (void)setScannerState:(KScannerState)scannerState
{
    
    switch (scannerState) {
        case kScannerStateStart:
        {
            [self addSubview:self.activityIndeicatorView];
            [self.activityIndeicatorView startAnimating];
            [self addSubview:self.loadingLabel];
            [self.animationImageView removeFromSuperview];
            [self.contentLabel removeFromSuperview];
            [self stopAnimation];
        }
            break;
        case kScannerStateScanning:
        {
            if(self.activityIndeicatorView.isAnimating){
                [self.activityIndeicatorView stopAnimating];
            }
            [self.activityIndeicatorView removeFromSuperview];
            [self.loadingLabel removeFromSuperview];
            [self addSubview:self.animationImageView];
            [self addSubview:self.contentLabel];
            [self startAnimation];
            
        }
            break;
        case kScannerStateStop:
        {
            [self stopAnimation];
            [self.animationImageView removeFromSuperview];
            [self addSubview:self.activityIndeicatorView];
            [self.activityIndeicatorView startAnimating];
            
        }
            break;
        default:
            break;
    }
    _scannerState = scannerState;
    [self setNeedsDisplay];
}



- (void)startAnimation
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.duration = 3.0;
    animation.fillMode=kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.repeatCount = CGFLOAT_MAX;
    animation.autoreverses = NO;
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:CGRectGetHeight(scanRect) - 20];
    [self.animationImageView.layer addAnimation:animation forKey:scanningAnimationID];

}


- (void)stopAnimation
{
    [self.animationImageView.layer removeAnimationForKey:scanningAnimationID];
}


@end
