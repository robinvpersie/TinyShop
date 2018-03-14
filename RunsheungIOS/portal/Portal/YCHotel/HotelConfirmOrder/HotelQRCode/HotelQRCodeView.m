//
//  HotelQRCodeView.m
//  Portal
//
//  Created by ifox on 2017/4/21.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelQRCodeView.h"
#import "UIButton+CreateButton.h"
#import "ZHGenerateQRCode.h"
#import "UILabel+CreateLabel.h"
#import "UILabel+WidthAndHeight.h"
#import "HotelOrderDetailModel.h"

#define ContentViewWidth APPScreenWidth/7*5

@interface HotelQRCodeView ()

@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) ZHGenerateQRCode *qrcodeView;

@end

@implementation HotelQRCodeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3f];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ContentViewWidth, APPScreenHeight/2)];
    contentView.center = self.center;
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 4.0f;
    [self addSubview:contentView];
    self.contentView = contentView;
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(10, 10, 20, 20);
    [cancel setImage:[UIImage imageNamed:@"icon_closecity"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(hideSelf) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:cancel];
    
    ZHGenerateQRCode *qrcodeView = [[ZHGenerateQRCode alloc] initWithFrame:CGRectMake(0, 0, contentView.frame.size.width/3*2, contentView.frame.size.width/3*2)];
    qrcodeView.center = CGPointMake(contentView.frame.size.width/2, contentView.frame.size.height/2);
//    qrcodeView.message = @"978111349888221";
    self.qrcodeView = qrcodeView;
    [contentView addSubview:qrcodeView];
    
    UILabel *msg = [UILabel createLabelWithFrame:CGRectMake(5,contentView.frame.size.height - 25 - 10, contentView.frame.size.width-10, 25) textColor:HotelLightGrayColor font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentCenter text:NSLocalizedString(@"HotelQRMsg", nil)];
    [contentView addSubview:msg];
    
    UILabel *title = [UILabel createLabelWithFrame:CGRectMake(0, qrcodeView.frame.origin.y/2, contentView.frame.size.width, 25) textColor:HotelBlackColor font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentCenter text:NSLocalizedString(@"HotealQRName", nil)];
    [contentView addSubview:title];
    
    CGFloat distance = CGRectGetMinY(msg.frame) - CGRectGetMaxY(qrcodeView.frame);
    
    CGFloat width = [UILabel getWidthWithTitle:NSLocalizedString(@"HotelQRUpdate", nil) font:[UIFont systemFontOfSize:12]];
    UIButton *refresh = [UIButton createButtonWithFrame:CGRectMake(0, 0, width+25, 25) title:NSLocalizedString(@"HotelQRUpdate", nil) titleColor:PurpleColor titleFont:[UIFont systemFontOfSize:12] backgroundColor:[UIColor whiteColor]];
    [refresh setImage:[UIImage imageNamed:@"icon_refreshqr"] forState:UIControlStateNormal];
    [refresh addTarget:self action:@selector(refreshQRCode) forControlEvents:UIControlEventTouchUpInside];
    refresh.center = CGPointMake(contentView.frame.size.width/2,CGRectGetMaxY(qrcodeView.frame)+distance/2);
    [contentView addSubview:refresh];
//    _timer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(refreshQRCode) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];

}

- (void)refreshQRCode {
    //这里刷新qrcode
    NSLog(@"%@",[NSDate date]);
//    NSString *qrMsg = @"kjhkjiUkjeAPer9891";
//    self.qrcodeView.message = qrMsg;
    if ([self.delegate respondsToSelector:@selector(QRCodeViewRefreshAction)]) {
        [self.delegate QRCodeViewRefreshAction];
    }
    
    [YCHotelHttpTool hotelGetQRTextWithRegisterID:self.registerID hotelID:self.orderDetail.hotelID roomNo:_roomNo success:^(id response) {
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSDictionary *data = response[@"data"];
            NSString *QRText = data[@"QRText"];
            self.qrCodeMsg = QRText;
        }
    } failure:^(NSError *err) {
        
    }];
}

- (void)setQrCodeMsg:(NSString *)qrCodeMsg {
    _qrCodeMsg = qrCodeMsg;
    self.qrcodeView.message = qrCodeMsg;
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
//    if (hidden == YES) {
//        [self stopTimer];
//    } else {
//        [self startTimer];
//    }
}

- (void)startTimer {
    [_timer setFireDate:[NSDate date]];
}

- (void)stopTimer {
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)hideSelf {
    self.hidden = YES;
}

@end
