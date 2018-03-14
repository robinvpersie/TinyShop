//
//  RefundDetailModel.h
//  Portal
//
//  Created by ifox on 2017/3/18.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RefundOperateType) {
    RefundOperateTypeSeller = 1,
    RefundOperateTypeBuyer,
    RefundOperateTypeSystem,
};

@interface RefundDetailModel : NSObject

@property(nonatomic, copy) NSString *content;
@property(nonatomic, strong) NSNumber *finished;
@property(nonatomic, copy) NSString *time;
@property(nonatomic, assign) CGFloat contentHeight;
@property(nonatomic, strong) NSNumber *status;
@property(nonatomic, copy) NSString *stepStatus;
@property(nonatomic, assign) RefundOperateType operateType;

@end
