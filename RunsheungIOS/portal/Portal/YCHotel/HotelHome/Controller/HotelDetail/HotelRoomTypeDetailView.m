//
//  HotelRoomTypeDetailView.m
//  Portal
//
//  Created by ifox on 2017/4/26.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelRoomTypeDetailView.h"
#import "UIButton+CreateButton.h"
#import "ZHSCorllHeader.h"
#import "UILabel+CreateLabel.h"
#import "UILabel+WidthAndHeight.h"
#import "YYText.h"

@interface HotelRoomTypeDetailView ()

@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) ZHSCorllHeader *banner;
@property(nonatomic, strong) UILabel *roomTypeName;

@property(nonatomic, strong) NSMutableAttributedString *msg_0;
@property(nonatomic, strong) NSMutableAttributedString *msg_1;
@property(nonatomic, strong) NSMutableAttributedString *msg_2;
@property(nonatomic, strong) NSMutableAttributedString *msg_3;

@end

@implementation HotelRoomTypeDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubView];
//        self.layer.cornerRadius = 5.0f;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)createSubView {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, APPScreenWidth - 30, APPScreenHeight/5*3)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.center = self.center;
    contentView.layer.cornerRadius = 5.0f;
    self.contentView = contentView;
    [self addSubview:contentView];
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    close.frame = CGRectMake(contentView.frame.size.width - 10 - 25, 10, 25, 25);
    [close setImage:[UIImage imageNamed:@"icon_closecity"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:close];
    
    UILabel *roomTypeName = [UILabel createLabelWithFrame:CGRectMake(10, 0, 200, 40) textColor:HotelBlackColor font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft text:@""];
    self.roomTypeName = roomTypeName;
    [contentView addSubview:roomTypeName];
    
    _banner = [[ZHSCorllHeader alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(roomTypeName.frame), contentView.frame.size.width, contentView.frame.size.height/2 - 20)];
    [contentView addSubview:_banner];
    
    CGFloat width = [UILabel getWidthWithTitle:NSLocalizedString(@"HotelRoomInfoNet", nil) font:[UIFont systemFontOfSize:11]];
    NSArray *leftTitles = @[NSLocalizedString(@"HotelRoomInfoNet", nil),NSLocalizedString(@"HotelRoomInfoWindow", nil),NSLocalizedString(@"HotelRoomInfoSquare", nil)];
    NSArray *rightTitles = @[NSLocalizedString(@"HotelRoomInfoLevel", nil),NSLocalizedString(@"HotelRoomInfoPeople", nil),NSLocalizedString(@"HotelRoomInfoBed", nil)];
    
    UILabel *title;
    for (int i = 0; i < 6; i++) {
        NSInteger coulum = i%2;
        if (coulum == 0) {
            title = [UILabel createLabelWithFrame:CGRectMake(10, 25*(i/2)+CGRectGetMaxY(_banner.frame)+5, width, 25) textColor:HotelLightGrayColor font:[UIFont systemFontOfSize:11] textAlignment:NSTextAlignmentLeft text:leftTitles[i/2]];
        } else {
            title = [UILabel createLabelWithFrame:CGRectMake(contentView.frame.size.width/2, 25*(i/2)+CGRectGetMaxY(_banner.frame)+5, width, 25) textColor:HotelLightGrayColor font:[UIFont systemFontOfSize:11] textAlignment:NSTextAlignmentLeft text:rightTitles[i/2]];
        }
        [contentView addSubview:title];
        UILabel *detail = [UILabel createLabelWithFrame:CGRectMake(CGRectGetMaxX(title.frame)+10, title.frame.origin.y, 100, title.frame.size.height) textColor:HotelBlackColor font:title.font textAlignment:NSTextAlignmentLeft text:@""];
        detail.tag = i + 100;
        [contentView addSubview:detail];
    }
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(title.frame), contentView.frame.size.width, 0.7f)];
    line.backgroundColor = BorderColor;
    [contentView addSubview:line];
    
    YYLabel *label;
    for (int i = 0; i < 4; i++) {
        label = [YYLabel new];
        label.frame = CGRectMake(10, CGRectGetMaxY(line.frame)+25*i, self.contentView.frame.size.width - 10, 25);
        label.tag = 200 + i;
        [contentView addSubview:label];
    }
    
    CGRect contentFrame = contentView.frame;
    contentFrame.size.height = CGRectGetMaxY(label.frame) + 20;
    contentView.frame = contentFrame;
}

- (void)setRoomModel:(HotelRoomInfoModel *)roomModel {
    _roomModel = roomModel;
    _banner.urlImagesArray = roomModel.imageUrls;
    _roomTypeName.text = roomModel.roomTypeName;
    
    NSMutableArray *servieces = @[].mutableCopy;
    
    {
        //房间设施
        NSString *facilityTitle = NSLocalizedString(@"HotelRoomInfo_01", nil);
        NSMutableString *facility = [[NSMutableString alloc] initWithString:facilityTitle];
        if (roomModel.hotelRoomFacility.count > 0) {
            for (HotelRoomInfoServiceModel *facilityModel in roomModel.hotelRoomFacility) {
                [facility appendString:[NSString stringWithFormat:@"%@   ",facilityModel.serviceDetailName]];
            }
        }
        if (facility.length > facilityTitle.length) {
            NSMutableAttributedString *faciAtrStr = [[NSMutableAttributedString alloc] initWithString:facility];
            [faciAtrStr yy_setTextHighlightRange:NSMakeRange(0, facilityTitle.length) color:HotelBlackColor backgroundColor:[UIColor whiteColor] tapAction:nil];
            [servieces addObject:faciAtrStr];
        }
    }
    
    
    {
        //浴室
        NSString *showerTitle = NSLocalizedString(@"HotelRoomInfo_02", nil);
        NSMutableString *shower = [[NSMutableString alloc] initWithString:showerTitle];
        if (roomModel.hotelRoomShower.count > 0) {
            for (HotelRoomInfoServiceModel *showerModel in roomModel.hotelRoomShower) {
                [shower appendString:[NSString stringWithFormat:@"%@  ",showerModel.serviceDetailName]];
            }
        }
        if (shower.length > showerTitle.length) {
            NSMutableAttributedString *showerAtrStr = [[NSMutableAttributedString alloc] initWithString:shower];
            [showerAtrStr yy_setTextHighlightRange:NSMakeRange(0, showerTitle.length) color:HotelBlackColor backgroundColor:[UIColor whiteColor] tapAction:nil];
            [servieces addObject:showerAtrStr];
        }
    }
    
    {
        //食品饮品
        NSString *foodTitle = NSLocalizedString(@"HotelRoomInfo_03", nil);
        NSMutableString *food = [[NSMutableString alloc] initWithString:foodTitle];
        if (roomModel.hotelRoomFoods.count > 0) {
            for (HotelRoomInfoServiceModel *foodModel in roomModel.hotelRoomFoods) {
                [food appendString:[NSString stringWithFormat:@"%@ ",foodModel.serviceDetailName]];
            }
        }
        
        if (food.length > foodTitle.length) {
            NSMutableAttributedString *foodAtrStr = [[NSMutableAttributedString alloc] initWithString:food];
            [foodAtrStr yy_setTextHighlightRange:NSMakeRange(0, foodTitle.length) color:HotelBlackColor backgroundColor:[UIColor whiteColor] tapAction:nil];
            [servieces addObject:foodAtrStr];
        }
    }
    
    {
        //多媒体
        NSString *mediaTitle = NSLocalizedString(@"HotelRoomInfo_04", nil);
        NSMutableString *media = [[NSMutableString alloc] initWithString:mediaTitle];
        if (roomModel.hotelMedia.count > 0) {
            for (HotelRoomInfoServiceModel *mediaModel in roomModel.hotelMedia) {
                [media appendString:[NSString stringWithFormat:@"%@ ",mediaModel.serviceDetailName]];
            }
        }
        
        if (media.length > mediaTitle.length) {
            NSMutableAttributedString *mediaAtrStr = [[NSMutableAttributedString alloc] initWithString:media];
            [mediaAtrStr yy_setTextHighlightRange:NSMakeRange(0, mediaTitle.length) color:HotelBlackColor backgroundColor:[UIColor whiteColor] tapAction:nil];
            [servieces addObject:mediaAtrStr];
        }
    }
    
    NSArray *subViews = _contentView.subviews;
    for (UIView *view in subViews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            if (label.tag == 100) {
              label.text = @"WIFI";
            } else if (label.tag == 101) {
                label.text = [NSString stringWithFormat:@"%@层",roomModel.floor];
            } else if (label.tag == 102) {
                label.text = @"有";
            } else if (label.tag == 103) {
                label.text = [NSString stringWithFormat:@"%@人",roomModel.availableNum];
            } else if (label.tag == 104) {
                label.text = [NSString stringWithFormat:@"%@㎡",roomModel.area];
            } else if (label.tag == 105) {
                label.text = [NSString stringWithFormat:@"%@",roomModel.bedType];
            }
        } else if ([view isKindOfClass:[YYLabel class]]) {
            YYLabel *label = (YYLabel *)view;
            label.text = @"";
            
            for (int i = 0; i < servieces.count; i++) {
                label = [self.contentView viewWithTag:200+i];
                label.attributedText = servieces[i];
                label.textColor = HotelLightGrayColor;
            }
        }
    }
}

- (void)closeView {
    self.hidden = YES;
}

@end
