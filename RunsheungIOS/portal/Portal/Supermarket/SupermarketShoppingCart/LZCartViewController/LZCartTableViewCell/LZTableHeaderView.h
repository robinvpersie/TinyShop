//
//  LZTableHeaderView.h
//  LZCartViewController
//
//  Created by Artron_LQQ on 16/5/31.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^buttonClickBlock)(BOOL select);
@interface LZTableHeaderView : UITableViewHeaderFooterView

@property (copy,nonatomic)NSString *title;
@property (copy,nonatomic)buttonClickBlock lzClickBlock;
@property (copy,nonatomic)buttonClickBlock editClickBlock;
@property (assign,nonatomic)BOOL selectShop;
@property (assign,nonatomic)BOOL isEditingSelected;

@end
