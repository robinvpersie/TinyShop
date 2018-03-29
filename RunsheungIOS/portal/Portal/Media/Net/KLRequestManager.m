//
//  KLRequestManager.m
//  Portal
//
//  Created by 左梓豪 on 2016/12/5.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "KLRequestManager.h"

@implementation KLRequestManager

+ (KLRequestManager *)shareManager
{
    static KLRequestManager *resquestManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        resquestManager = [[self alloc] init];
    });
    return resquestManager;
}


//创建一个公共的方法
- (void)RYRequestWihtMethod:(KLRequestMethodType)methodType
                        url:(NSString *)url
                     params:(NSDictionary *)params
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError *err))failure {
    
    //获得请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 60;
    
    url = [NSString stringWithFormat:@"%@%@",baseRYURL,url];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"url:%@",url);
    switch (methodType) {
        case KLRequestMethodTypeGet: {// GET请求
            [manager GET:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    
                    NSString *result = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
                    NSError *error = nil;
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData: [result dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: &error];
                    success(dic);
                    
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    
                    failure(error);
                }
            }];
            
        } break;
            
        case KLRequestMethodTypePost: {// POST请求
            [manager POST:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                
                if (success) {
                    NSString *result = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
                    NSError *error = nil;
                    
                    
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData: [result dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: &error];
                    success(dic);
                    
                    
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                if (failure) {
                    failure(error);
                }
                
            }];
        } break;
        default:
            break;
    }
}

//创建一个公共的方法
- (void)RYRequestWihtMethod2:(KLRequestMethodType)methodType
                         url:(NSString *)url
                      params:(NSDictionary *)params
                     success:(void (^)(id response))success
                     failure:(void (^)(NSError *err))failure {
    
    //获得请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 60;

    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    switch (methodType) {
        case KLRequestMethodTypeGet: {// GET请求
            [manager GET:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    [MBProgressHUD hideHUDForView:KEYWINDOW animated:NO];
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                   failure(error);
                }
            }];

        } break;

        case KLRequestMethodTypePost: {// POST请求
            [manager POST:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    [MBProgressHUD hideHUDForView:KEYWINDOW animated:NO];
                    success(responseObject);
                }
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }

            }];
        } break;
        default:
            break;
    }
}


@end
