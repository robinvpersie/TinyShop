//
//  SupermarketLimitBuyCell.h
//  Portal
//
//  Created by ifox on 2016/12/29.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProgressView;

@interface SupermarketLimitBuyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyRightNow;
@property (weak, nonatomic) IBOutlet ProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;

@end
