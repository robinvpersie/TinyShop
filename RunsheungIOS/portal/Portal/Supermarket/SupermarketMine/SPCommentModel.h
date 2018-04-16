//
//  SPCommentModel.h
//  Portal
//
//  Created by 이정구 on 2018/3/23.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPCommentModel : NSObject

@property (nonatomic, copy)NSString *imageUrl;
@property (nonatomic, copy)NSString *commentTime;
@property (nonatomic, copy)NSString *itemcode;
@property (nonatomic, copy)NSString *itemname;
@property (nonatomic, copy)NSString *nickname;
@property (nonatomic, assign)long level;
@property (nonatomic, copy)NSString *haslikes;
@property (nonatomic, copy)NSString *text;
@property (nonatomic, copy)NSString *commentid;
@property (nonatomic, copy)NSString *hasimgs;
@property (nonatomic, assign)long likescount;
@property (nonatomic, copy)NSString *headUrl;
@property (nonatomic, assign)long score;

-(instancetype)initWithDic:(NSDictionary*)dic;

@end
