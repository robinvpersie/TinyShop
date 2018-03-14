//
//  IntergrationTableViewCell.h
//  Portal
//
//  Created by ifox on 2017/1/9.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupermarketPointModel.h"

@interface IntergrationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property(nonatomic, strong) SupermarketPointModel *pointModel;

@end
