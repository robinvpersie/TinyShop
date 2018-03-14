//
//  SupermarketMostFreshCell.h
//  Portal
//
//  Created by ifox on 2016/12/27.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SupermarketMostFreshCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;

@end
