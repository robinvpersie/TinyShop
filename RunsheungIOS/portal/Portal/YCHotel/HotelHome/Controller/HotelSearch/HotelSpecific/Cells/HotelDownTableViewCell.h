//
//  HotelDownTableViewCell.h
//  Portal
//
//  Created by 王五 on 2017/4/8.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelDownTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *IsContainMoringLab;
@property (weak, nonatomic) IBOutlet UILabel *CancelLab;
@property (weak, nonatomic) IBOutlet UILabel *specificEnjoy;
@property (weak, nonatomic) IBOutlet UILabel *todaySpecific;
@property (weak, nonatomic) IBOutlet UILabel *callBack;
@property (weak, nonatomic) IBOutlet UIButton *OrderBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *backDetailed;
@property (weak, nonatomic) IBOutlet UIButton *reserveBtn;

@end
