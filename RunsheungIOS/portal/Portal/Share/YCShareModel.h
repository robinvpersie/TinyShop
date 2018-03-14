//
//  YCShareModel.h
//  Portal
//
//  Created by ifox on 2017/2/21.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface YCShareModel : NSObject

/**
 main , wallet , share     分别为跳转主页,跳转钱包,跳转分享
 */
@property(nonatomic, copy) NSString *action_type;
/**
 手机号
 */
@property(nonatomic, copy) NSString *phone_number;
/**
 密码
 */
@property(nonatomic, copy) NSString *password;

/**
 分享标题
 */
@property(nonatomic, copy) NSString *title;

/**
 分享内容
 */
@property(nonatomic, copy) NSString *content;

/**
 图片地址
 */
@property(nonatomic, copy) NSString *imageUrl;

/**
 链接
 */
//@property(nonatomic, copy) NSString *url;

/**
 分享类型
 按potal八大功能 分别为0 1 2 3 4 5 6 7 8    8为potal首页
 */
@property(nonatomic, copy) NSString *type;
/**
 分享的商品或视频的id   当item_code为空时,默认item_code
 */
@property(nonatomic, copy) NSString *item_code;
/**
 用户token
 */
@property(nonatomic, copy) NSString *token;

/**
 链接url,主要用于新闻
 */
@property(nonatomic, copy) NSString *url;

@end
