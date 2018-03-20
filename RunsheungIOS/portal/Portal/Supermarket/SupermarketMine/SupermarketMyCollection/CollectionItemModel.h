//
//  CollectionItemModel.h
//  Portal
//
//  Created by 이정구 on 2018/3/20.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionItemModel : NSObject

@property (nonatomic, copy) NSString *shopImage;
@property (nonatomic, copy) NSString *customCode;
@property (nonatomic, copy) NSString *customName;
@property (nonatomic, copy) NSString *koraddr;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *cnt;
@property (nonatomic, copy) NSString *salCustomCnt;

-(instancetype)initWithDic:(NSDictionary*)dic;

@end
