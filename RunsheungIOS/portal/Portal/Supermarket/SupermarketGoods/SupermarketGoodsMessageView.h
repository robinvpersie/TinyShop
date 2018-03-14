//
//  SupermarketGoodsMessageView.h
//  Portal
//
//  Created by 左梓豪 on 2016/12/8.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SupermarketGoodsModel;

@interface SupermarketGoodsMessageView : UIView

@property(nonatomic, strong) UILabel *buyAmountLabel;

@property(nonatomic, strong) SupermarketGoodsModel *goodsModel;

@end
