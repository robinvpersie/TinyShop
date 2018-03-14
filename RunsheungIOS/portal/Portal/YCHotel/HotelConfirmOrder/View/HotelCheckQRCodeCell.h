//
//  HotelCheckQRCodeCell.h
//  Portal
//
//  Created by ifox on 2017/4/22.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HotelCheckQRCodeCell;

@protocol HotelCheckQRCodeCellDelegate  <NSObject>

- (void)checkQRCodeButtonClick:(HotelCheckQRCodeCell *)cell;

@end

@interface HotelCheckQRCodeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *roomNum;
@property (weak, nonatomic) IBOutlet UIButton *checkQRCode;
@property (weak, nonatomic) IBOutlet UILabel *roomCode;
@property (weak, nonatomic) IBOutlet UIView *line;

@property (weak, nonatomic) id<HotelCheckQRCodeCellDelegate> delegate;

@end
