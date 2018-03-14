//
//  NSUserDefaults+YCAddition.m
//  Portal
//
//  Created by 左梓豪 on 2016/12/7.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "NSUserDefaults+YCAddition.h"

@implementation NSUserDefaults (YCAddition)

+ (void)SetSearchhistoryData:(NSMutableArray*)historydata {
    [[NSUserDefaults standardUserDefaults]setObject:historydata forKey:@"historydata"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSMutableArray *)GetSearchhistoryData {
    NSMutableArray *historydata = [[NSUserDefaults standardUserDefaults] objectForKey:@"historydata"];
    NSMutableArray *data = @[].mutableCopy;
    for (NSString *str in historydata) {
        [data addObject:str];
    }
    return data;
}


@end
