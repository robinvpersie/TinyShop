//
//  HotelHeadView.h
//  Portal
//
//  Created by 王五 on 2017/4/8.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  HotelDetailModel;
@protocol HotelHeadDelegaete<NSObject>

/**
 点击获取更多酒店的图片
 */
- (void)clickHotelHeadPics;

/**
 点击获取定位的图片
 */
- (void)clickHotelHeadLocation;
@end

@interface HotelHeadView : UIView
@property (nonatomic,assign)id<HotelHeadDelegaete> picsdelegate;

@property (nonatomic,strong)HotelDetailModel *detailmodel;
@end
