//
//  HotelCreateSuccessOrderModel.h
//  Portal
//
//  Created by ifox on 2017/4/18.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 酒店提交订单成功后返回数据
 */
@interface HotelCreateSuccessOrderModel : NSObject

@property(nonatomic, copy) NSString *arriveTime;
@property(nonatomic, copy) NSString *GuaranteeMode;
@property(nonatomic, copy) NSString *HotelInfoID;
@property(nonatomic, copy) NSString *leaveTime;
//@property(nonatomic, )

@end
