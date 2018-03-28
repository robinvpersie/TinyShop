//
//  ECU.h
//  Portal
//
//  Created by 이정구 on 2018/3/27.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECU : NSObject

@property (nonatomic, copy) void(^success)(NSMutableArray * array);

-(void)requestAreaWithQuery:(NSString *)query offset:(NSInteger)offset;

@end
