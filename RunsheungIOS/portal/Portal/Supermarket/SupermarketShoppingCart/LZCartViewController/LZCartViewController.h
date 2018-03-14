//
//  LZCartViewController.h
//  LZCartViewController
//
//  Created by LQQ on 16/5/18.
//  Copyright © 2016年 LQQ. All rights reserved.
//  https://github.com/LQQZYY/CartDemo
//  http://blog.csdn.net/lqq200912408
//  QQ交流: 302934443

#import <UIKit/UIKit.h>
#import "SupermarketBaseViewController.h"


@interface LZCartViewController : SupermarketBaseViewController

@property(nonatomic, assign) ControllerType controllerType;
@property(nonatomic, assign) BOOL isPush;

@property(nonatomic, copy) NSString *divCode;

@end
