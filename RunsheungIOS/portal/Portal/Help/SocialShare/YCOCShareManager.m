//
//  YCOCShareManager.m
//  Portal
//
//  Created by PENG LIN on 2017/9/29.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "YCOCShareManager.h"
#import <UMSocialCore/UMSocialCore.h>

@implementation YCOCShareManager

+(YCOCShareManager *)share{
    static YCOCShareManager * share = nil;
    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken, ^{
        share = [[self alloc]init];
    });
    return share;
}

-(void)configure{
    
    [[UMSocialManager defaultManager] openLog:YES];
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"59ae3e687f2c74461a001a71"];
    [[UMSocialManager defaultManager]setPlaform:UMSocialPlatformType_QQ appKey:@"1105955455" appSecret:@"sh0sSUOnMosPpbhZ" redirectURL:nil];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx8ab5a1f852d8663c" appSecret:@"b57c0626ccab1ef315b4ad7225e08da3" redirectURL:nil];
    

    
//    UMSocialManager.default().openLog(true)
//    UMSocialManager.default().umSocialAppkey = "59ae3e687f2c74461a001a71"
//    UMSocialManager.default().setPlaform(.QQ, appKey: "1105955455", appSecret:"sh0sSUOnMosPpbhZ", redirectURL: nil)
//    UMSocialManager.default().setPlaform(.sina, appKey:"", appSecret: "", redirectURL: nil)
//    UMSocialManager.default().setPlaform(.wechatSession, appKey: "wx8ab5a1f852d8663c", appSecret: "b57c0626ccab1ef315b4ad7225e08da3", redirectURL: nil)
//    UMSocialManager.default().setPlaform(.wechatTimeLine, appKey: "wx8ab5a1f852d8663c", appSecret: "b57c0626ccab1ef315b4ad7225e08da3", redirectURL: nil)

}

@end
