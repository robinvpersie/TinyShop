//
//  YCShareAddress.m
//  Portal
//
//  Created by ifox on 2017/2/21.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "YCShareAddress.h"
#import "YCShareModel.h"

@implementation YCShareAddress

+ (NSString *)getShareAddressWithShareModel:(YCShareModel *)model {
    NSString *address = [NSString stringWithFormat:@"ycapp://%@$%@$%@$%@$%@$%@$%@$%@$%@$%@",model.action_type,model.phone_number,model.password,model.title,model.content,model.imageUrl,model.url,model.type,model.item_code,model.token];
    return address;
}

+(void)shareWithString:(NSString *)shareString{
    NSString *shareUrl =shareString;
    shareUrl = [shareString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:shareUrl]]) {
          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:shareUrl]];
    }else{
        [MBProgressHUD hideAfterDelayWithView:KEYWINDOW interval:2 text:@"跳转的应用未安装"];
    }


}

@end
