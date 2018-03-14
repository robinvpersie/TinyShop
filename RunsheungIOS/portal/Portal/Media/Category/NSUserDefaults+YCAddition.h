//
//  NSUserDefaults+YCAddition.h
//  Portal
//
//  Created by 左梓豪 on 2016/12/7.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (YCAddition)

+ (void)SetSearchhistoryData:(NSMutableArray*)historydata;
+ (NSMutableArray *)GetSearchhistoryData;

@end
