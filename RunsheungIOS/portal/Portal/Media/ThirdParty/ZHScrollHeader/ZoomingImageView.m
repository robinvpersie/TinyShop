//
//  ZoomingImageView.m
//  CircleOfFriends
//
//  Created by 左梓豪 on 16/8/18.
//  Copyright © 2016年 左梓豪. All rights reserved.
//

#import "ZoomingImageView.h"

#define kMaxZoom 3.0

@interface ZoomingImageView ()<UIScrollViewDelegate>

@property (nonatomic) BOOL    isDoubleTapingForZoom;
@property (nonatomic) BOOL    isTwiceTaping;
@property (nonatomic) CGFloat touchX;
@property (nonatomic) CGFloat touchY;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat currentScale;

@end

@implementation ZoomingImageView {
    UIScrollView *_scrollView;
    UIImageView  *_fullImageView;
}

@synthesize  isDoubleTapingForZoom = _isDoubleTapingForZoom;
@synthesize  width = _width;
@synthesize  touchX = _touchX;
@synthesize  touchY = _touchY;
@synthesize  height = _height;
@synthesize  currentScale = _currentScale;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullScreen)];
        [self addGestureRecognizer:tap];
        _width = self.image.size.width;
        _height = self.image.size.height;
    }
    return self;
}

/**
 *  全屏显示图片
 */
- (void)fullScreen {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"imageViewWillShow" object:nil];
    
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    _scrollView = [[UIScrollView alloc] initWithFrame:mainWindow.frame];
    _scrollView.showsVerticalScrollIndicator = false;
    _scrollView.showsHorizontalScrollIndicator = false;
    [mainWindow addSubview:_scrollView];
    
    CGRect frame = [self convertRect:self.bounds toView:mainWindow];
    
    _fullImageView = [[UIImageView alloc] initWithFrame:frame];
    _fullImageView.contentMode = UIViewContentModeScaleAspectFit;
    _fullImageView.userInteractionEnabled = YES;
    if (self.image != nil) {
        _fullImageView.image = self.image;
    }
    
    [_scrollView addSubview:_fullImageView];
    _scrollView.delegate = self;
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = 5;
    
    [UIView animateWithDuration:0.3f animations:^{
        CGRect imageViewFrame = _fullImageView.frame;
        imageViewFrame.size.width = APPScreenWidth;
        imageViewFrame.size.height = APPScreenWidth * (self.image.size.height / self.image.size.width);
        _fullImageView.frame = imageViewFrame;
        _fullImageView.center = self.window.center;
        self.hidden = YES;
    } completion:^(BOOL finished) {
        _scrollView.backgroundColor = [UIColor blackColor];
        self.viewController.navigationController.navigationBar.hidden = YES;
    }];
    
    UITapGestureRecognizer *zoomIn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomIn:)];
    zoomIn.numberOfTapsRequired = 2;
    UITapGestureRecognizer *zoomOut = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOut)];
    zoomOut.numberOfTapsRequired = 1;
    [zoomOut requireGestureRecognizerToFail:zoomIn];
    [_fullImageView addGestureRecognizer:zoomIn];
    [_fullImageView addGestureRecognizer:zoomOut];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImage)];
    [_fullImageView addGestureRecognizer: longPress];
}

- (void)saveImage {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:@"提示" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"保存至相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImageWriteToSavedPhotosAlbum(self.image, self, nil, nil);
//        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [actionSheet addAction:action1];
    [actionSheet addAction:actionCancel];
    [self.viewController presentViewController:actionSheet animated:YES completion:nil];

}

#pragma mark - UISCrollViewDelegate
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    _currentScale = scale;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _fullImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat xcenter = scrollView.center.x,ycenter = scrollView.center.y;
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width?scrollView.contentSize.width/2 :xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ?scrollView.contentSize.height/2 : ycenter;
    
    if(_isDoubleTapingForZoom){
        NSLog(@"taping center");
        /**
         *  这里对双击放大操作
         */
        
        NSLog(@"adjust postion sucess, x:%f,y:%f",xcenter,ycenter);
    }
    [_fullImageView setCenter:CGPointMake(xcenter, ycenter)];
}

/**
 *  双击放大或还原
 *
 *  @param tapGestureRecognizer tapGestureRecognizer
 */
- (void)zoomIn:(UITapGestureRecognizer *)tapGestureRecognizer {
    _touchX = [tapGestureRecognizer locationInView:tapGestureRecognizer.view].x;
    _touchY = [tapGestureRecognizer locationInView:tapGestureRecognizer.view].y;
    if(_isTwiceTaping){
        return;
    }
    _isTwiceTaping = YES;
    
    if(_currentScale > 1.0){
        _currentScale = 1.0;
        [_scrollView setZoomScale:1.0 animated:YES];
    }else{
        _isDoubleTapingForZoom = YES;
        _currentScale = kMaxZoom;
        [_scrollView setZoomScale:kMaxZoom animated:YES];
    }
    _isDoubleTapingForZoom = NO;
    //延时做标记判断，使用户点击3次时的单击效果不生效。
    [self performSelector:@selector(twiceTaping) withObject:nil afterDelay:0.65];
}

-(void)twiceTaping{
    NSLog(@"no");
    _isTwiceTaping = NO;
}

/**
 *  点击恢复
 */
- (void)zoomOut {
    CGRect frame = [self convertRect:self.bounds toView:self.window];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.contentSize = CGSizeMake(APPScreenWidth, APPScreenHeight);
    [UIView animateWithDuration:0.3f animations:^{
        _fullImageView.frame = self.window.frame;
        _fullImageView.frame = frame;
        self.viewController.navigationController.navigationBar.hidden = NO;
    } completion:^(BOOL finished) {
        [_scrollView removeFromSuperview];
        _scrollView = nil;
        _fullImageView = nil;
        self.hidden = NO;
    }];
}

@end
