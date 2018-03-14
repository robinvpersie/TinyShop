//
//  HotelProgressView.m
//  Portal
//
//  Created by ifox on 2017/4/14.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelProgressView.h"
#import "UILabel+CreateLabel.h"
#import "UILabel+WidthAndHeight.h"
#import "NSDate+HotelAddition.h"

@implementation HotelProgressView {
    UIView *_leftCircle;
    UIView *_centerCircle;
    UIView *_rightCircle;
    
    UIView *_leftLine1;
    UIView *_leftLine2;
    
    UIView *_rightLine1;
    UIView *_rightLine2;
    
    UILabel *createTime;
    UILabel *confrimTime;
    
    UILabel *liveIn;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubview];
    }
    return self;
}

- (void)createSubview {
    _leftCircle = [[UIView alloc] initWithFrame:CGRectMake(70, 0, 15, 15)];
    _leftCircle.backgroundColor = BorderColor;
    _leftCircle.layer.cornerRadius = 7.5f;
    
    _rightCircle = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 70 - 15, _leftCircle.frame.origin.y, 15, 15)];
    _rightCircle.layer.cornerRadius = 7.5f;
    _rightCircle.backgroundColor = BorderColor;
    
    _centerCircle = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 7.5, _leftCircle.frame.origin.y, 15, 15)];
    _centerCircle.layer.cornerRadius = 7.5f;
    _centerCircle.backgroundColor = BorderColor;
    
    [self addSubview:_leftCircle];
    [self addSubview:_rightCircle];
    [self addSubview:_centerCircle];
    
    CGFloat width = [UILabel getWidthWithTitle:@"提交订单" font:[UIFont systemFontOfSize:13]];
    
    CGFloat timeWidth = [UILabel getWidthWithTitle:@"03-20 17:30" font:[UIFont systemFontOfSize:13]];
    
    UILabel *createOrder = [UILabel createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(_leftCircle.frame)+5, width, 20) textColor:HotelLightGrayColor font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentCenter text:@"提交订单"];
    CGPoint center = createOrder.center;
    center.x = _leftCircle.center.x;
    createOrder.center = center;
    [self addSubview:createOrder];
    
    createTime = [UILabel createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(createOrder.frame), timeWidth, 20) textColor:createOrder.textColor font:createOrder.font textAlignment:NSTextAlignmentCenter text:@"03-20 17:30"];
    createTime.center = CGPointMake(createOrder.center.x, createOrder.center.y + 20);
    [self addSubview:createTime];
    
    UILabel *hotelConfirm = [UILabel createLabelWithFrame:CGRectMake(0, createOrder.frame.origin.y, width, createOrder.frame.size.height) textColor:createOrder.textColor font:createOrder.font textAlignment:NSTextAlignmentCenter text:@"酒店确认"];
    CGPoint centerConfirm = hotelConfirm.center;
    centerConfirm.x = _centerCircle.center.x;
    hotelConfirm.center = centerConfirm;
    [self addSubview:hotelConfirm];
    
    confrimTime = [UILabel createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(hotelConfirm.frame), timeWidth, 20) textColor:hotelConfirm.textColor font:hotelConfirm.font textAlignment:NSTextAlignmentCenter text:@"03-20 17:31"];
    confrimTime.center = CGPointMake(hotelConfirm.center.x, hotelConfirm.center.y+20);
    [self addSubview:confrimTime];
    
    liveIn = [UILabel createLabelWithFrame:CGRectMake(0, createOrder.frame.origin.y, width, createOrder.frame.size.height) textColor:createOrder.textColor font:createOrder.font textAlignment:NSTextAlignmentCenter text:@"入住"];
    CGPoint liveInCenter = liveIn.center;
    liveInCenter.x = _rightCircle.center.x;
    liveIn.center = liveInCenter;
    [self addSubview:liveIn];
    
    CGFloat lineWidth = (CGRectGetMinX(_centerCircle.frame) - CGRectGetMaxX(_leftCircle.frame))/2;
    
    _leftLine1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftCircle.frame), CGRectGetMidY(_leftCircle.frame), lineWidth, 1.0f)];
    _leftLine1.backgroundColor = BorderColor;
    [self addSubview:_leftLine1];
    
    _leftLine2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftLine1.frame), _leftLine1.frame.origin.y, lineWidth, _leftLine1.frame.size.height)];
    _leftLine2.backgroundColor = BorderColor;
    [self addSubview:_leftLine2];
    
    _rightLine1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_centerCircle.frame), _leftLine1.frame.origin.y, lineWidth, _leftLine1.frame.size.height)];
    _rightLine1.backgroundColor = BorderColor;
    [self addSubview:_rightLine1];
    
    _rightLine2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_rightLine1.frame), _leftLine1.frame.origin.y, lineWidth, _rightLine1.frame.size.height)];
    _rightLine2.backgroundColor = BorderColor;
    [self addSubview:_rightLine2];
}

- (void)setCreateOrderTime:(NSString *)createOrderTime {
    _createOrderTime = createOrderTime;
    
    NSDate *date = [NSDate getDateWithString:createOrderTime];
    NSString *dateString = [NSDate getDateStringWithDate:date];
    createTime.text = dateString;
    
    NSTimeInterval time = [date timeIntervalSince1970] + 2*60;
    NSDate *nextDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *nextDateString = [NSDate getDateStringWithDate:nextDate];
    confrimTime.text = nextDateString;
    NSLog(@"%@",date);
}

- (void)setHotelOrderStatus:(HotelOrderStatus)hotelOrderStatus {
    _hotelOrderStatus = hotelOrderStatus;
    if (hotelOrderStatus == HotelOrderStatusPayFinish) {
        _leftCircle.backgroundColor = PurpleColor;
        _leftLine1.backgroundColor = PurpleColor;
        _leftLine2.backgroundColor = PurpleColor;
        _centerCircle.backgroundColor = PurpleColor;
        
    } else if (hotelOrderStatus == HotelOrderStatusLiveIn) {
        _leftCircle.backgroundColor = PurpleColor;
        _leftLine1.backgroundColor = PurpleColor;
        _leftLine2.backgroundColor = PurpleColor;
        _centerCircle.backgroundColor = PurpleColor;
        _rightLine1.backgroundColor = PurpleColor;
        _rightLine2.backgroundColor = PurpleColor;
        _rightCircle.backgroundColor = PurpleColor;
    }
}

@end
