//
//  SupermarketMineHeaderView.h
//  Portal
//
//  Created by ifox on 2016/12/23.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupermarketMineData.h"

@interface SupermarketMineHeaderView : UIView

@property(nonatomic, strong)SupermarketMineData *data;
@property(nonatomic, assign) ControllerType controllerType;
@property(nonatomic, copy) NSString *divCode;

-(void)refreshUIWithPhone:(NSString *)phone nickName:(NSString *)nickName avatarUrlString:(NSString *)url;

@end
