//
//  KLRequestManager.h
//  Portal
//
//  Created by 左梓豪 on 2016/12/5.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>

#define baseRYURL @"http://im.hsw188.com:8081/appserver/index.php/"
#define RSLonginBaseURL @"http://member.gigawon.co.kr:8800/api/Login/"//登录注册基本url
typedef NS_ENUM(NSInteger, KLRequestMethodType) {
    KLRequestMethodTypePost = 1,
    KLRequestMethodTypeGet = 2
};

@interface KLRequestManager : NSObject

+ (KLRequestManager *)shareManager;

- (void)RYRequestWihtMethod:(KLRequestMethodType)methodType
                        url:(NSString *)url
                     params:(NSDictionary *)params
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError *err))failure;


- (void)RYRequestWihtMethod2:(KLRequestMethodType)methodType
                         url:(NSString *)url
                      params:(NSDictionary *)params
                     success:(void (^)(id response))success
                     failure:(void (^)(NSError *err))failure;



@end
