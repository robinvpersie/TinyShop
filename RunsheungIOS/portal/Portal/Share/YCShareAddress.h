//
//  YCShareAddress.h
//  Portal
//
//  Created by ifox on 2017/2/21.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YCShareModel;

@interface YCShareAddress : NSObject

+ (NSString *)getShareAddressWithShareModel:(YCShareModel *)model;

+ (NSString *)sha512:(NSString *)input;


+(void)shareWithString:(NSString *)shareString;

@end

