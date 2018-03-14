//
//  HotelHomeListModel.h
//  Portal
//
//  Created by ifox on 2017/4/10.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotelHomeListModel : NSObject

@property(nonatomic, copy) NSString *photoUrl;
@property(nonatomic, copy) NSString *hotleName;
@property(nonatomic, copy) NSString *district;
@property(nonatomic, copy) NSString *hotelLev;
@property(nonatomic, strong) NSNumber *noMemeberPrice;
@property(nonatomic, copy) NSString *hotelInfoID;
@property(nonatomic, assign) float score;
@property(nonatomic, assign) NSInteger rateCount;

@end
