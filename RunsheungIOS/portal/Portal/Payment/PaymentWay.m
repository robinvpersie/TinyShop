//
//  PaymentWay.m
//  Portal
//
//  Created by ifox on 2017/4/6.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "PaymentWay.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UPPaymentControl.h"

@implementation PaymentWay
//+ (void)wechatpay:(NSDictionary*)orderDic
//  viewController:(UIViewController *)controller{
//    if ([orderDic isKindOfClass:[NSDictionary class]]) {
//        if (orderDic != nil )
//        {
//            //调起支付
//            NSString *appids = orderDic[@"appid"];
//            [WXApi registerApp:appids withDescription:@"人生药业商品"];
//            RSPayRep *req = [[RSPayRep alloc]init];
//            req.partnerId = orderDic[@"partnerid"];
//            req.prepayId = orderDic[@"prepayid"];
//            req.package = orderDic[@"package"];
//            req.nonceStr = orderDic[@"noncestr"];
//            req.timeStamp = [orderDic[@"timestamp"] intValue];
//            req.sign = orderDic[@"sign"];
//            [WXApi sendReq:req];
//        }
//    }
//   
//}

+ (void)alipay:(NSString *)orderStr{
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"slapp";
    
    [[AlipaySDK defaultService] payOrder:orderStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        
    }];
}

+ (void)unionpay:(NSString*)orderStr
  viewController:(UIViewController *)controller{
    if ([orderStr isKindOfClass:[NSString class]]) {
        if (orderStr != nil && orderStr.length > 0)
        {
            
            NSInteger isOk = [[UPPaymentControl defaultControl] startPay:orderStr fromScheme:@"slapp" mode:@"00" viewController:controller];
            NSLog(@"%ld",isOk);
        }
    }
   
}


+ (void)payCallBack:(NSURL *)url{
    NSString *canshu = url.absoluteString;
    // 银联支付回调
    if ([canshu containsString:@"uppayresult"]) {
        
        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
            //结果code为成功时，先校验签名，校验成功后做后续处理
            if([code isEqualToString:@"success"]) {
                
                //判断签名数据是否存在
                if(data == nil){
                    //如果没有签名数据，建议商户app后台查询交易结果
                    return;
                }
                 [[NSNotificationCenter defaultCenter] postNotificationName:UnionPaySuccessNotification object:nil];
                //数据从NSDictionary转换为NSString
                NSData *signData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
                NSString *sign = [[NSString alloc] initWithData:signData encoding:NSUTF8StringEncoding];
                if([self verify:sign]) {//支付成功且验签成功，展示支付成功提示
                   
                    
                }else { //验签失败，交易结果数据被篡改，商户app后台查询交易结果
                    
                }
            }else if([code isEqualToString:@"fail"]) {//交易失败
                NSLog(@"交易失败");
            }else if([code isEqualToString:@"cancel"]) { //交易取消
                NSLog(@"交易取消");
                [[NSNotificationCenter defaultCenter] postNotificationName:UnionPayCancelNotification object:nil];
            }
        }];
    }
    
    // 支付宝支付回调
    
    if ([canshu containsString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSString *result = resultDic[@"result"];
            if (result.length == 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:AliPayCancleNotification object:nil];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:AliPaySuccessNotification object:nil];
            }
        }];
    }
}

+ (BOOL)verify:(NSString *) resultStr {
    
    //验签证书同后台验签证书
    return NO;
}


@end
