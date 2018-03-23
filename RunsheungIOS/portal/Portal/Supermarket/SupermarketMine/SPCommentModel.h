//
//  SPCommentModel.h
//  Portal
//
//  Created by 이정구 on 2018/3/23.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPCommentModel : NSObject

@property (nonatomic, copy)NSString *imagePath;
@property (nonatomic, copy)NSString *nickname;
@property (nonatomic, copy)NSString *customname;
@property (nonatomic, copy)NSString *score;
@property (nonatomic, copy)NSString *identifier;
@property (nonatomic, copy)NSString *customCode;
@property (nonatomic, copy)NSString *repContent;
@property (nonatomic, copy)NSString *saleContent;
@property (nonatomic, copy)NSString *regdate;
@property (nonatomic, copy)NSString *num;
@property (nonatomic, copy)NSString *rnm;

-(instancetype)initWithDic:(NSDictionary*)dic;

@end
