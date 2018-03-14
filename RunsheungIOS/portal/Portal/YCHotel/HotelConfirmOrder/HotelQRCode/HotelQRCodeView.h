//
//  HotelQRCodeView.h
//  Portal
//
//  Created by ifox on 2017/4/21.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HotelQRCodeViewDelegate <NSObject>

@optional

- (void)QRCodeViewRefreshAction;

@end

@interface HotelQRCodeView : UIView

@property(nonatomic, copy) NSString *qrCodeMsg;//二维码信息
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, copy) NSString *registerID;//房间注册信息
@property(nonatomic, copy) NSString *roomNo;//房间编号
@property(nonatomic, strong) HotelOrderDetailModel *orderDetail;//订单详情

@property(nonatomic,weak) id<HotelQRCodeViewDelegate>delegate;
@end
