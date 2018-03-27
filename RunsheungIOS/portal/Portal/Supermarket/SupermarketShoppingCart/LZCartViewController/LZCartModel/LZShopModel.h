//
//  LZShopModel.h
//  LZCartViewController
//
//  Created by Artron_LQQ on 16/5/31.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZShopModel : NSObject

@property(assign,nonatomic)BOOL editing;

@property (assign,nonatomic)BOOL select;
@property (copy,nonatomic)NSString *shopID;//对应divCode
@property (copy,nonatomic)NSString *shopName;//对应divName
@property (copy,nonatomic)NSString *sID;
@property (strong,nonatomic)NSMutableArray *goodsArray;

@property (strong,nonatomic)NSMutableArray *selectedGoodsArray;

- (void)configGoodsArrayWithArray:(NSArray*)array;
@end
