//
//  ZHSCorllHeader.m
//  ZHNetMusicPlayer
//
//  Created by 左梓豪 on 16/6/27.
//  Copyright © 2016年 左梓豪. All rights reserved.
//

#import "ZHSCorllHeader.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ImageData.h"
#import "ZoomingImageView.h"
#import "SDPhotoBrowser.h"
#import "UIImageView+ImageCache.h"

@interface ZHSCorllHeader ()<UIScrollViewDelegate,SDPhotoBrowserDelegate>

@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)NSTimer *timer;

@end

static NSInteger count;
static float timeDur;

@implementation ZHSCorllHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
//    _scrollView.backgroundColor = [UIColor grayColor];
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    _pageControl.currentPage = 0;
    [self addSubview:_scrollView];
    [self addSubview:_pageControl];
}

- (void)setImageNameArray:(NSArray *)imageNameArray {
    _scrollView.contentSize = CGSizeMake(self.frame.size.width * (imageNameArray.count + 2), self.frame.size.height);
    _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    _pageControl.frame = CGRectMake(self.frame.size.width / 2 - 25 * imageNameArray.count / 2 , self.frame.size.height - 35, 25 * imageNameArray.count, 30);
    _pageControl.numberOfPages = imageNameArray.count;
    for (int i = 0; i < (imageNameArray.count + 2); i ++ ) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.tag = i + 100;
        imageView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeader:)];
        [imageView addGestureRecognizer:tap];
        NSString *imageName;
        if (i == 0 ) {
            imageName = imageNameArray[imageNameArray.count - 1];
        } else if (i == imageNameArray.count + 1) {
            imageName = imageNameArray[0];
        } else {
            imageName = imageNameArray[i - 1];
        }
        UIImage *image = [UIImage imageNamed:imageName];
        imageView.image = image;
        [_scrollView addSubview:imageView];
    }
    
    count = imageNameArray.count;
}

- (void)setUrlImagesArray:(NSArray *)urlImagesArray {
    _urlImagesArray = urlImagesArray;
    if (urlImagesArray.count == 0) {
        return;
    }
    if (urlImagesArray.count == 1) {
        _scrollView.scrollEnabled = NO;
        _pageControl.hidden = YES;
    } else {
        _scrollView.scrollEnabled = YES;
        _pageControl.hidden = NO;
    }
    
    for (UIView *view in _scrollView.subviews) {
//        if ([view isKindOfClass:[UIImageView class]]) {
//            [view removeFromSuperview];
//        }
        [view removeFromSuperview];
    }
    
    _scrollView.contentSize = CGSizeMake(self.frame.size.width * (urlImagesArray.count + 2), self.frame.size.height);
    _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    _pageControl.frame = CGRectMake(self.frame.size.width / 2 - 25 * urlImagesArray.count / 2 , self.frame.size.height - 35, 25 * urlImagesArray.count, 30);
    _pageControl.numberOfPages = urlImagesArray.count;
    for (int i = 0; i < (urlImagesArray.count + 2); i ++ ) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.tag = i + 100;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeader:)];
//        if ([self.delegate respondsToSelector:@selector(scrollHeaderTapAtIndex:)]) {
                [imageView addGestureRecognizer:tap];
//        }

        NSString *imageName;
        if (i == 0 ) {
            imageName = urlImagesArray[urlImagesArray.count - 1];
        } else if (i == urlImagesArray.count + 1) {
            imageName = urlImagesArray[0];
        } else {
            imageName = urlImagesArray[i - 1];
        }
        
        UIImageView *beforeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + 20, 20, imageView.frame.size.width - 40, imageView.frame.size.height - 40)];
        beforeImageView.layer.cornerRadius = 5;
        beforeImageView.clipsToBounds = YES;
        

       dispatch_async(dispatch_get_global_queue(0, 0), ^{
//           [self downloadImageWithURL:[NSURL URLWithString:imageName] completionBlock:^(UIImage *image) {
//               imageView.image = image;
//           }];
           [imageView sd_setImageWithURL:[NSURL URLWithString:imageName]];
           [beforeImageView sd_setImageWithURL:[NSURL URLWithString:imageName]];

       });
//        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//        effectView.frame = imageView.frame;
        
        
        [_scrollView addSubview:imageView];
//        [_scrollView addSubview:effectView];
//        [_scrollView addSubview:beforeImageView];
    }
    count = urlImagesArray.count;
}

- (void)setImageDataArray:(NSArray *)imageDataArray {
    _imageDataArray = imageDataArray;
    
    if (imageDataArray.count == 1) {
        _scrollView.scrollEnabled = NO;
        _pageControl.hidden = YES;
    }
    
    _scrollView.contentSize = CGSizeMake(self.frame.size.width * (imageDataArray.count + 2), self.frame.size.height);
    _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    _pageControl.frame = CGRectMake(self.frame.size.width / 2 - 25 * imageDataArray.count / 2 , self.frame.size.height - 35, 25 * imageDataArray.count, 30);
    _pageControl.numberOfPages = imageDataArray.count;
    for (int i = 0; i < (imageDataArray.count + 2); i ++ ) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.tag = i + 100;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeader:)];
//        [imageView addGestureRecognizer:tap];
//        if ([self.delegate respondsToSelector:@selector(scrollHeaderTapAtIndex:)]) {
            [imageView addGestureRecognizer:tap];
//        }

        NSString *imageName;
        ImageData *data;
        NSString *ver;
        if (i == 0 ) {
            data = imageDataArray[imageDataArray.count - 1];
            imageName = data.imageUrl;
            ver = data.ver;
        } else if (i == imageDataArray.count + 1) {
            data = imageDataArray[0];
            imageName = data.imageUrl;
            ver = data.ver;
        } else {
            data = imageDataArray[i - 1];
            imageName = data.imageUrl;
            ver = data.ver;
        }
        
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //           [self downloadImageWithURL:[NSURL URLWithString:imageName] completionBlock:^(UIImage *image) {
            //               imageView.image = image;
            //           }];
//            [imageView sd_setImageWithURL:[NSURL URLWithString:imageName]];
            
            [UIImageView setimageWithImageView:imageView UrlString:imageName imageVersion:ver];
            
//        });
//        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//        effectView.frame = imageView.frame;
        
        [_scrollView addSubview:imageView];
//        [_scrollView addSubview:effectView];
    }
    count = imageDataArray.count;

    
}

- (void)setTime:(float)time {
    timeDur = time;
    _timer = [NSTimer timerWithTimeInterval:time target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)timerAction {
    NSInteger page = _pageControl.currentPage;
    if (page == (count - 1)) {
        _pageControl.currentPage = 0;
        [UIView animateWithDuration:0.3f animations:^{
            _scrollView.contentOffset = CGPointMake(self.frame.size.width * (count+1), 0);
        }];
        _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    } else {
        _pageControl.currentPage = _pageControl.currentPage + 1;
        [UIView animateWithDuration:0.3f animations:^{
           _scrollView.contentOffset = CGPointMake(self.frame.size.width * (_pageControl.currentPage+1), 0); 
        }];
    }
}

- (void)tapHeader:(UITapGestureRecognizer *)sender {
    NSInteger index;
    
    if (sender.view.tag == 100) {
        index = count - 1;
    } else if (sender.view.tag == 100 + count + 1) {
        index = 0;
    } else {
        index = sender.view.tag - 100 - 1;
    }
    if ([self.delegate respondsToSelector:@selector(scrollHeaderTapAtIndex:)]) {
    
        [self.delegate scrollHeaderTapAtIndex:index];
        
    } else {
        SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
        photoBrowser.delegate = self;
        photoBrowser.currentImageIndex = index;
        NSInteger imageCount;
        if (self.imageDataArray.count > 0) {
            imageCount = self.imageDataArray.count;
        } else {
            imageCount = self.urlImagesArray.count;
        }
        photoBrowser.imageCount = imageCount;
        photoBrowser.sourceImagesContainerView = self;
        
        [photoBrowser show];
    }
}

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView = [_scrollView viewWithTag:index+100];
    return imageView.image;
    
}



#pragma mark - 下载图片
- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void(^)(UIImage *image))block
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        __block UIImage *image = nil;
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            image = [UIImage imageWithData:data];
            if (block) {
                block(image);
            }
        }] resume];
        
    });
}

#pragma mark - 缓存路径
- (NSString *)cachePath
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/ScrollCache"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;
    NSInteger page = x / self.frame.size.width;
    
    if (page == 0) {
        _scrollView.contentOffset = CGPointMake(self.frame.size.width * count, 0);
        _pageControl.currentPage = _pageControl.numberOfPages - 1;
    } else if (page ==  (count + 1)) {
        _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
        _pageControl.currentPage = 0;
    } else {
        _pageControl.currentPage = page - 1;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
