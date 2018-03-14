//
//  HotelHeadView.m
//  Portal
//
//  Created by 王五 on 2017/4/8.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelHeadView.h"
#import "HotelDetailModel.h"

#define tableHeadHeight 0.55 *APPScreenWidth
@implementation HotelHeadView{
    UIImageView *headImg;
    UILabel *locationLabel;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createHeadView:frame];
    }
    return self;
}

- (void)setDetailmodel:(HotelDetailModel *)detailmodel{
    _detailmodel = detailmodel;
    [headImg sd_setImageWithURL:[NSURL URLWithString:_detailmodel.hotelPhoto] placeholderImage:[UIImage imageNamed:@"hotel.jpg"]];
    headImg.contentMode = UIViewContentModeScaleAspectFit;
    headImg.clipsToBounds = YES;
    [locationLabel setText:_detailmodel.address];
}
- (void)createHeadView:(CGRect)frame{
    
    headImg = [[UIImageView alloc]init];
    
    headImg.userInteractionEnabled = YES;
    headImg.frame = CGRectMake(0, 0, APPScreenWidth, 7*CGRectGetHeight(frame)/10 + 5.0f);
    [self addSubview:headImg];
    //给头图片添加点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(tapHeadPics)];
    [headImg addGestureRecognizer:tap];
    
    
    UIButton *cameraBtn = [[UIButton alloc]initWithFrame:CGRectMake(APPScreenWidth - 65, CGRectGetHeight(headImg.frame)-30, 65, 28)];
    [cameraBtn setImage:[UIImage imageNamed:@"icon_imgnumber"] forState:UIControlStateNormal];
    [cameraBtn setTitle:@" 28" forState:UIControlStateNormal];
    [cameraBtn setFont:[UIFont systemFontOfSize:13]];
    [headImg addSubview:cameraBtn];
    
    UIView *locationView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headImg.frame), APPScreenWidth, 3*tableHeadHeight/10 - 5)];
    locationView.backgroundColor = [UIColor whiteColor];
    [self addSubview:locationView];
    
    locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, APPScreenWidth - CGRectGetHeight(locationView.frame)- 15, CGRectGetHeight(locationView.frame) - 10)];
    [locationLabel setTextColor:HotelLightGrayColor];
    [locationLabel setFont:[UIFont systemFontOfSize:14]];
    locationLabel.numberOfLines = 2;
    [locationView addSubview:locationLabel];
    
    UILabel *locationline = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(locationLabel.frame), 10, 1.0f, CGRectGetHeight(locationView.frame) - 20)];
    locationline.backgroundColor = BGColor;
    [locationView addSubview:locationline];
    
    UIImageView *locationImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_map"]];
    locationImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(tapHeadLocation)];
    [locationImg addGestureRecognizer:tap1];

    locationImg.frame = CGRectMake(CGRectGetMaxX(locationline.frame)+ CGRectGetHeight(locationView.frame)/4,CGRectGetHeight(locationView.frame)/4, CGRectGetHeight(locationView.frame)/2, CGRectGetHeight(locationView.frame)/2);
    [locationView addSubview:locationImg];
    
    
}

#pragma mark -- 点击图片相应的方法
- (void)tapHeadPics{
    if ([self.picsdelegate respondsToSelector:@selector(clickHotelHeadPics)] ) {
        [self.picsdelegate clickHotelHeadPics];
    }
    
}
- (void)tapHeadLocation{
    if ([self.picsdelegate respondsToSelector:@selector(clickHotelHeadLocation)] ) {
        [self.picsdelegate clickHotelHeadLocation];
    }
    
}

@end
