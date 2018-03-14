//
//  movieData.h
//  Portal
//
//  Created by 左梓豪 on 2016/12/5.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieData : NSObject

@property(nonatomic, copy) NSString *ver;
@property(nonatomic, copy) NSString *imgUrl;
@property(nonatomic, copy) NSString *url;
@property(nonatomic, strong) NSNumber *uniqueId;

@end
