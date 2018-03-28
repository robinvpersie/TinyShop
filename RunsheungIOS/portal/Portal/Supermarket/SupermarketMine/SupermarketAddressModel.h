//
//  SupermarketAddressModel.h
//  Portal
//
//  Created by 左梓豪 on 2016/12/13.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupermarketAddressModel : NSObject

@property(nonatomic, copy)    NSString *address;
@property(nonatomic, copy)    NSString *area;
@property(nonatomic, copy)    NSString *city;
@property(nonatomic, copy)    NSString *deleted;
@property(nonatomic, copy)    NSNumber *isdefault; //1为默认
@property(nonatomic, copy)    NSString *ID;
@property(nonatomic, copy)    NSString *mobile;
@property(nonatomic, copy)    NSString *openid;
@property(nonatomic, copy)    NSString *province;
@property(nonatomic, copy)    NSString *realname;
@property(nonatomic, copy)    NSString *uniacid;
@property(nonatomic, copy)    NSString *zipcode;//邮政编码
@property(nonatomic, strong)  NSNumber *addressID;
@property(nonatomic, strong)  NSNumber *latitude;
@property(nonatomic, strong)  NSNumber *longtitude;
@property(nonatomic, copy)    NSString *location;//大位置

@property(nonatomic, copy)    NSString *default_add;
@property(nonatomic, copy)    NSString *delivery_name;
@property(nonatomic, copy)    NSString *mobilepho;
@property(nonatomic, copy)    NSString *seq_num;
@property(nonatomic, copy)    NSString *to_address;
@property(nonatomic, copy)    NSString *zip_name;

@property(nonatomic, copy) NSNumber *hasDelivery;//检测地址是否可以派送

@end
