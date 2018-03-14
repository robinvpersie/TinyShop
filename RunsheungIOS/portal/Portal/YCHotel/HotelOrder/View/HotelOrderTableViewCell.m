//
//  HotelOrderTableViewCell.m
//  Portal
//
//  Created by ifox on 2017/4/10.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelOrderTableViewCell.h"
#import "UILabel+WidthAndHeight.h"
#import "UILabel+CreateLabel.h"

@implementation HotelOrderTableViewCell {
    UILabel *_orderNum;
    UILabel *_orderStatus;
    UILabel *_hotelName;
    UILabel *_roomType;
    UILabel *_time;
    UILabel *_price;
    
    UIView *_upLine;
    UIView *_downLine;
    
    UIButton *_reserveAgain;
    UIButton *_cancelOrder;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }   
    return self;
}

- (void)createView {
    if (_orderNum == nil) {
        _orderNum = [UILabel createLabelWithFrame:CGRectMake(10, 0, 250, 35) textColor:HotelGrayColor font:[UIFont systemFontOfSize:13] textAlignment:NSTextAlignmentLeft text:@"订单号:201703201730"];
    }
    [self.contentView addSubview:_orderNum];
    
    if (_orderStatus == nil) {
        _orderStatus = [UILabel createLabelWithFrame:CGRectMake(APPScreenWidth - 10 - 100, _orderNum.frame.origin.y, 100, _orderNum.frame.size.height) textColor:PurpleColor font:_orderNum.font textAlignment:NSTextAlignmentRight text:@"预定成功"];
    }
    [self.contentView addSubview:_orderStatus];
    
    if (_upLine == nil) {
        _upLine = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_orderNum.frame), APPScreenWidth - 20, 0.7f)];
        _upLine.backgroundColor = BorderColor;
    }
    [self.contentView addSubview:_upLine];
    
    if (_hotelName == nil) {
        _hotelName = [UILabel createLabelWithFrame:CGRectMake(_orderNum.frame.origin.x, CGRectGetMaxY(_upLine.frame), 200, 40) textColor:HotelBlackColor font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentLeft text:@"长沙宇成国际酒店"];
    }
    [self.contentView addSubview:_hotelName];
    
    if (_roomType == nil) {
        _roomType = [UILabel createLabelWithFrame:CGRectMake(_orderNum.frame.origin.x, CGRectGetMaxY(_hotelName.frame), 200, 20) textColor:HotelGrayColor font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft text:@"高级大床房    1晚1间"];
    }
    [self.contentView addSubview:_roomType];
    
    if (_time == nil) {
        _time = [UILabel createLabelWithFrame:CGRectMake(_orderNum.frame.origin.x, CGRectGetMaxY(_roomType.frame), 250, _roomType.frame.size.height) textColor:_roomType.textColor font:_roomType.font textAlignment:NSTextAlignmentLeft text:@"2017-03-20至2017-03-21"];
    }
    [self.contentView addSubview:_time];
    
    if (_price == nil) {
        _price = [UILabel createLabelWithFrame:CGRectMake(APPScreenWidth - 10 - 100, _time.frame.origin.y, 100, 30) textColor:HotelBlackColor font:[UIFont systemFontOfSize:17] textAlignment:NSTextAlignmentRight text:@"￥320"];
    }
    [self.contentView addSubview:_price];
    
    if (_downLine == nil) {
        _downLine = [[UIView alloc] initWithFrame:CGRectMake(_orderNum.frame.origin.x, CGRectGetMaxY(_price.frame) + 10,_upLine.frame.size.width, _upLine.frame.size.height)];
        _downLine.backgroundColor = BorderColor;
    }
    [self.contentView addSubview:_downLine];
    
    if (_reserveAgain == nil) {
        
    }
    [self.contentView addSubview:_reserveAgain];
    
    if (_cancelOrder == nil) {
        
    }
    [self.contentView addSubview:_cancelOrder];
}

- (void)setData:(HotelOrderListModel *)data {
    _data = data;
    
    _orderNum.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"SMOrderCode", nil),data.orderID];
    _hotelName.text = data.hotelName;
    _roomType.text = data.roomTypeName;
    _time.text = [NSString stringWithFormat:@"%@%@%@",data.arriveTime,NSLocalizedString(@"HotelZhi", nil),data.leaveTime];
    _price.text = [NSString stringWithFormat:@"￥%@",data.roomPrice];
    switch (data.orderStatus) {
        case HotelOrderStatusWaitPay:
            _orderStatus.text = NSLocalizedString(@"HotelOrderStatus_0", nil);
            break;
            
        case HotelOrderStatusPayFinish:
            _orderStatus.text = NSLocalizedString(@"HotelOrderStatus_1", nil);
            break;
            
        case HotelOrderStatusOverTime:
            _orderStatus.text = NSLocalizedString(@"HotelOrderStatus_2", nil);
            break;
            
        case HotelOrderStatusCancel:
            _orderStatus.text = NSLocalizedString(@"HotelOrderStatus_3", nil);
            break;
            
        case HotelOrderStatusLiveIn:
            _orderStatus.text = NSLocalizedString(@"HotelOrderStatus_4", nil);
            break;
            
        case HotelOrderStatusLeave:
            _orderStatus.text = NSLocalizedString(@"HotelOrderStatus_5", nil);
            break;
            
        case HotelOrderStatusComment:
            _orderStatus.text = NSLocalizedString(@"HotelOrderStatus_6", nil);
            break;
            
        case HotelOrderStatusDelete:
            break;
            
//        case HotelOrderStatusArrangedRoom:
//            _orderStatus.text = NSLocalizedString(@"HotelOrderStatus_8", nil);
//            break;
        
        case HotelOrderStatusRoomOverTime:
            _orderStatus.text = NSLocalizedString(@"HotelOrderStatus_9", nil);
            break;
            
        case HotelOrderStatusWaitTake:
            _orderStatus.text = @"等待接单";
            break;
        
        case HotelOrderStatusTaking:
            _orderStatus.text = @"酒店接单";
            break;
            
        case HotelOrderStatusRefuse:
            _orderStatus.text = @"酒店拒绝";
            break;
        default:
            break;
    }
}

@end
