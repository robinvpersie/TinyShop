//
//  KLBannerData.h
//  Portal
//
//  Created by 左梓豪 on 2016/12/5.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLBannerData : NSObject

@property(nonatomic, copy) NSString *ver;//图片版本
@property(nonatomic, copy) NSString *imgUrl;//图片地址
@property(nonatomic, copy) NSString *url;//点击跳转地址
@property(nonatomic, strong) NSNumber *contentID;

@end
