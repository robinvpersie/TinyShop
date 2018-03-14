//
//  SupermarketOnSaleCell.h
//  Portal
//
//  Created by ifox on 2016/12/28.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SupermarketOnSaleCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *addShoppingCart;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;

@end
