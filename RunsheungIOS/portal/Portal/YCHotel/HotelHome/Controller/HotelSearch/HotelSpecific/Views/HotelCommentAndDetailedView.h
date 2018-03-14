//
//  HotelCommentAndDetailedView.h
//  Portal
//
//  Created by 王五 on 2017/4/8.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelSegmentView.h"
@class  HotelDetailModel;
@protocol HotelDetailDelegate<NSObject>
- (void)clickShowMoreHotelDetialed;
@end
@interface HotelCommentAndDetailedView : UIView<SegmentDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property(nonatomic,strong)NSMutableArray *buttonList;
@property (nonatomic, weak) HotelSegmentView *segment;
@property(nonatomic,weak)CALayer *LGLayer;
@property (nonatomic,assign)id<HotelDetailDelegate> hoteldetaildelegate;

@property (nonatomic,strong)HotelDetailModel *detailmodel;
@end
