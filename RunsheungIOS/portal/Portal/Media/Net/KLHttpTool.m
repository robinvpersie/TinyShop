//
//  KLHttpTool.m
//  Portal
//
//  Created by 左梓豪 on 2016/12/5.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "KLHttpTool.h"
#import "YCShareAddress.h"

//#define BaseUrl  @"http://192.168.2.230:81/"
//#define ShopBaseUrl @"http://192.168.2.179:96/"
//#define PaymentBaseURL @"http://192.168.2.230:8088/"
//#define PaymentUrl @"http://192.168.2.201/wPayment/api/wPayment"
//#define PointListUrl @"http://192.168.2.201/pl_Point/api/PointGetListAndBalance"

//#define BaseUrl  @"http://pay.dxbhtm.com:81/"
//#define PaymentBaseURL @"http://pay.dxbhtm.com:8088/"
//#define ShopBaseUrl @"http://api1.dxbhtm.com:96/"
//#define PaymentUrl @"https://api.dxbhtm.com/wPayment/api/wPayment"
//#define PointListUrl @"https://api.dxbhtm.com/pl_Point/api/PointGetListAndBalance"

#if !DEBUG // 判断是否在测试环境下
    #define BaseUrl  @"http://192.168.2.230:81/"
    #define ShopBaseUrl @"http://192.168.2.179:96/"
    #define PaymentBaseURL @"http://192.168.2.230:8088/"
    #define PaymentUrl @"http://192.168.2.201/wPayment/api/wPayment"
    #define PointListUrl @"http://192.168.2.201/pl_Point/api/PointGetListAndBalance"
    #define CheckTokenUrl @"http://192.168.2.201/appapi/userapi"
    #define GetZipcodeUrl @"http://192.168.2.179:82/api/ycZipCode/getZipCode"
    #define GetTokenUrl @"http://192.168.2.165:89/ws2016/srvJoinModule/10_Login/checkLogin_0911"
#else

    #define BaseUrl  @"http://pay.dxbhtm.com:81/"
    #define PaymentBaseURL @"http://pay.dxbhtm.com:8088/"
    #define ShopBaseUrl @"http://api1.dxbhtm.com:96/"
    #define PaymentUrl @"https://api.dxbhtm.com:8444/wPayment/api/wPayment"
    #define PointListUrl @"https://api.dxbhtm.com:8444/pl_Point/api/PointGetListAndBalance"
    #define CheckTokenUrl @"https://api.dxbhtm.com:8444/appapi/userapi"
    #define GetZipcodeUrl @"http://api1.dxbhtm.com:82/api/ycZipCode/getZipCode"
    #define GetTokenUrl @"http://member.dxbhtm.com:89/ws2016/srvJoinModule/10_Login/checkLogin_0911"
#endif


@implementation KLHttpTool

+ (void)checkAddressZipcodeWithProviceName:(NSString *)proviceName
                                  cityName:(NSString *)cityName
                                   success:(void (^)(id response))success
                                   failure:(void (^)(NSError *err))failure{
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setObject:proviceName forKey:@"zip_name1"];
    [dic setObject:cityName forKey:@"zip_name2"];
//    YCAccountModel *model = [YCAccountModel getAccount];
//    if (model.token) {
//        [dic setObject:model.token forKey:@"token"];
//    }
    [self getToken:^(id token) {
        [dic setObject:token forKey:@"token"];
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:GetZipcodeUrl params:dic success:^(id response) {
            if (success) {
                success(response);
            }
        } failure:^(NSError *err) {
            
        }];

    }failure:^(NSError *errToken) {
        failure(errToken);
    }];
}

+ (void)checkTokenWithToken:(NSString *)token
                   userName:(NSString *)userName
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError *err))failure{
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setObject:@"checktoken" forKey:@"action"];
    [dic setObject:userName forKey:@"username"];
    [dic setObject:token forKey:@"token"];
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:CheckTokenUrl params:dic success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *err) {
        
    }];
}


/**
 获取token

 @param success 返回token
 */
+ (void)getToken:(void (^)(id token))success
         failure:(void (^)(NSError *errToken))failureToken {
     NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setObject:UUID forKey:@"deviceNo"];
    NSString *sign = [NSString stringWithFormat:@"%@ycssologin1212121212121",UUID];
    NSString* encrySign = [YCShareAddress sha512:sign];
    [dic setObject:encrySign forKey:@"sign"];
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypeGet url:GetTokenUrl params:dic success:^(id response) {
        if (success) {
            NSNumber *status = response[@"status"];
            if (status.integerValue == 1) {
                NSString *finalToken = [self formatTokenWithResponse:response];
                success(finalToken);
            } else {
//                failureToken(response);
                 [[NSNotificationCenter defaultCenter]postNotificationName:TokenWrong object:nil];
            //没有token或者token失效 应该跳出登录界面
            }
        }
    } failure:^(NSError *err) {
        failureToken(err);
    }];
    
}

+ (NSString *)formatTokenWithResponse:(id)response {
    NSDictionary *dic = response;
    NSString *token = dic[@"token"];
    NSString *ssoid = dic[@"ssoId"];
    NSString *customCode = dic[@"custom_code"];
    NSString *deviceNo = dic[@"deviceNo"];
    
    NSString *finalToken = [NSString stringWithFormat:@"%@|%@|%@|%@",token,ssoid,customCode,deviceNo];
    
    return finalToken;
}


+ (void)checkStatusWithResponse:(id)response {
    NSNumber *status = response[@"status"];
    if (status.integerValue == -9001) {
        [[NSNotificationCenter defaultCenter]postNotificationName:TokenWrong object:nil];
        
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        
        [MBProgressHUD hideAfterDelayWithView:keyWindow interval:4 text:response[@"message"]];
    }
}

+ (void)getHomePageDataWithUrl:(NSString *)url
                       success:(void (^)(id response))success
                       failure:(void (^)(NSError *err))failure {
    url = @"http://222.240.51.144:81/api/KLHome";

    NSMutableDictionary *params = @{}.mutableCopy;
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypeGet url:url params:nil success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *err) {
        
    }];
}

+ (void)getSupermarketHomaDataWithUrl:(NSString *)url
                              divCode:(NSString *)divCode
                              success:(void (^)(id response))success
                              failure:(void (^)(NSError *err))failure {
    url = @"FreshMart/Main/GetMainQuery";
    url = [NSString stringWithFormat:@"%@%@",BaseUrl,url];

    NSMutableDictionary *params = @{}.mutableCopy;
//    YCAccountModel *model = [YCAccountModel getAccount];
//
    [params setObject:divCode forKey:@"div_code"];
    
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
            if (success) {
                success(response);
            }
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
            failure(err);
        }];
    
}

//获取商品评价列表
+ (void)getSupermarketGoodsCommentWithUrl:(NSString *)url
                                 itemCode:(NSString *)itemCode
                                pageIndex:(NSInteger)pageIndex
                                 pageSize:(NSInteger)pageSize
                            commentStatus:(NSInteger)commentStatus
                                 hasImage:(BOOL)hasImage
                                  divCode:(NSString *)divCode
                                  success:(void (^)(id response))success
                                  failure:(void (^)(NSError *err))failure {
    url = @"FreshMart/User/GetGoodsOfComment";
    url = [NSString stringWithFormat:@"%@%@",BaseUrl,url];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:itemCode forKey:@"itemCode"];
    [params setObject:@(pageIndex) forKey:@"pageIndex"];
    [params setObject:@(pageSize) forKey:@"pageSize"];
    [params setObject:@(commentStatus) forKey:@"commnetStatus"];
    
    YCAccountModel *model = [YCAccountModel getAccount];
    if (model.memid) {
        [params setObject:model.memid forKey:@"userId"];
    } else {
        [params setObject:@"" forKey:@"userId"];
    }
    
    if (hasImage) {
        [params setObject:@"true" forKey:@"has_imgs"];
    } else {
        [params setObject:@"false" forKey:@"has_imgs"];
    }
    [params setObject:divCode forKey:@"div_code"];
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
    }];
 
}

//给评论点赞
+ (void)sendLikeToSupermarketGoodsCommentsWithCommentsID:(NSString *)commentsID
                                                 success:(void (^)(id response))success
                                                 failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@FreshMart/User/SendLikes",BaseUrl];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:commentsID forKey:@"commentId"];
    
//    YCAccountModel *model = [YCAccountModel getAccount];
//    if (model.token) {
//        [params setObject:model.token forKey:@"token"];
//    }
    [self getToken:^(id token) {
        [params setObject:token forKey:@"token"];
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
            if (success) {
                [self checkStatusWithResponse:response];
                success(response);
            }
            
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
        }];
    } failure:^(NSError *errToken) {
        failure(errToken);
    }];
}


/**
 商品详情

 @param itemCode 商品详情
 @param shopCode 商户编号
 @param salerCode 卖家编号
 @param success success description
 @param failure failure description
 */
+ (void)getSupermarketGoodsMsgWithItemCode:(NSString *)itemCode
                                  shopCode:(NSString *)shopCode
                                 salerCode:(NSString *)salerCode
                              success:(void (^)(id response))success
                              failure:(void (^)(NSError *err))failure {
    NSString  *url = @"FreshMart/Goods/GetGoodsOfDetails";
    url = [NSString stringWithFormat:@"%@%@",BaseUrl,url];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:itemCode forKey:@"item_code"];
    [params setObject:shopCode forKey:@"div_code"];
    [params setObject:salerCode forKey:@"custom_code"];
    
    YCAccountModel *model = [YCAccountModel getAccount];
    
    if (model.customCode) {
        [params setObject:model.customCode forKey:@"userId"];
    } else {
        [params setObject:@"" forKey:@"userId"];
    }
    
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
            if (success) {
                success(response);
            }
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
        }];
}

+(void)getSupermarketUserAddressListWithDivCode:(NSString *)divCode
                                        success:(void (^)(id response))success
                                        failure:(void (^)(NSError *err))failure {
    NSMutableDictionary *params = @{}.mutableCopy;
    YCAccountModel *model = [YCAccountModel getAccount];
//    if (model.token) {
//        [params setObject:model.token forKey:@"token"];
//    }
    
    [self getToken:^(id token) {
        [params setObject:token forKey:@"token"];
        [params setObject:divCode forKey:@"div_code"];
        NSString *url = [NSString stringWithFormat:@"%@FreshMart/User/GetUserShopAddressOfList",BaseUrl];
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
            if (success) {
                [self checkStatusWithResponse:response];
                success(response);
            }
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
        }];
    } failure:^(NSError *errToken) {
        
    }];
}

+ (void)supermarketAddNewAddressWithName:(NSString *)name
                                location:(NSString *)location
                                 address:(NSString *)address
                                  mobile:(NSString *)mobile
                              longtitude:(NSString *)longtitude
                                latitude:(NSString *)latitude
                                 zipCode:(NSString *)zipCode
                               isDefault:(BOOL)isDefault
                                 success:(void (^)(id response))success
                                 failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@FreshMart/User/AddUserShopAddress",BaseUrl];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:name forKey:@"deliver_id"];
    [params setObject:location forKey:@"deliver_name"];
    [params setObject:address forKey:@"to_address"];
    [params setObject:mobile forKey:@"mobile"];
    [params setObject:latitude forKey:@"latitude"];
    [params setObject:longtitude forKey:@"longitude"];
    [params setObject:zipCode forKey:@"zip_code"];
    YCAccountModel *model = [YCAccountModel getAccount];
//    if (model.token) {
//        [params setObject:model.token forKey:@"token"];
//    }
    if (isDefault) {
        [params setObject:@"true" forKey:@"default_add"];
    } else {
        [params setObject:@"false" forKey:@"default_add"];
    }
    
    [self getToken:^(id token) {
        [params setObject:token forKey:@"token"];
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
            if (success) {
                success(response);
            }
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
        }];
    } failure:^(NSError *errToken) {
        
    }];
}

//编辑收货地址
+ (void)supermarketEditAddressWithName:(NSString *)name
                              location:(NSString *)location
                               address:(NSString *)address
                                mobile:(NSString *)mobile
                            longtitude:(NSString *)longtitude
                              latitude:(NSString *)latitude
                             addressID:(NSString *)addressID
                               zipCode:(NSString *)zipCode
                             isDefault:(BOOL)isDefault
                               success:(void (^)(id response))success
                               failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@FreshMart/User/UpdateUserShopAddress",BaseUrl];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:name forKey:@"deliver_id"];
    [params setObject:location forKey:@"deliver_name"];
    [params setObject:address forKey:@"to_address"];
    [params setObject:mobile forKey:@"mobile"];
    [params setObject:latitude forKey:@"latitude"];
    [params setObject:longtitude forKey:@"longitude"];
    [params setObject:addressID forKey:@"id"];
    [params setObject:zipCode forKey:@"zip_code"];
    YCAccountModel *model = [YCAccountModel getAccount];
//    if (model.token) {
//        [params setObject:model.token forKey:@"token"];
//    }
    
    if (isDefault) {
        [params setObject:@"true" forKey:@"default_add"];
    } else {
        [params setObject:@"false" forKey:@"default_add"];
    }

    [self getToken:^(id token) {
        [params setObject:token forKey:@"token"];
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
            if (success) {
                success(response);
            }
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
        }];
    } failure:^(NSError *errToken) {
        
    }];
}

+ (void)setSupermarketDefaultAddressWithAddressID:(NSString *)addressID
                                          success:(void (^)(id response))success
                                          failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@FreshMart/User/SetDefaultShopAddress",BaseUrl];
     NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:addressID forKey:@"id"];
    YCAccountModel *model = [YCAccountModel getAccount];
//    if (model.token) {
//        [params setObject:model.token forKey:@"token"];
//    }
    
    [self getToken:^(id token) {
        [params setObject:token forKey:@"token"];
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
            if (success) {
                success(response);
            }
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
        }];

    } failure:^(NSError *errToken) {
        
    }];
}

//删除地址
+ (void)deleteSupermarketAddressWithAddressID:(NSString *)addressID
                                      success:(void (^)(id response))success
                                      failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@FreshMart/User/DelUserShopAddress",BaseUrl];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:addressID forKey:@"id"];
    YCAccountModel *model = [YCAccountModel getAccount];
//    if (model.token) {
//        [params setObject:model.token forKey:@"token"];
//    }
    
    [self getToken:^(id token) {
        [params setObject:token forKey:@"token"];
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
            if (success) {
                success(response);
            }
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
        }];
    } failure:^(NSError *errToken) {
        
    }];
}

+ (void)addGoodsToShoppingCartWithGoodsID:(NSString *)goodsID
                                   shopID:(NSString *)shopID
                                  applyID:(NSString *)applyID
                                  numbers:(NSInteger)goodsNumber
                                  success:(void (^)(id response))success
                                  failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@FreshMart/User/AddUserShopCart",BaseUrl];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:[NSNumber numberWithInteger:goodsNumber] forKey:@"item_quantity"];
    [params setObject:goodsID forKey:@"item_code"];
    [params setObject:shopID forKey:@"div_code"];
    [params setObject:applyID forKey:@"custom_code"];
    YCAccountModel *model = [YCAccountModel getAccount];
    
    [self getToken:^(id token) {
        [params setObject:token forKey:@"token"];
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
            [self checkStatusWithResponse:response];
            if (success) {
                success(response);
            }
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
        }];
    } failure:^(NSError *errToken) {
        
    }];
}

//获取自提站点
+ (void)getSelfPickAddressListsuccess:(void (^)(id response))success
                              failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@FreshMart/Common/GetPickUpSiteList",BaseUrl];
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:nil success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
    }];
}

//增加到我的收藏
+ (void)addGoodsToMyCollection:(NSString *)goodID
                       divCode:(NSString *)divCode
                       success:(void (^)(id response))success
                       failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@FreshMart/User/AddUserFavorites",BaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:goodID forKey:@"item_code"];
    [params setObject:divCode forKey:@"div_code"];

    [self getToken:^(id token) {
        [params setObject:token forKey:@"token"];
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
            if (success) {
                [self checkStatusWithResponse:response];
                success(response);
            }
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
        }];

    } failure:^(NSError *errToken) {
        
    }];
}

//从我的收藏删除
+ (void)deleteCollectionGoods:(NSArray *)goodsArray
                      success:(void (^)(id response))success
                      failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@FreshMart/User/DelUserFavorites",BaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    NSMutableArray *goods = @[].mutableCopy;
    
    for (NSDictionary *dic in goodsArray) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        NSString *jsonString = @"";
        
        if (! jsonData)
        {
            NSLog(@"Got an error: %@", error);
        }else
        {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        
        jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
        
        //        [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        [goods addObject:jsonString];
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:goodsArray options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [params setObject:jsonString forKey:@"jsonString"];

    
    YCAccountModel *model = [YCAccountModel getAccount];
//    if (model.token) {
//        [params setObject:model.token forKey:@"token"];
//    }
    
    [self getToken:^(id token) {
        [params setObject:token forKey:@"token"];
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
            if (success) {
                success(response);
            }
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
        }];

    } failure:^(NSError *errToken) {
        
    }];
}

+ (void)getMyCollectionListWithAppType:(NSInteger)appType
                               success:(void (^)(id response))success
                           failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@FreshMart/User/GetUserFavoritesOfList",BaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    
    YCAccountModel *model = [YCAccountModel getAccount];
//    if (model.token) {
//        [params setObject:model.token forKey:@"token"];
//    }
    [params setObject:@(appType) forKey:@"appType"];
    
    [self getToken:^(id token) {
        [params setObject:token forKey:@"token"];
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
            if (success) {
                [self checkStatusWithResponse:response];
                success(response);
            }
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
        }];

    } failure:^(NSError *errToken) {
        
    }];
}

+ (void)getSupermarketShoppintCartListWithAppType:(NSInteger)appType
                                          success:(void (^)(id response))success
                                      failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@FreshMart/User/GetUserShopCartOfList",BaseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    YCAccountModel *model = [YCAccountModel getAccount];
////    if (model.token) {
//        [params setObject:model.token forKey:@"token"];
//    }
    [params setObject:@(appType) forKey:@"appType"];
//    [params setObject:model.token forKey:@"token"];

    
    [self getToken:^(id token) {
        [params setObject:token forKey:@"token"];
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost
                                                          url:url
                                                       params:params
                                                      success:^(id response)
    {
            if (success) {
                NSLog(@"%@",response);
                [self checkStatusWithResponse:response];
                success(response);
            }
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
        }];
    } failure:^(NSError *errToken) {

    }];
}

//删除我的购物车
+ (void)deleteSupermarketShoppingCartGoodsWithIDs:(NSArray *)IDs
                                         divCodes:(NSArray *)divCodes
                                          success:(void (^)(id response))success
                                          failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@FreshMart/User/DelUserShopCart",BaseUrl];
    NSMutableDictionary *params = @{}.mutableCopy;
    NSMutableString *itemCodesString = [[NSMutableString alloc] init];
    NSMutableString *divCodesString = [[NSMutableString alloc] init];
    for (int i = 0; i < IDs.count; i++) {
        if (i == (IDs.count - 1)) {
            [itemCodesString appendString:IDs[i]];
            [divCodesString appendString:divCodes[i]];
        } else {
            [itemCodesString appendString:[NSString stringWithFormat:@"%@,",IDs[i]]];
            [divCodesString appendString:[NSString stringWithFormat:@"%@,",divCodes[i]]];
        }
    }
    
    [params setObject:itemCodesString forKey:@"arrItemCode"];
    [params setObject:divCodesString forKey:@"arrDivCode"];
    
    YCAccountModel *model = [YCAccountModel getAccount];
    if (model.token) {
        [params setObject:model.token forKey:@"token"];
    }
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *err) {
            NSLog(@"%@",err);
    }];
    
}

//编辑购物车
+ (void)editSupermarketShoppingCartWithDataArray:(NSArray *)dataArray
                                         success:(void (^)(id response))success
                                         failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@FreshMart/User/UpdateUserShopCart",BaseUrl];
    
    NSMutableArray *goods = @[].mutableCopy;
    
    for (NSDictionary *dic in dataArray) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        NSString *jsonString = @"";
    
        if (! jsonData)
        {
            NSLog(@"Got an error: %@", error);
        }else
        {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
    
        jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
        
//        [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        [goods addObject:jsonString];
    }

    NSData *data = [NSJSONSerialization dataWithJSONObject:dataArray options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:jsonString forKey:@"arrCardModel"];
    YCAccountModel *model = [YCAccountModel getAccount];
//    if (model.token) {
//        [params setObject:model.token forKey:@"token"];
//    }
    
    [self getToken:^(id token) {
        [params setObject:token forKey:@"token"];
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
            if (success) {
                success(response);
            }
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
        }];
    } failure:^(NSError *errToken) {
        
    }];
}

//获取搜索列表  0降 1 升
+ (void)getSearchResultWithKeyWords:(NSString *)keyWord
                        orderByType:(NSInteger)orderByType
                          sortField:(NSString *)sortField
                          pageIndex:(NSInteger)pageIndex
                            appType:(NSInteger)appType
                            success:(void (^)(id response))success
                            failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@FreshMart/Goods/SearchGoods",BaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:keyWord forKey:@"keyWord"];
    [params setObject:[NSNumber numberWithInteger:orderByType] forKey:@"orderByType"];
    [params setObject:sortField forKey:@"sortField"];
    [params setObject:[NSNumber numberWithInteger:pageIndex] forKey:@"pageindex"];
    [params setObject:[NSNumber numberWithInteger:20] forKey:@"pagesize"];
    [params setObject:@(appType) forKey:@"appType"];
    
    NSString *divCode = [[NSUserDefaults standardUserDefaults] objectForKey:DivCodeDefault];
    if (divCode.length > 0) {
        [params setObject:divCode forKey:@"div_code"];
    }
    
//    YCAccountModel *model = [YCAccountModel getAccount];
//    if (model.token) {
//        [params setObject:model.token forKey:@"token"];
//    }
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
    }];

}

+ (void)getSupermarketKindListWithKindCode:(NSString *)kindeCode
                                     level:(NSString *)level
                               orderByType:(NSInteger)orderByType //0降 1升
                                 sortField:(NSString *)sortField
                                 pageindex:(NSInteger)pageIndex
                                  pageSize:(NSInteger)pageSize
                                   success:(void (^)(id response))success
                                   failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@FreshMart/Goods/GetGoodsListOfCategroy",BaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
//    [params setObject:kindeCode forKey:@"category_code"];
//    [params setObject:@(orderByType) forKey:@"orderByType"];
    [params setObject:sortField forKey:@"sortField"];
    [params setObject:@(pageIndex) forKey:@"pageindex"];
    [params setObject:@(pageSize) forKey:@"pagesize"];
//    [params setObject:level forKey:@"level2"];
    [params setObject:level forKey:@"level"];
    
    NSString *divCode = [[NSUserDefaults standardUserDefaults] objectForKey:DivCodeDefault];
    if (divCode.length > 0) {
    [params setObject:divCode forKey:@"div_code"];
    }
    
//    YCAccountModel *model = [YCAccountModel getAccount];
//    if (model.token) {
//        [params setObject:model.token forKey:@"token"];
//    }
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
    }];

}

//获取订单列表
+ (void)getOrderListWithStatus:(NSInteger)status
                     pageIndex:(NSInteger)pageIndex
                       appType:(NSInteger)appType
                       success:(void (^)(id response))success
                       failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@FreshMart/Order/GetUserOrderOfList",BaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:[NSNumber numberWithInteger:status] forKey:@"orderStatus"];
    [params setObject:[NSString stringWithFormat:@"%ld",pageIndex] forKey:@"pageindex"];
    [params setObject:@"20" forKey:@"pagesize"];
    [params setObject:@(appType) forKey:@"appType"];
    
    YCAccountModel *model = [YCAccountModel getAccount];

    [self getToken:^(id token) {
        [params setObject:token forKey:@"token"];
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
            if (success) {
                [self checkStatusWithResponse:response];
                success(response);
            }
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
        }];

    } failure:^(NSError *errToken) {
        
    }];
    
}

//获取今日特惠商品列表
+ (void)getTodayFreshOfListWithActionID:(NSString *)actionID
                                divCode:(NSString *)divCode
                                success:(void (^)(id response))success
                                failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@FreshMart/Main/GetTodayFreshOfList",BaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:actionID forKey:@"ad_id"];
    [params setObject:divCode forKey:@"div_code"];
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
    }];

}

//人气生鲜
+ (void)getSupermarketPopularFreshListWithActionID:(NSString *)actionID
                                           divCode:(NSString *)divCode
                                           success:(void (^)(id response))success
                                           failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@FreshMart/Main/GetHotFreshOfList",BaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:actionID forKey:@"ad_id"];
    [params setObject:divCode forKey:@"div_code"];
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
    }];
}

//最新鲜
+ (void)getSupermarketMostFreshListWithActionID:(NSString *)actionID
                                        divCode:(NSString *)divCode
                                        success:(void (^)(id response))success
                                        failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@FreshMart/Main/GetBestFreshOfList",BaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:actionID forKey:@"ad_id"];
    [params setObject:divCode forKey:@"div_code"];
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
    }];
}

//新品尝鲜列表
+ (void)getSupermarketTasteNewListWithActionID:(NSString *)actionID
                                       divCode:(NSString *)divCode
                                       success:(void (^)(id response))success
                                       failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@FreshMart/Main/GetNewFreshOfList",BaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:actionID forKey:@"ad_id"];
    [params setObject:divCode forKey:@"div_code"];
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
    }];
}

+ (void)testPost {

}

//获取订单详情
+ (void)getSupermarketOrderDetailWithOrderID:(NSString *)orderID
                                     appType:(NSInteger)appType
                                     success:(void (^)(id response))success
                                     failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@FreshMart/Order/GetOrderOfDetails",BaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:orderID forKey:@"order_code"];
    [params setObject:@(appType) forKey:@"appType"];
    
    YCAccountModel *model = [YCAccountModel getAccount];
//    if (model.token) {
//        [params setObject:model.token forKey:@"token"];
//    }
    [self getToken:^(id token) {
        [params setObject:token forKey:@"token"];
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
            NSLog(@"%@",response);
            if (success) {
                success(response);
            }
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
        }];
    } failure:^(NSError *errToken) {
        
    }];
}

//发表评论
+ (void)sendGoodsCommentWithPic:(NSArray *)picArray
                       itemCode:(NSString *)itemCode
                           rate:(NSInteger)rate
                          level:(NSInteger)level
                        content:(NSString *)content
                        orderID:(NSString *)orderID
                        divCode:(NSString *)divCode
                        success:(void (^)(id response))success
                        failure:(void (^)(NSError *err))failure {
    
    [MBProgressHUD showWithView:KEYWINDOW];
    
    NSString *url = [NSString stringWithFormat:@"%@FreshMart/User/SendComment",BaseUrl];
   
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:itemCode forKey:@"item_code"];
    [param setObject:@(rate) forKey:@"score"];
    [param setObject:@(level) forKey:@"level"];
    [param setObject:content forKey:@"content"];
    [param setObject:orderID forKey:@"order_code"];
    [param setObject:divCode forKey:@"div_code"];
    
    YCAccountModel *model = [YCAccountModel getAccount];
//    if (model.token) {
//        [param setObject:model.token forKey:@"token"];
//    }
    [self getToken:^(id token) {
        [param setObject:token forKey:@"token"];
        // 基于AFN3.0+ 封装的HTPPSession句柄
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 20;
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
        // 在parameters里存放照片以外的对象
        [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            // formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
            // 这里的_photoArr是你存放图片的数组
            for (int i = 0; i < picArray.count; i++) {
                
                UIImage *image = picArray[i];
                NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                
                // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
                // 要解决此问题，
                // 可以在上传时使用当前的系统事件作为文件名
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                [formatter setDateFormat:@"yyyyMMddHHmmss"];
                NSString *dateString = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
                /*
                 *该方法的参数
                 1. appendPartWithFileData：要上传的照片[二进制流]
                 2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
                 3. fileName：要保存
                 在服务器上的文件名
                 4. mimeType：上传的文件的类型
                 */
                [formData appendPartWithFileData:imageData name:@"files" fileName:fileName mimeType:@"image/jpeg"]; //
            }
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"---上传进度--- %@",uploadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"```上传成功``` %@",responseObject);
            [self checkStatusWithResponse:responseObject];
            [MBProgressHUD hideHUDForView:KEYWINDOW animated:NO];
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:KEYWINDOW animated:NO];
            NSLog(@"xxx上传失败xxx %@", error);
        }];

    } failure:^(NSError *errToken) {
        
    }];
}

//获取我的评价列表
+ (void)getMyCommentListWithPageInde:(NSInteger)pageIndex
                             success:(void (^)(id response))success
                             failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@User/GetUserOfComment",BaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    YCAccountModel *model = [YCAccountModel getAccount];
//    if (model.token) {
//        [params setObject:model.token forKey:@"token"];
//    }
    [params setObject:@(pageIndex) forKey:@"pageIndex"];
    [params setObject:@(20) forKey:@"pageSize"];
    
    [self getToken:^(id token) {
        [params setObject:token forKey:@"token"];
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
            NSLog(@"%@",response);
            if (success) {
                [self checkStatusWithResponse:response];
                success(response);
            }
            
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
        }];
    } failure:^(NSError *errToken) {
        
    }];
}


//个人中心
+ (void)getSupermarketMineDataWithappType:(NSInteger)appType
                                  success:(void (^)(id response))success
                              failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@FreshMart/User/GetUserInfo",BaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    
    YCAccountModel *model = [YCAccountModel getAccount];
//    if (model.token) {
//        [params setObject:model.token forKey:@"token"];
//    }
    [params setObject:@(appType) forKey:@"appType"];
    
    [self getToken:^(id token) {
        [params setObject:token forKey:@"token"];
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
            NSLog(@"%@",response);
            if (success) {
                [self checkStatusWithResponse:response];
                success(response);
            }
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
        }];

    } failure:^(NSError *errToken) {
        
    }];
}

//物流详情
+ (void)getSupermarketExpressDetailsuccess:(void (^)(id response))success
                                   failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@User/GetGoodsExpressOfList",BaseUrl];
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:nil success:^(id response) {
        NSLog(@"%@",response);
        if (success) {
            success(response);
        }
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
    }];
    
}

//退货详情
+ (void)getSupermarketRefundDetailWithOrderID:(NSString *)orderID
                                      success:(void (^)(id response))success
                                  failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@User/GetGoodsRefundDetails",BaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:orderID forKey:@"string item_code"];
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
        NSLog(@"%@",response);
        if (success) {
            success(response);
        }
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
    }];
}

//确认收货
+ (void)supermarketConfirmReceiveGoodsWithOrderID:(NSString *)orderID
                                       hasConfirm:(BOOL)hasConfirm
                                         success:(void (^)(id response))success
                                         failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@Order/ConfirmOrderOfDelivery",BaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:orderID forKey:@"order_num"];
    
    YCAccountModel *model = [YCAccountModel getAccount];
//    if (model.token) {
//        [params setObject:model.token forKey:@"token"];
//    }
    if (hasConfirm) {
        [params setObject:@"true" forKey:@"hasRefundConfirm"];
    } else {
        [params setObject:@"false" forKey:@"hasRefundConfirm"];
    }
    
    [self getToken:^(id token) {
        [params setObject:token forKey:@"token"];
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
            NSLog(@"%@",response);
            if (success) {
                [self checkStatusWithResponse:response];
                success(response);
            }
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
        }];
    } failure:^(NSError *errToken) {
        
    }];

}

//创建订单前调用方法
+ (void)supermarketCheckBeforeCreateOrder:(NSDictionary *)params
                           isShoppingCart:(BOOL)isShoppingCart
                                  appType:(NSInteger)appType
                                  success:(void (^)(id response))success
                                  failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@Order/CheckBeforeCreateOrder",BaseUrl];
    
    NSError *error;
    
    NSMutableDictionary *mutableParams = params.mutableCopy;
    
    if (isShoppingCart) {
        [mutableParams setObject:@"true" forKey:@"onCartProcess"];
    } else {
        [mutableParams setObject:@"false" forKey:@"onCartProcess"];
    }
    
    NSString *divCode = [[NSUserDefaults standardUserDefaults] objectForKey:DivCodeDefault];
    if (divCode.length > 0) {
        [mutableParams setObject:divCode forKey:@"key"];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mutableParams
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = @"";
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setObject:mutStr forKey:@"orderInfo"];
//    [dic setObject:mutStr forKey:@"Projects"];
    YCAccountModel *model = [YCAccountModel getAccount];
//    if (model.token) {
//        [dic setObject:model.token forKey:@"token"];
//    }
    [dic setObject:@(appType) forKey:@"appType"];
    
    [self getToken:^(id token) {
        [dic setObject:token forKey:@"token"];
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:dic success:^(id response) {
            NSLog(@"%@",response);
            if (success) {
                success(response);
            }
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
        }];

    } failure:^(NSError *errToken) {
        
    }];
}


//提交订单
+ (void)supermarketCreateOrderWithGUID:(NSString *)guid
                                points:(NSString *)points
                               coupons:(NSString *)coupons
                          validateInfo:(NSDictionary *)validateInfo
                               success:(void (^)(id response))success
                               failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@Order/CreateOrder",BaseUrl];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:validateInfo
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = @"";
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:guid forKey:@"guid"];
    [params setObject:points forKey:@"point_amount"];
    [params setObject:jsonString forKey:@"validateInfo"];
    [params setObject:coupons forKey:@"useCouponsIds"];
    YCAccountModel *model = [YCAccountModel getAccount];
    
    [self getToken:^(id token) {
        [params setObject:token forKey:@"token"];
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
            NSLog(@"%@",response);
            if (success) {
                success(response);
            }
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
        }];
    } failure:^(NSError *errToken) {
        
    }];
}

+ (void)autoMatching:(void (^)(id response))success failure:(void (^)(NSError *err))failure {
    YCAccountModel *account = [YCAccountModel getAccount];
    NSString *customCode = account.customCode;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:customCode forKey:@"custom_code"];
    [parameters setObject:@"chn" forKey:@"lang_type"];
    NSString *autoMatchingURI = @"http://api1.dxbhtm.com:7778/api/apiMember/doAutoMatching";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer = responseSerializer;
    manager.requestSerializer.timeoutInterval = 60;
    [manager POST:autoMatchingURI parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

//提交订单(新)
+ (void)supermarketCreateOrderWithOrderInfo:(NSDictionary *)orderInfo
                             isShoppingCart:(BOOL)isShoppingCart
                                    success:(void (^)(id response))success
                                    failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@Order/CreateOrder",BaseUrl];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:orderInfo
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = @"";
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
//    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setObject:jsonString forKey:@"orderInfo"];
    
    if (isShoppingCart) {
        [dic setObject:@"true" forKey:@"onCartProcess"];
    } else {
        [dic setObject:@"false" forKey:@"onCartProcess"];
    }
    
    YCAccountModel *model = [YCAccountModel getAccount];
//    if (model.token) {
//        [dic setObject:model.token forKey:@"token"];
//    }
    
    [self getToken:^(id token) {
        [dic setObject:token forKey:@"token"];
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:dic success:^(id response) {
            NSLog(@"%@",response);
            if (success) {
                success(response);
            }
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
        }];
    } failure:^(NSError *errToken) {
        
    }];
}

//取消订单
+ (void)supermarketCancelOrderWithOrderID:(NSString *)orderNumber
                                  success:(void (^)(id response))success
                                  failure:(void (^)(NSError *err))failure {
     NSString *url = [NSString stringWithFormat:@"%@FreshMart/Order/CancelOrder",BaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:orderNumber forKey:@"order_num"];
    
    YCAccountModel *model = [YCAccountModel getAccount];
    
    [self getToken:^(id token) {
        [params setObject:token forKey:@"token"];
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
            NSLog(@"%@",response);
            if (success) {
                [self checkStatusWithResponse:response];
                success(response);
            }
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
        }];

    } failure:^(NSError *errToken) {
        
    }];
}

//获取分类列表
+ (void)supermarketGetAllKindWithAppType:(NSInteger)appType
                                 success:(void (^)(id response))success
                             failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@FreshMart/Goods/GetCategoryOfList",BaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:@(appType) forKey:@"appType"];
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
        NSLog(@"%@",response);
        if (success) {
            success(response);
        }
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
    }];
}

//支付
+ (void)supermarketPayWithUserID:(NSString *)userID
                     orderNumber:(NSString *)orderNumber
                      orderMoney:(NSString *)orderMoney
                     actualMoney:(NSString *)actualMoney
                           point:(NSString *)point
                      couponCode:(NSString *)couponCode
                        password:(NSString *)passWord
                         success:(void (^)(id response))success
                         failure:(void (^)(NSError *err))failure {
//    NSString *url = @"http://192.168.2.97:83/api/wPayment";
//    NSString *url = @"https://api.dxbhtm.com/wPayment/api/wPayment";
//    NSString *url = @"http://192.168.2.201/wPayment/api/wPayment";
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:userID forKey:@"sPay_user_id"];
    [params setObject:orderNumber forKey:@"order_no"];
    [params setObject:orderMoney forKey:@"order_amount"];
    [params setObject:actualMoney forKey:@"real_amount"];
    if (point != nil) {
        [params setObject:point forKey:@"order_Point"];
    } else {
        [params setObject:@"0" forKey:@"order_Point"];
    }
    
    if (couponCode != nil) {
        [params setObject:couponCode forKey:@"sCouponCode"];
    } else {
        [params setObject:@"0" forKey:@"sCouponCode"];
    }
    [params setObject:passWord forKey:@"spayPWD"];
    
    YCAccountModel *model = [YCAccountModel getAccount];
//    if (model.token) {
//        [params setObject:model.token forKey:@"token"];
//    }
    [self getToken:^(id token) {
        [params setObject:token forKey:@"token"];
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:PaymentUrl params:params success:^(id response) {
            success(response);
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
        }];
    } failure:^(NSError *errToken) {
        
    }];
}

//我的优惠券
+ (void)supermarketGetMyAllCouponspageIndex:(NSInteger)index
                                    success:(void (^)(id response))success
                                    failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@FreshMart/Coupon/GetMyCoupons",BaseUrl];
    
    NSMutableDictionary *parmas = @{}.mutableCopy;
    [parmas setObject:@(index) forKey:@"pageIndex"];
    [parmas setObject:@(20) forKey:@"pageSize"];
    
    YCAccountModel *model = [YCAccountModel getAccount];
//    if (model.token) {
//        [parmas setObject:model.token forKey:@"token"];
//    }
    
    [self getToken:^(id token) {
        [parmas setObject:token forKey:@"token"];
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:parmas success:^(id response) {
            [self checkStatusWithResponse:response];
            success(response);
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
        }];
    } failure:^(NSError *errToken) {
        
    }];
}

+ (void)supermarketGetPointWithOption:(NSInteger)option
                            pageIndex:(NSInteger)pageIndex
                              success:(void (^)(id response))success
                              failure:(void (^)(NSError *err))failure {
//    NSString *urlString = @"https://api.dxbhtm.com/pl_Point/api/PointGetListAndBalance";
    
    NSMutableDictionary *params = @{}.mutableCopy;
    
    YCAccountModel *model = [YCAccountModel getAccount];
    if (model.token) {
//        [params setObject:model.token forKey:@"token"];
        [params setObject:model.memid forKey:@"memid"];
        [params setObject:@(option) forKey:@"s_option"];
    }
    [params setObject:@10 forKey:@"PageSize"];
    [params setObject:@(pageIndex) forKey:@"PageIndex"];
    
    [self getToken:^(id token) {
        [params setObject:token forKey:@"token"];
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:PointListUrl params:params success:^(id response) {
            success(response);
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
        }];
    } failure:^(NSError *errToken) {
        
    }];
}

//申请退款
+ (void)supermarketApplayRefundWithOrderNumber:(NSString *)orderNum
                                      itemCode:(NSString *)itemCode
                                        reason:(NSString *)reason
                                      refundNo:(NSString *)refundNo
                                      isCancel:(BOOL)isCancel
                                       success:(void (^)(id response))success
                                       failure:(void (^)(NSError *err))failure {

    NSString *url = [NSString stringWithFormat:@"%@Freshmart/Refund/SubmitRefundApply",BaseUrl];

    NSMutableDictionary *params = @{}.mutableCopy;
    YCAccountModel *model = [YCAccountModel getAccount];
    if (model.token) {
//        [params setObject:model.token forKey:@"token"];
        [params setObject:model.memid forKey:@"custom_code"];
    }
    [params setObject:orderNum forKey:@"order_num"];
    [params setObject:itemCode forKey:@"item_code"];
    if (reason.length > 0) {
       [params setObject:reason forKey:@"reason_code"];
    } else {
        [params setObject:@"" forKey:@"reason_code"];
    }
    
    if (refundNo.length > 0) {
        [params setObject:refundNo forKey:@"refundNo"];
    } else {
        [params setObject:@"" forKey:@"refundNo"];
    }
    
    if (isCancel) {
        [params setObject:@"1" forKey:@"isCancel"];
    } else {
        [params setObject:@"0" forKey:@"isCancel"];
    }
    
    [self getToken:^(id token) {
        [params setObject:token forKey:@"token"];
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
            [self checkStatusWithResponse:response];
            success(response);
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
        }];
    } failure:^(NSError *errToken) {
        
    }];
}

//退货详情
+ (void)supermarketgetRefundDetailWithRefundNo:(NSString *)refundNo
                                       success:(void (^)(id response))success
                                       failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@refund/GetRefundProcessLog",BaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:refundNo forKey:@"refund_no"];
    YCAccountModel *model = [YCAccountModel getAccount];
//    if (model.token) {
//        [params setObject:model.token forKey:@"token"];
//    }
    
    [self getToken:^(id token) {
        [params setObject:token forKey:@"token"];
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
            success(response);
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
        }];
    } failure:^(NSError *errToken) {
        
    }];
}

//获取退货原因
+ (void)supermarketGetRefundReasonListsuccess:(void (^)(id response))success
                                      failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@Common/GetRefundReasonMsgByList",BaseUrl];
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:nil success:^(id response) {
        success(response);
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
        
    }];
}

//获取退货列表
+ (void)supermarketGetRefundLiestWithPageIndex:(NSInteger)pageIndex
                                       success:(void (^)(id response))success
                                       failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@Refund/GetRefundOrderItemList",BaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:@(pageIndex) forKey:@"pageIndex"];
    [params setObject:@(20) forKey:@"pageSize"];
    YCAccountModel *model = [YCAccountModel getAccount];
//    if (model.token) {
//        [params setObject:model.token forKey:@"token"];
//    }
    
    [self getToken:^(id token) {
        [params setObject:token forKey:@"token"];
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
            success(response);
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
            
        }];
    } failure:^(NSError *errToken) {
        
    }];
}

//退货物流信息
+ (void)supermarketSubmitRefundExpressInfoWithExpressNumber:(NSString *)expressNum
                                                   itemCode:(NSString *)itemCode
                                                   refundNo:(NSString *)refundNo
                                                    success:(void (^)(id response))success
                                                    failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@Refund/SubmitRefundDeliveryInfo",BaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:expressNum forKey:@"delivery_no"];
    [params setObject:itemCode forKey:@"item_code"];
    [params setObject:refundNo forKey:@"refundNo"];
    YCAccountModel *model = [YCAccountModel getAccount];
//    if (model.token) {
//        [params setObject:model.token forKey:@"token"];
//    }
    
    [self getToken:^(id token) {
        [params setObject:token forKey:@"token"];
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
            success(response);
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
        }];
    } failure:^(NSError *errToken) {
        
    }];
}

+ (void)supermarketPaymentSuccessWithOrderNum:(NSString *)orderNum
                                      success:(void (^)(id response))success
                                      failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@Order/UpdatePaymentStatusSync",BaseUrl];
    NSMutableDictionary *params = @{}.mutableCopy;
    YCAccountModel *model = [YCAccountModel getAccount];
//    if (model.token) {
//        [params setObject:model.token forKey:@"token"];
//    }
    [params setObject:orderNum forKey:@"order_num"];
    [self getToken:^(id token) {
        [params setObject:token forKey:@"token"];
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
            success(response);
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
        }];

    } failure:^(NSError *errToken) {
        
    }];
}

+ (void)supermarketGetAlipayStrWithOrderNum:(NSString *)orderNum
                                  payAmount:(NSString *)orderAmount
                                    success:(void (^)(id response))success
                                    failure:(void (^)(NSError *err))failure {
//    NSString *url = @"http://222.240.51.143:8088/Payment/CreateOrder_AliPay";
    NSString *url = [NSString stringWithFormat:@"%@Payment/CreateOrder_AliPay",PaymentBaseURL];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:orderNum forKey:@"pay_order_no"];
    [params setObject:orderAmount forKey:@"pay_order_amount"];
    YCAccountModel *model = [YCAccountModel getAccount];
//    if (model.token) {
//        [params setObject:model.token forKey:@"access_token"];
//    }
    [self getToken:^(id token) {
        [params setObject:token forKey:@"token"];
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
            success(response);
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
        }];
    } failure:^(NSError *errToken) {
        
    }];
}

//调用银联支付
+ (void)supermarketGetUnionPayStrWithOrderNum:(NSString *)orderNum
                                    payAmount:(NSString *)orderAmount
                                      success:(void (^)(id response))success
                                      failure:(void (^)(NSError *err))failure {
//    NSString *url = @"Payment/CreateOrder_UnionPay";
    NSString *url = [NSString stringWithFormat:@"%@Payment/CreateOrder_UnionPay",PaymentBaseURL];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:orderNum forKey:@"pay_order_no"];
    [params setObject:orderAmount forKey:@"pay_order_amount"];
    YCAccountModel *model = [YCAccountModel getAccount];
//    if (model.token) {
//        [params setObject:model.token forKey:@"access_token"];
//    }
    
    [self getToken:^(id token) {
        [params setObject:token forKey:@"token"];
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
            success(response);
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
        }];
    } failure:^(NSError *errToken) {
        
    }];
}

+ (void)supermarketDeleteOrderWithOrderID:(NSString *)orderId
                                  success:(void (^)(id response))success
                                  failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@order/DeleteOrder",BaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    YCAccountModel *model = [YCAccountModel getAccount];
//    if (model.token) {
//        [params setObject:model.token forKey:@"token"];
//    }
    [params setObject:orderId forKey:@"order_num"];
    
    [self getToken:^(id token) {
        [params setObject:token forKey:@"token"];
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
            NSLog(@"%@",response);
            if (success) {
                [self checkStatusWithResponse:response];
                success(response);
            }
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
        }];
    } failure:^(NSError *errToken) {
        
    }];
}

//获取订单里待评价的商品
+ (void)supermarketGetWaitCommentsGoodsWithOrderID:(NSString *)orderID
                                           success:(void (^)(id response))success
                                           failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@Order/GetOrderPendingAssessOfList",BaseUrl];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:orderID forKey:@"order_num"];
    YCAccountModel *model = [YCAccountModel getAccount];
//    if (model.token) {
//        [params setObject:model.token forKey:@"token"];
//    }
    
    [self getToken:^(id token) {
        [params setObject:token forKey:@"token"];
        [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
            NSLog(@"%@",response);
            if (success) {
                [self checkStatusWithResponse:response];
                success(response);
            }
        } failure:^(NSError *err) {
            NSLog(@"%@",err);
        }];
    } failure:^(NSError *errToken) {
        
    }];
}

//百货个人中心
+ (void)shopGetMineDatasuccess:(void (^)(id response))success
                       failure:(void (^)(NSError *err))failure {
//    NSString *url = @"http://192.168.2.179:96/User/GetUserInfo";
    NSString *url = [NSString stringWithFormat:@"%@User/GetUserInfo",ShopBaseUrl];
    NSMutableDictionary *params = @{}.mutableCopy;
    
    YCAccountModel *model = [YCAccountModel getAccount];
    if (model.token) {
        [params setObject:model.token forKey:@"token"];
    }
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
        NSLog(@"%@",response);
        if (success) {
            [self checkStatusWithResponse:response];
            success(response);
        }
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
    }];
}

//百货收藏列表
+ (void)shopGetMyCollectionListsuccess:(void (^)(id response))success
                               failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@User/GetUserFavoritesOfList",ShopBaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    
    YCAccountModel *model = [YCAccountModel getAccount];
    if (model.token) {
        [params setObject:model.token forKey:@"token"];
    }
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
        if (success) {
            [self checkStatusWithResponse:response];
            success(response);
        }
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
    }];

}

//百货退货列表
+ (void)shopGetRefundLiestWithPageIndex:(NSInteger)pageIndex
                                success:(void (^)(id response))success
                                failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@Refund/GetRefundOrderItemList",ShopBaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:@(pageIndex) forKey:@"pageIndex"];
    [params setObject:@(20) forKey:@"pageSize"];
    YCAccountModel *model = [YCAccountModel getAccount];
    if (model.token) {
        [params setObject:model.token forKey:@"token"];
    }
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
        success(response);
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
        
    }];
}

//百货获取订单列表
+ (void)getShopOrderListWithStatus:(NSInteger)status
                     pageIndex:(NSInteger)pageIndex
                       success:(void (^)(id response))success
                       failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@Order/GetUserOrderOfList",ShopBaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:[NSNumber numberWithInteger:status] forKey:@"orderStatus"];
    [params setObject:[NSString stringWithFormat:@"%ld",pageIndex] forKey:@"pageindex"];
    [params setObject:@"20" forKey:@"pagesize"];
    
    YCAccountModel *model = [YCAccountModel getAccount];
    if (model.token) {
        [params setObject:model.token forKey:@"token"];
    }
    
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
        if (success) {
            [self checkStatusWithResponse:response];
            success(response);
        }
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
    }];
}

//百货确认收货
+ (void)shopConfirmReceiveGoodsWithOrderID:(NSString *)orderID
                                          success:(void (^)(id response))success
                                          failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@Order/ConfirmOrderOfDelivery",ShopBaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:orderID forKey:@"order_num"];
    
    YCAccountModel *model = [YCAccountModel getAccount];
    if (model.token) {
        [params setObject:model.token forKey:@"token"];
    }
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
        NSLog(@"%@",response);
        if (success) {
            [self checkStatusWithResponse:response];
            success(response);
        }
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
    }];
}

//百货取消订单
+ (void)shopCancelOrderWithOrderID:(NSString *)orderNumber
                                  success:(void (^)(id response))success
                                  failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@Order/CancelOrder",ShopBaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:orderNumber forKey:@"order_num"];
    
    YCAccountModel *model = [YCAccountModel getAccount];
    if (model.token) {
        [params setObject:model.token forKey:@"token"];
    }
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
        NSLog(@"%@",response);
        if (success) {
            [self checkStatusWithResponse:response];
            success(response);
        }
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
    }];
}

//获取百货购物车列表
+ (void)getShopShoppintCartListsuccess:(void (^)(id response))success
                                      failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@User/GetUserShopCartOfList",ShopBaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    
    YCAccountModel *model = [YCAccountModel getAccount];
    if (model.token) {
        [params setObject:model.token forKey:@"token"];
    }
    
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
        if (success) {
            [self checkStatusWithResponse:response];
            
            success(response);
        }
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
    }];
}

//百货删除我的购物车
+ (void)deleteShopShoppingCartGoodsWithIDs:(NSArray *)IDs
                                         divCodes:(NSArray *)divCodes
                                          success:(void (^)(id response))success
                                          failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@User/DelUserShopCart",ShopBaseUrl];
    NSMutableDictionary *params = @{}.mutableCopy;
    //    [params setObject:IDs forKey:@"arrItemCode"];
    NSMutableString *itemCodesString = [[NSMutableString alloc] init];
    NSMutableString *divCodesString = [[NSMutableString alloc] init];
    for (int i = 0; i < IDs.count; i++) {
        if (i == (IDs.count - 1)) {
            [itemCodesString appendString:IDs[i]];
            [divCodesString appendString:divCodes[i]];
        } else {
            [itemCodesString appendString:[NSString stringWithFormat:@"%@,",IDs[i]]];
            [divCodesString appendString:[NSString stringWithFormat:@"%@,",divCodes[i]]];
        }
    }
    
    [params setObject:itemCodesString forKey:@"arrItemCode"];
    [params setObject:divCodesString forKey:@"arrDivCode"];
    
    YCAccountModel *model = [YCAccountModel getAccount];
    if (model.token) {
        [params setObject:model.token forKey:@"token"];
    }
    
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
    }];
}

//百货编辑购物车
+ (void)editShopShoppingCartWithDataArray:(NSArray *)dataArray
                                         success:(void (^)(id response))success
                                         failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@User/UpdateUserShopCart",ShopBaseUrl];
    
    NSMutableArray *goods = @[].mutableCopy;
    
    for (NSDictionary *dic in dataArray) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        NSString *jsonString = @"";
        
        if (! jsonData)
        {
            NSLog(@"Got an error: %@", error);
        }else
        {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        
        jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
        
        //        [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        [goods addObject:jsonString];
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataArray options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:jsonString forKey:@"arrCardModel"];
    YCAccountModel *model = [YCAccountModel getAccount];
    if (model.token) {
        [params setObject:model.token forKey:@"token"];
    }
    
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
    }];
    
}


//百货增加到我的收藏
+ (void)addShopGoodsToMyCollection:(NSString *)goodID
                       divCode:(NSString *)divCode
                       success:(void (^)(id response))success
                       failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@User/AddUserFavorites",ShopBaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:goodID forKey:@"item_code"];
    [params setObject:divCode forKey:@"div_code"];
    YCAccountModel *model = [YCAccountModel getAccount];
    if (model.token) {
        [params setObject:model.token forKey:@"token"];
    }
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
        if (success) {
            [self checkStatusWithResponse:response];
            success(response);
        }
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
    }];
}

//百货创建订单前调用方法
+ (void)shopCheckBeforeCreateOrder:(NSDictionary *)params
                    isShoppingCart:(BOOL)isShoppingCart
                           success:(void (^)(id response))success
                           failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@Order/CheckBeforeCreateOrder",ShopBaseUrl];
    
    NSError *error;
    
    NSMutableDictionary *mutableParams = params.mutableCopy;
    
    if (isShoppingCart) {
        [mutableParams setObject:@"true" forKey:@"onCartProcess"];
    } else {
        [mutableParams setObject:@"false" forKey:@"onCartProcess"];
    }
    
    NSString *divCode = [[NSUserDefaults standardUserDefaults] objectForKey:DivCodeDefault];
    if (divCode.length > 0) {
        [mutableParams setObject:divCode forKey:@"key"];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mutableParams
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = @"";
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setObject:mutStr forKey:@"orderInfo"];
    //    [dic setObject:mutStr forKey:@"Projects"];
    YCAccountModel *model = [YCAccountModel getAccount];
    if (model.token) {
        [dic setObject:model.token forKey:@"token"];
    }
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:dic success:^(id response) {
        NSLog(@"%@",response);
        if (success) {
            success(response);
        }
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
    }];
}

//提交订单
+ (void)shopCreateOrderWithGUID:(NSString *)guid
                         points:(NSString *)points
                        coupons:(NSString *)coupons
                   validateInfo:(NSDictionary *)validateInfo
                        success:(void (^)(id response))success
                        failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@Order/CreateOrder",ShopBaseUrl];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:validateInfo
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = @"";
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    //    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:guid forKey:@"guid"];
    [params setObject:points forKey:@"point_amount"];
    [params setObject:jsonString forKey:@"validateInfo"];
    [params setObject:coupons forKey:@"useCouponsIds"];
    YCAccountModel *model = [YCAccountModel getAccount];
    if (model.token) {
        [params setObject:model.token forKey:@"token"];
    }
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
        NSLog(@"%@",response);
        if (success) {
            success(response);
        }
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
    }];

}

//获取订单详情
+ (void)getShopOrderDetailWithOrderID:(NSString *)orderID
                              success:(void (^)(id response))success
                              failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@Order/GetOrderOfDetails",ShopBaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:orderID forKey:@"order_code"];
    
    YCAccountModel *model = [YCAccountModel getAccount];
    if (model.token) {
        [params setObject:model.token forKey:@"token"];
    }
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
        NSLog(@"%@",response);
        if (success) {
            success(response);
        }
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
    }];
}

+ (void)shopAddGoodsToShoppingCartWithGoodsID:(NSString *)goodsID
                                   shopID:(NSString *)shopID
                                  applyID:(NSString *)applyID
                                  numbers:(NSInteger)goodsNumber
                                  success:(void (^)(id response))success
                                  failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@User/AddUserShopCart",ShopBaseUrl];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:[NSNumber numberWithInteger:goodsNumber] forKey:@"item_quantity"];
    [params setObject:goodsID forKey:@"item_code"];
    [params setObject:shopID forKey:@"div_code"];
    [params setObject:applyID forKey:@"custom_code"];
    YCAccountModel *model = [YCAccountModel getAccount];
    if (model.token) {
        [params setObject:model.token forKey:@"token"];
    }
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
        [self checkStatusWithResponse:response];
        if (success) {
            success(response);
        }
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
    }];
}


+ (void)sendShopGoodsCommentWithPic:(NSArray *)picArray
                       itemCode:(NSString *)itemCode
                           rate:(NSInteger)rate
                          level:(NSInteger)level
                        content:(NSString *)content
                        orderID:(NSString *)orderID
                        success:(void (^)(id response))success
                        failure:(void (^)(NSError *err))failure {
    
    [MBProgressHUD showWithView:KEYWINDOW];
    
    NSString *url = [NSString stringWithFormat:@"%@User/SendComment",ShopBaseUrl];
    
    NSMutableDictionary *param = @{}.mutableCopy;
    [param setObject:itemCode forKey:@"item_code"];
    [param setObject:@(rate) forKey:@"score"];
    [param setObject:@(level) forKey:@"level"];
    [param setObject:content forKey:@"content"];
    [param setObject:orderID forKey:@"order_code"];
    
    YCAccountModel *model = [YCAccountModel getAccount];
    if (model.token) {
        [param setObject:model.token forKey:@"token"];
    }
    
    
    // 基于AFN3.0+ 封装的HTPPSession句柄
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    // 在parameters里存放照片以外的对象
    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
        // 这里的_photoArr是你存放图片的数组
        for (int i = 0; i < picArray.count; i++) {
            
            UIImage *image = picArray[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
            /*
             *该方法的参数
             1. appendPartWithFileData：要上传的照片[二进制流]
             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
             3. fileName：要保存
             在服务器上的文件名
             4. mimeType：上传的文件的类型
             */
            [formData appendPartWithFileData:imageData name:@"files" fileName:fileName mimeType:@"image/jpeg"]; //
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"---上传进度--- %@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"```上传成功``` %@",responseObject);
        [self checkStatusWithResponse:responseObject];
        [MBProgressHUD hideHUDForView:KEYWINDOW animated:NO];
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:KEYWINDOW animated:NO];
        NSLog(@"xxx上传失败xxx %@", error);
    }];
}

+ (void)checkVersionsuccess:(void (^)(id response))success
                    failure:(void (^)(NSError *err))failure {
    NSString *url = @"https://api.dxbhtm.com:8444/appapi/userapi";
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:@"checkver" forKey:@"action"];
    [params setObject:@"11" forKey:@"vercode"];
    [params setObject:@"4" forKey:@"os"];
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *err) {
        
    }];
}

#pragma mark -- 人生药业登录注册
//注册的用户
+ (void)registerwithMemberId:(NSString *)memid
              withMemberPwd:(NSString*)mempwd
                 withAuthNum:(NSString*)AuthNum
                withParentId:(NSString *)parent_ID
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError *err))failure{
    NSString*url = @"http://member.dxbhtm.com:8800/api/Login/joinMember";
    NSMutableDictionary *dic;
    if (parent_ID.length == 0) {
         dic = @{@"memid":memid,@"HPnum":memid,@"ver":@"2",@"mempwd":mempwd,@"AuthNum":AuthNum}.mutableCopy;
    }else{
        
        [dic setObject:parent_ID forKey:@"parent_ID"];
    }
    
    
    //获得请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:url parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            [MBProgressHUD hideHUDForView:KEYWINDOW animated:NO];
            id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            success(result);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//获取验证码
+(void)getVerCodeWithHPnum:(NSString*)HPnum
                   success:(void (^)(id response))success
                   failure:(void (^)(NSError *err))failure{
   NSString *url = [NSString stringWithFormat:@"http://portal.dxbhtm.com:8488/Member/SMSAuthNumSend?HPnum=%@",HPnum];
    [[KLRequestManager shareManager]RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:nil success:^(id response) {
        if ([response[@"status"] intValue] == 1) {
            success(response);
        }
    } failure:^(NSError *err) {
        
    }];
}

//登录
+ (void)LoginMemberWithMemid:(NSString*)memid
                        withMempwd:(NSString*)mempwd
                      withDeviceNo:(NSString*)deviceNo
                           success:(void (^)(id response))success
                           failure:(void (^)(NSError *err))failure{
    NSString*url = @"http://member.dxbhtm.com:8800/api/Login/memberLogin";
    
    NSMutableDictionary *jsondic = @{@"memid":memid,@"mempwd":mempwd,@"deviceNo":deviceNo,@"ver":@"2",@"s_id":@"",@"lang_type":@"chn"}.mutableCopy;

    //获得请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:url parameters:jsondic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            [MBProgressHUD hideHUDForView:KEYWINDOW animated:NO];
            
            id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            success(result);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
   
}

//学生加入代理
+ (void)joinStudentSellerwithwithParams:(NSMutableDictionary*)param
                                success:(void (^)(id response))success
                                failure:(void (^)(NSError *err))failure{
    NSString*url = @"http://api1.dxbhtm.com:7778/api/apiSeller/joinStudentSeller";
    
    //获得请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            [MBProgressHUD hideHUDForView:KEYWINDOW animated:NO];
            
            id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            success(result);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

//医生加入代理
+ (void)joinDoctorSellerwithwithParams:(NSMutableDictionary*)param
                                success:(void (^)(id response))success
                                failure:(void (^)(NSError *err))failure{
    NSString*url = @"http://api1.dxbhtm.com:7778/api/apiSeller/joinDoctorSeller";
    
    
    
    //获得请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            [MBProgressHUD hideHUDForView:KEYWINDOW animated:NO];
            
            id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            success(result);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

//微信加入代理
+ (void)joinWeixinSellerwithwithParams:(NSMutableDictionary*)param
                               success:(void (^)(id response))success
                               failure:(void (^)(NSError *err))failure{
    NSString*url = @"http://api1.dxbhtm.com:7778/api/apiSeller/joinWeixinSeller";
    
    //获得请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            [MBProgressHUD hideHUDForView:KEYWINDOW animated:NO];
            
            id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            success(result);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

/*
 购买药品是支付时生成订单的方法
 
 @param pay_order_no 订单编号
 @param pay_order_amount 订单总金额
 @param payment_type 支付类型 wechat:1  alipay:2  unionpay:3
 @param pay_order_type 恒等于1
 @param success 请求成功调用的block
 @param failure 请求失败调用的block
 */
+ (void)rsdrugstoreCreateOrderWithPayorderno:(NSString *)pay_order_no
                          withPayorderamount:(NSString *)pay_order_amount
                             withPaymenttype:(NSString *)payment_type
                            withPayOrderType:(NSString *)pay_order_type
                                     success:(void (^)(id response))success
                                     failure:(void (^)(NSError *err))failure {
    NSString*url = @"http://pay.gigao2o.com/RSPaymentService/Payment/Request_Payment_Order";

    if (pay_order_no.length&&pay_order_amount.length&&payment_type.length&&pay_order_type.length) {
         NSMutableDictionary *params = NSDictionaryOfVariableBindings(pay_order_no,pay_order_amount,payment_type,pay_order_type).mutableCopy;
        
        //获得请求管理者
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager POST:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (success) {
                [MBProgressHUD hideHUDForView:KEYWINDOW animated:NO];
                
                id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                success(result);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
    }
    
  
}


/**
 人生设置个人信息

 @param memberID 用户id
 @param nickName 用户昵称
 @param imagePath 用户头像
 @param gender 用户性别
 @param token 用户的token
 @param success 请求成功调用
 @param failure 请求失败调用
 */
+(void)rsSetPersonalInfomationwithMemberId:(NSString *)memberID
                              withNickName:(NSString *)nickName
                             withImagePath:(NSString*)imagePath
                                withGender:(NSString *)gender
                                 withToken:(NSString *)token
                                   success:(void (^)(id response))success
                                   failure:(void (^)(NSError *err))failure{

    NSMutableDictionary *josnParms = @{@"memberID":memberID,@"nickName":nickName,@"imagePath":imagePath,@"gender":gender,@"token":token}.mutableCopy;

    // 1.创建请求
    NSURL *url = [NSURL URLWithString:@"http://rsmember.dxbhtm.com:8800/api/member/editProfile"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSData *data1 = [NSJSONSerialization dataWithJSONObject:josnParms options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = data1;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        success(result);
        
    }];
    
   /* //获得请求管理者
    NSString*url = @"http://rsmember.dxbhtm.com:8800/api/member/editProfile";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    [manager POST:url parameters:josnParms success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            [MBProgressHUD hideHUDForView:KEYWINDOW animated:NO];
            id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            success(result);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    */
}
@end
