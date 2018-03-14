//
//  SupermarketChooseTimeCell.h
//  Portal
//
//  Created by ifox on 2016/12/15.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupermarketReceiveTimeModel.h"

@protocol SupermarketChooseTimeCellDelegate <NSObject>

- (void)clickCheckButton:(UIButton *)checkButton;

@end

@interface SupermarketChooseTimeCell : UITableViewCell

@property(nonatomic, strong) SupermarketReceiveTimeModel *timeModel;
@property(nonatomic, weak) id<SupermarketChooseTimeCellDelegate> delegate;

@end
