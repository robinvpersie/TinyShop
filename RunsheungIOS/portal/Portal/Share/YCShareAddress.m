//
//  YCShareAddress.m
//  Portal
//
//  Created by ifox on 2017/2/21.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "YCShareAddress.h"
#import "YCShareModel.h"
#include <CommonCrypto/CommonDigest.h>

@implementation YCShareAddress

+ (NSString *)getShareAddressWithShareModel:(YCShareModel *)model {
    NSString *address = [NSString stringWithFormat:@"ycapp://%@$%@$%@$%@$%@$%@$%@$%@$%@$%@",model.action_type,model.phone_number,model.password,model.title,model.content,model.imageUrl,model.type,model.item_code,model.token,model.url];
    return address;
}

+(NSString*)sha512:(NSString*)input {
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(data.bytes, (CC_LONG)data.length, digest);

    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];

    return output;

}


+(void)shareWithString:(NSString *)shareString{
    NSString *shareUrl =shareString;
    shareUrl = [shareString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:shareUrl]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:shareUrl]];
    }else{
        [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:@"龙聊暂未安装"];
    }
}

@end
