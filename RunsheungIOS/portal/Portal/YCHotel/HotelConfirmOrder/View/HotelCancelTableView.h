//
//  HotelCancelTableView.h
//  Portal
//
//  Created by ifox on 2017/4/15.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingTableView.h"
#import "HotelOrderDetailModel.h"

@interface HotelCancelTableView : TPKeyboardAvoidingTableView

@property(nonatomic, strong) HotelOrderDetailModel *orderDetail;
@property(nonatomic, copy) NSString *detail;
@property(nonatomic, copy) NSString *refundMoney;

@end
