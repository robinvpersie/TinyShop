//
//  SupermarketHomeAdview.m
//  Portal
//
//  Created by 左梓豪 on 2016/12/6.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketHomeAdview.h"
#import "UILabel+WidthAndHeight.h"
#import "SupermarketHomeMostFreshData.h"
#import "SupermarketHomeADVData.h"

@implementation SupermarketHomeAdview {
    UILabel *_titleLeft;
    UILabel *_titleUp;
    UILabel *_titleDown;
    
    UILabel *_msgLeft;
    UILabel *_msgUp;
    UILabel *_msgDown;
    
    CGFloat _titleWidth;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = RGB(235, 235, 235);
        
        UIView *bgView_1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/2 - 1, self.frame.size.height)];
        bgView_1.backgroundColor = [UIColor whiteColor];
        bgView_1.tag = 100;
        bgView_1.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap_1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [bgView_1 addGestureRecognizer:tap_1];
        [self addSubview:bgView_1];
        
        UIImageView *iconLeft = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
        iconLeft.image = [UIImage imageNamed:@"icon_frash"];
        [bgView_1 addSubview:iconLeft];
        
        _titleLeft = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconLeft.frame)+10, iconLeft.frame.origin.y, 100, iconLeft.frame.size.height)];
        _titleLeft.font = [UIFont systemFontOfSize:17];
        _titleLeft.text = @"最新鲜";
        [bgView_1 addSubview:_titleLeft];
        
        _msgLeft = [[UILabel alloc] initWithFrame:CGRectMake(iconLeft.frame.origin.x, CGRectGetMaxY(_titleLeft.frame), 150, 18)];
        _msgLeft.text = @"好东西何须去远方";
        _msgLeft.textColor = [UIColor grayColor];
        _msgLeft.font = [UIFont systemFontOfSize:13];
        [bgView_1 addSubview:_msgLeft];
        
        _imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_msgLeft.frame), bgView_1.frame.size.width, bgView_1.frame.size.height - CGRectGetMaxY(_msgLeft.frame))];
        _imageView1.clipsToBounds = YES;
        _imageView1.contentMode = UIViewContentModeScaleAspectFill;
//        _imageView1.image = [UIImage imageNamed:@"img_fruits"];
        [self addSubview:_imageView1];
        
        UIView *bgView_2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(bgView_1.frame)+2, 0, self.frame.size.width/2 -1, self.frame.size.height/2 -1)];
        bgView_2.tag = 101;
        bgView_2.backgroundColor = [UIColor whiteColor];
        bgView_2.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap_2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [bgView_2 addGestureRecognizer:tap_2];
        [self addSubview:bgView_2];
        
        UIImageView *iconUp = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
        iconUp.image = [UIImage imageNamed:@"iicon_popular-fresh"];
        [bgView_2 addSubview:iconUp];
        
        _titleUp = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconUp.frame)+10, iconUp.frame.origin.y, 120, iconUp.frame.size.height)];
        _titleUp.font = [UIFont systemFontOfSize:17];
        _titleUp.text = @"人气生鲜";
        CGFloat width = [UILabel getWidthWithTitle:_titleUp.text font:_titleUp.font];
        _titleUp.frame = CGRectMake(CGRectGetMaxX(iconUp.frame)+10, iconUp.frame.origin.y, width, iconUp.frame.size.height);
        _titleWidth = width;
        [bgView_2 addSubview:_titleUp];
        
        _msgUp = [[UILabel alloc] initWithFrame:CGRectMake(iconUp.frame.origin.x, CGRectGetMaxY(_titleUp.frame), 0, _msgLeft.frame.size.height)];
        _msgUp.text = @"让大伙替你选!";
        _msgUp.textColor = _msgLeft.textColor;
        _msgUp.font = _msgLeft.font;
        _msgUp.frame = CGRectMake(_msgUp.frame.origin.x, CGRectGetMaxY(_titleUp.frame), 120, _msgUp.frame.size.height);
        [bgView_2 addSubview:_msgUp];
        
        
        _imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleUp.frame)+2, CGRectGetMaxY(_titleUp.frame), bgView_2.frame.size.width - CGRectGetMaxX(_titleUp.frame) - 2, bgView_2.frame.size.height - CGRectGetMaxY(_titleUp.frame))];
        _imageView2.clipsToBounds = YES;
        _imageView2.contentMode = UIViewContentModeScaleAspectFit;
//        _imageView2.image = [UIImage imageNamed:@"img_popular-fresh"];
        [bgView_2 addSubview:_imageView2];
        
        UIView *bgView_3 = [[UIView alloc] initWithFrame:CGRectMake(bgView_2.frame.origin.x, CGRectGetMaxY(bgView_2.frame)+2, bgView_2.frame.size.width, bgView_2.frame.size.height)];
        bgView_3.backgroundColor = [UIColor whiteColor];
        bgView_3.tag = 102;
        bgView_3.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap_3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [bgView_3 addGestureRecognizer:tap_3];
        [self addSubview:bgView_3];
        
        UIImageView *iconDown = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
        iconDown.image = [UIImage imageNamed:@"icon_today's-special"];
        [bgView_3 addSubview:iconDown];
        
        _titleDown = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconDown.frame)+10, iconDown.frame.origin.y, _titleWidth, iconDown.frame.size.height)];
        _titleDown.font = [UIFont systemFontOfSize:17];
        _titleDown.text = @"今日特惠";
        [bgView_3 addSubview:_titleDown];
        
        _msgDown = [[UILabel alloc] initWithFrame:CGRectMake(iconDown.frame.origin.x, CGRectGetMaxY(iconDown.frame), 80, _msgLeft.frame.size.height)];
        _msgDown.text = @"每日精选";
        _msgDown.font = _msgLeft.font;
        _msgDown.textColor = _msgLeft.textColor;
        [bgView_3 addSubview:_msgDown];
        
        
        _imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleDown.frame)+2, CGRectGetMaxY(_titleDown.frame), _imageView2.frame.size.width, _imageView2.frame.size.height)];
        _imageView3.clipsToBounds = YES;
        _imageView3.contentMode = UIViewContentModeScaleAspectFit;
//        _imageView3.image = [UIImage imageNamed:@"img_today's-special"];
        [bgView_3 addSubview:_imageView3];
        
    }
    return self;
}

- (void)tapAction:(UIGestureRecognizer *)tap {
    UIView *view = tap.view;
    NSLog(@"%ld",view.tag);
    if ([_delegate respondsToSelector:@selector(clickAdViewIndex:)]) {
        [_delegate clickAdViewIndex:view.tag - 100];
    }
}

- (void)setDataArray:(NSArray *)dataArray {
//    dataArray = [[dataArray reverseObjectEnumerator] allObjects];
    _dataArray = dataArray;
    
    if (dataArray.count > 0) {
        for (SupermarketHomeADVData *data in dataArray) {
            if ([data.ad_type isEqualToString:@"20"]) {
                [UIImageView setimageWithImageView:_imageView1 UrlString:data.ad_image imageVersion:data.version];
                _titleLeft.text = data.ad_title;
                _msgLeft.text = data.sub_title;
            }
        }
    }
    
    if (dataArray.count > 1) {
//        SupermarketHomeADVData *data_1 = dataArray[1];
        for (SupermarketHomeADVData *data in dataArray) {
            if ([data.ad_type isEqualToString:@"30"]) {
                [UIImageView setimageWithImageView:_imageView2 UrlString:data.ad_image imageVersion:data.version];
                _titleUp.text = data.ad_title;
                _msgUp.text = data.sub_title;
            }
        }
    }
    
    if (dataArray.count > 2) {
//        SupermarketHomeADVData *data_2 = dataArray[2];
        for (SupermarketHomeADVData *data in dataArray) {
            if ([data.ad_type isEqualToString:@"40"]) {
                [UIImageView setimageWithImageView:_imageView3 UrlString:data.ad_image imageVersion:data.version];
                _titleDown.text = data.ad_title;
                _msgDown.text = data.sub_title;
            }
        }
    }

}

@end
