//
//  SupermarketOrderTableView.h
//  Portal
//
//  Created by ifox on 2016/12/22.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef NS_ENUM(NSInteger, OrderStatus) {
//    OrderWaitPay = 0,       //待支付
//    OrderWaitSend,          //待发货
//    OrderWaitPick,          //待自提
//    OrderWaitReceive,       //待收货
//    OrderWaitComment        //待评价
//};


/**
 再创建tableView时需要先给类型再给数据
 */
@interface SupermarketOrderTableView : UITableView<UITableViewDelegate, UITableViewDataSource>

//@property(nonatomic, assign) OrderStatus orderStatus;
@property(nonatomic, strong) NSArray *dataArray;
@property(nonatomic, assign) BOOL isPageView;
@property(nonatomic, assign) ControllerType controllerType;

@end
