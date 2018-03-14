//
//  YCPayRep.h
//  YCIM
//
//  Created by cherish on 2017/1/16.
//  Copyright © 2017年 YCIM. All rights reserved.
//

#import "WXApiObject.h"

@interface YCPayRep : PayReq

/***** 额外的消息*****/
@property(nonatomic,retain)NSString *extData;
@end
