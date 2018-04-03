//
//  SupermarketOrderData.h
//  Portal
//
//  Created by ifox on 2016/12/23.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 订单状态
 */
typedef NS_ENUM(NSInteger, OrderStatus) {
    OrderWaitPay = 1,    //待付款
    OrderWaitReceive,    //待收货
    OrderWaitComment,    //待评价
    OrderCancel,         //订单取消
    OrderFinished,       //已评价
    OrderClosed,       //订单关闭
};


/**
 支付状态
 */
typedef NS_ENUM(NSInteger, PaymentStatus) {
    PaymentStatusNO = 1,     //未付款
    PaymentStatusYES,          //已付款
};

/**
 发货状态
 */
typedef NS_ENUM(NSInteger, ExpressStatus) {
    ExpressNoNeedSend = 0, //无需发货
    ExpressWaitSend,       //待发货
    ExpressHaveSend,       //已发货
};


/**
 订单评价状态
 */
typedef NS_ENUM(NSInteger, AssessStatus) {
    AssessStatusNO = 1,   //订单未评价
    AssessStatusYES,      //订单已评价
};

@interface SupermarketOrderData : NSObject

@property(nonatomic, copy)   NSString *time;
@property(nonatomic, copy)   NSString *severTime;
@property(nonatomic, copy)   NSString *createTime;
@property(nonatomic, assign) OrderStatus status;//订单状态
@property(nonatomic, assign) NSInteger goodsCount;//商品数量
@property(nonatomic, assign) float totalPrice;//总价格
@property(nonatomic, strong) NSArray *goodList;//单个订单里的列表
@property(nonatomic, copy) NSString *order_code;
@property(nonatomic, copy) NSString *invalid_date;//订单失效时间
@property(nonatomic, assign) PaymentStatus paymentStatus;//支付状态
@property(nonatomic, assign) ExpressStatus expressStatus;//物流状态
@property(nonatomic, assign) AssessStatus assessStatus;//评价状态
@property(nonatomic, copy) NSString *point;//使用积分
@property(nonatomic, copy) NSString *actualMoney;//实际付款金额
@property(nonatomic, strong) NSNumber *syncPaymentStatus;//同步状态 0失败1成功
@property(nonatomic, strong) NSNumber *canDeleteOrder;
@property(nonatomic, strong) NSNumber *canBuyAgain;//是否能重新购买

@property(nonatomic, copy) NSString *divCode;
@property(nonatomic,copy)NSString *sale_custom_code;

//@property(nonatomic, strong) NSArray *addtionalGoods;//附加商品


@end
