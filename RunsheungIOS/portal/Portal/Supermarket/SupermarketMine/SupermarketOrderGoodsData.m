//
//  SupermarketOrderGoodsData.m
//  Portal
//
//  Created by ifox on 2017/1/6.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "SupermarketOrderGoodsData.h"

@implementation SupermarketOrderGoodsData

- (RefundStatus)refundStatus {
    if (_refundStatus >= 0 && _refundStatus <= 6) {
        return _refundStatus;
    }
    return  -1;
}

@end
