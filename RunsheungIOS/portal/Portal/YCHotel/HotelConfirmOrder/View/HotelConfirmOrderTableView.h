//
//  HotelConfirmOrderTableView.h
//  Portal
//
//  Created by ifox on 2017/4/11.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingTableView.h"

@interface HotelConfirmOrderTableView : TPKeyboardAvoidingTableView

@property(nonatomic, assign, readonly) NSInteger roomNumbers;//预定房间数量
@property(nonatomic, copy, readonly) NSString *arriveTime;//预计到店
@property(nonatomic, copy, readonly) NSString *retainTimeKey;//预计到店key
@property(nonatomic, strong) NSArray *customerPhones;//客户号码数组
@property(nonatomic, strong) NSArray *customerNames;//客户姓名

@property(nonatomic, assign) BOOL usePoint;

@property(nonatomic, copy) NSString *hotelName;
@property(nonatomic, copy) NSString *roomTypeName;
@property(nonatomic, copy) NSString *days;//入住天数
@property(nonatomic, copy) NSString *arrivedate;//入住日期
@property(nonatomic, copy) NSString *leavedate;//离店日期

@property(nonatomic, strong) NSArray *retainTimeArray;//到店时间

@end
