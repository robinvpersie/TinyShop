//
//  SupermarketPassword.h
//  Portal
//
//  Created by ifox on 2017/1/23.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupermarketPassword : NSObject

@property (nonatomic, readonly) NSString *md5;
@property (nonatomic, readonly) NSString *sha1;
@property (nonatomic, readonly) NSString *sha224;
@property (nonatomic, readonly) NSString *sha256;
@property (nonatomic, readonly) NSString *sha384;
@property (nonatomic, readonly) NSString *sha512;

@end
