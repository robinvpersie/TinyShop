//
//  ShopDetailedCollectionCell.h
//  GigaProject
//
//  Created by dlwpdlr on 2018/3/9.
//  Copyright © 2018年 GIGA Korea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopDetailedCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *shopImg;
@property (weak, nonatomic) IBOutlet UILabel *shopname;
@property (weak, nonatomic) IBOutlet UILabel *money;

@property (nonatomic,retain)NSDictionary *dic;
@end
