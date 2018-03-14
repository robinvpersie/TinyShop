//
//  NSObject+TransfromModel.h
//  Portal
//
//  Created by PENG LIN on 2017/1/20.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (TransfromModel)

- (NSDictionary *)dictionaryFromModel;

/**
 *  带model的数组或字典转字典
 *
 *  @param object 带model的数组或字典转
 *
 *  @return 字典
 */
- (id)idFromObject:(nonnull id)object;

@end
