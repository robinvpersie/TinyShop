//
//  SupermarketConfirmOrderGoodsCell.h
//  Portal
//
//  Created by ifox on 2016/12/26.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupermarketOrderGoodsData.h"

@interface SupermarketConfirmOrderGoodsCell : UITableViewCell

@property(nonatomic, strong) SupermarketOrderGoodsData *goods;
@property(nonatomic, assign) NSInteger cellType;//如果是订单详情 显示退款 值为1
@property(nonatomic, copy) NSString *order_num;//订单编号
@property(nonatomic, assign) NSInteger orderStatus;//订单状态  为3才显示退货退款

@end
