//
//  HotelIntroPhoneCell.h
//  Portal
//
//  Created by ifox on 2017/4/8.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HotelDetailInfoModel;
@interface HotelIntroPhoneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *hotelNameLab;
@property (weak, nonatomic) IBOutlet UILabel *hotelTypeLab;

@property (nonatomic,retain)HotelDetailInfoModel*model;
@end
