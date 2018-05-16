//
//  PaymentWay.h
//  Portal
//
//  Created by ifox on 2017/4/6.
//  Copyright © 2017年 linpeng. All rights reserved.
// test jake

#import <Foundation/Foundation.h>


@interface PaymentWay : NSObject

/**
 微信支付的方法

 @param orderDic 生成的订单字典
 @param controller 调用的控制器对象
 */
//+ (void)wechatpay:(NSDictionary*)orderDic
//   viewController:(UIViewController *)controller;

+ (void)alipay:(NSString *)orderStr;

+ (void)unionpay:(NSString*)orderStr
  viewController:(UIViewController *)controller;

+ (void)payCallBack:(NSURL *)url;

@end
