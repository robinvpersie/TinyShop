//
//  SupermarketChoseSizeView.h
//  Portal
//
//  Created by ifox on 2017/2/9.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChoseSizeViewDelegate <NSObject>

@optional

- (void)choseSizeViewSureButtonClicked:(NSArray *)choseTitles;

@end

@interface SupermarketChoseSizeView : UIView

@property(nonatomic, weak) id<ChoseSizeViewDelegate> delegate;

@property(nonatomic, strong) UIImageView *iconImgView;
@property(nonatomic, strong) UILabel *goodsPriceLabel;
@property(nonatomic, strong) UILabel *goodsStockLabel;

@property(nonatomic, assign) NSInteger buyAmount;

@property(nonatomic, strong) NSArray *dataSource;//数据源数组

- (void)showInView:(UIView *)view;

- (void)removeView;

@end
