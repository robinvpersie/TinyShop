//
//  LZCartTableViewCell.h
//  LZCartViewController
//
//  Created by LQQ on 16/5/18.
//  Copyright © 2016年 LQQ. All rights reserved.
//  https://github.com/LQQZYY/CartDemo
//  http://blog.csdn.net/lqq200912408
//  QQ交流: 302934443

#import <UIKit/UIKit.h>

@class LZCartModel;
typedef void(^LZNumberChangedBlock)(NSInteger number);
typedef void(^LZCellSelectedBlock)(BOOL select);

@interface LZCartTableViewCell : UITableViewCell
//商品数量
@property (assign,nonatomic)NSInteger lzNumber;
@property (assign,nonatomic)BOOL lzSelected;
@property (assign,nonatomic)BOOL isEditing;
@property (assign,nonatomic) BOOL isCollection;//是否是收藏夹

- (void)reloadDataWithModel:(LZCartModel*)model;
- (void)numberAddWithBlock:(LZNumberChangedBlock)block;
- (void)numberCutWithBlock:(LZNumberChangedBlock)block;
- (void)cellSelectedWithBlock:(LZCellSelectedBlock)block;
- (void)configureWithModel: (NewCartModel *)model;
@end
