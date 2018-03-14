//
//  YCHotelHttpTool.m
//  Portal
//
//  Created by ifox on 2017/4/10.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "YCHotelHttpTool.h"

//#define HotelBaseUrl @"http://192.168.2.147:83/"
//#define HotelBaseUrl @"http://hotel.dxbhtm.com:83/"
#if !DEBUG // 判断是否在测试环境下
    #define HotelBaseUrl @"http://192.168.2.147:84/"
    #define GetTokenUrl @"http://192.168.2.165:89/ws2016/srvJoinModule/10_Login/checkLogin_0911"
    #define LocationUrl @"http://192.168.2.29:8488/Location/GetMyLocation?type=8&lon=113.027417&lat=28.184747"
#else
    #define HotelBaseUrl @"http://hotel.dxbhtm.com:8863/"
    #define GetTokenUrl @"http://member.dxbhtm.com:89/ws2016/srvJoinModule/10_Login/checkLogin_0911"
    #define LocationUrl @"https://portal.dxbhtm.com:443/Location/GetMyLocation?type=8&lon=113.027417&lat=28.184747"
//    #define LocationUrl @"http://portal.dxbhtm.com:8488/Location/GetMyLocation?type=8&lon=113.027417&lat=28.184747"
#endif

@implementation YCHotelHttpTool


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
                [[NSNotificationCenter defaultCenter]postNotificationName:HotelTokenWrong object:nil];
                //                failureToken(response);
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
    if (status.integerValue == 1603) {
        [[NSNotificationCenter defaultCenter]postNotificationName:HotelTokenWrong object:nil];
        
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        
        [MBProgressHUD hideAfterDelayWithView:keyWindow interval:4 text:response[@"msg"]];
    }
    }

+ (void)HotelGetHomePageDataWithLocation:(NSString *)location
                                 success:(void (^)(id response))success
                                 failure:(void (^)(NSError *err))failure; {
    NSString *url = [NSString stringWithFormat:@"%@api/Main_GetData",HotelBaseUrl];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:location forKey:@"sCity"];
//#warning zipcode
//    [params setObject:@"410000" forKey:@"Zip_Code"];
    
    NSString *zipCode = [[NSUserDefaults standardUserDefaults] objectForKey:HotelChooseCityZipCodeDefault];
    if (zipCode.length == 0) {
        [params setObject:@"410000" forKey:@"Zip_Code"];
    } else {
        [params setObject:zipCode forKey:@"Zip_Code"];
    }
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
        failure(err);
    }];
}

//获取酒店相册
+ (void)hotelGetImagesWithHotelID:(NSString *)hotelID
                        imageType:(NSInteger)imageType
                          success:(void (^)(id response))success
                          failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@api/Hotel_GetAlbum",HotelBaseUrl];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:hotelID forKey:@"HotelInfoID"];
    [params setObject:@(imageType) forKey:@"iType"];
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
    }];
}

//获取地区列表
+ (void)hotelGetCityListsuccess:(void (^)(id response))success
                        failure:(void (^)(NSError *err))failure {
//    NSString *url = [NSString stringWithFormat:@"%@api/Hotel_GetLocationCity",HotelBaseUrl];
//    NSString *locationUrl = @"http://192.168.2.29:8488/Location/GetMyLocation?type=8&lon=113.027417&lat=28.184747";
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:LocationUrl params:nil success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
    }];
}

//酒店详情信息,带房型介绍,评分等
+ (void)hotelGetDetailWithHotelID:(NSString *)hotelID
                          success:(void (^)(id response))success
                          failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@api/Hotel_GetInfo",HotelBaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:hotelID forKey:@"HotelInfoID"];
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
    }];
}


//酒店详情介绍,没有图的那个界面,全是小图标
+ (void)hotelgetDetailIntroWithHotelID:(NSString *)hotelID
                               success:(void (^)(id response))success
                               failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@api/Hotel_GetDetail",HotelBaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:hotelID forKey:@"HotelInfoID"];
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
    }];

}

//获取实付金额,积分
+ (void)hotelGetActuallyPayWithHotelID:(NSString *)hotelID
                             roomPrice:(NSNumber *)roomPrice
                            arriveTime:(NSString *)arriveTime
                             leaveTime:(NSString *)leaveTime
                             roomCount:(NSNumber *)roomcount
                              usePoint:(NSString *)usePoint
                            roomTypeID:(NSString *)roomTypeID
                               success:(void (^)(id response))success
                               failure:(void (^)(NSError *err))failure {
     NSString *url = [NSString stringWithFormat:@"%@api/Hotel_GetPrepayment",HotelBaseUrl];
    NSMutableDictionary *params = @{}.mutableCopy;
    
    [params setObject:hotelID forKey:@"HotelInfoID"];
    
    YCAccountModel *model = [YCAccountModel getAccount];
    if (model.memid) {
        [params setObject:model.memid forKey:@"memid"];
//        [params setObject:model.token forKey:@"token"];
    }
    
    [params setObject:roomPrice forKey:@"room_price"];
//    [params setObject:[NSString stringWithFormat:@"%@",roomPrice] forKey:@"room_price"];
    [params setObject:arriveTime forKey:@"ArriveTime"];
    [params setObject:leaveTime forKey:@"LeaveTime"];
    [params setObject:roomcount forKey:@"RoomCount"];
//    [params setObject:[NSString stringWithFormat:@"%@",roomcount] forKey:@"RoomCount"];
    [params setObject:usePoint forKey:@"usePoint"];
    [params setObject:roomTypeID forKey:@"RoomTypeID"];
    
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

//提交酒店订单
+ (void)hotelCreateOrderWithHotelID:(NSString *)hotelID
                           userName:(NSArray *)userNames
                       phoneNumbers:(NSArray *)phoneNumbers
                         arriveTime:(NSString *)arriveTime
                          leaveTime:(NSString *)leaveTime
                         orderMoney:(NSString *)orderMoney
                            payment:(NSNumber *)payment
                              point:(NSNumber *)point
                         retainTime:(NSString *)tetainTime
                         roomTypeID:(NSString *)roomTypeID
                          roomCount:(NSInteger)roomCount
                             remark:(NSString *)remark
                            success:(void (^)(id response))success
                            failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@api/Hotel_CreateOrder",HotelBaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    
    [params setObject:hotelID forKey:@"HotelInfoID"];
    
    YCAccountModel *model = [YCAccountModel getAccount];
    if (model.memid) {
        [params setObject:model.memid forKey:@"memid"];
//        [params setObject:model.token forKey:@"token"];
    }
    
    NSMutableString *postName = [[NSMutableString alloc] init];
    for (int i = 0; i < userNames.count; i++) {
        if (i == (userNames.count - 1)) {
            [postName appendString:userNames[i]];
        } else {
            [postName appendString:[NSString stringWithFormat:@"%@,",userNames[i]]];
        }
    }
    [params setObject:postName forKey:@"userName"];
    
    NSMutableString *postPhone = [[NSMutableString alloc] init];
    for (int i = 0; i < phoneNumbers.count; i++) {
        if (i == (phoneNumbers.count - 1)) {
            [postPhone appendString:phoneNumbers[i]];
        } else {
            [postPhone appendString:[NSString stringWithFormat:@"%@,",phoneNumbers[i]]];
        }
    }
    [params setObject:postPhone forKey:@"Phonenum"];
    
    [params setObject:arriveTime forKey:@"ArriveTime"];
    [params setObject:orderMoney forKey:@"order_amount"];
    [params setObject:leaveTime forKey:@"LeaveTime"];
    [params setObject:payment forKey:@"Prepayment"];
    [params setObject:point forKey:@"Point_amount"];
    [params setObject:tetainTime forKey:@"RetainTime"];
    [params setObject:roomTypeID forKey:@"RoomTypeID"];
    [params setObject:tetainTime forKey:@"RetainTime"];
    [params setObject:@(roomCount) forKey:@"RoomCount"];
    [params setObject:remark forKey:@"Remark"];
     NSLog(@"%@",params);
    
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

//获取订单详情
+ (void)hotelGetOrderDetailWithOrderID:(NSString *)orderID
                               success:(void (^)(id response))success
                               failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@api/Hotel_GetOrderDetail",HotelBaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    
    YCAccountModel *model = [YCAccountModel getAccount];
    if (model.memid) {
        [params setObject:model.memid forKey:@"memid"];
//        [params setObject:model.token forKey:@"token"];
    }
    [params setObject:orderID forKey:@"orderId"];

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

//获取酒店排房信息
+ (void)hotelGetOrderArrangeInfoWithOrderID:(NSString *)orderID
                                    success:(void (^)(id response))success
                                    failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@api/Hotel_GetOrderArrangeInfo",HotelBaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    YCAccountModel *model = [YCAccountModel getAccount];
    if (model.memid) {
        [params setObject:model.memid forKey:@"memid"];
//        [params setObject:model.token forKey:@"token"];
    }
    [params setObject:orderID forKey:@"orderId"];
    
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

//获取订单列表
+ (void)hotelGetOrderListWithPageIndex:(NSInteger)pageIndex
                           orderStatus:(NSInteger)orderstatus
                               success:(void (^)(id response))success
                               failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@api/Hotel_GetOrderList",HotelBaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    
    YCAccountModel *model = [YCAccountModel getAccount];
    if (model.memid) {
        [params setObject:model.memid forKey:@"memid"];
//        [params setObject:model.token forKey:@"token"];
    }
    [params setObject:@(pageIndex) forKey:@"iPageIndex"];
    [params setObject:@(20) forKey:@"iPageSize"];
    [params setObject:@(orderstatus) forKey:@"orderstatus"];
    
    [self getToken:^(id token) {
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
    } failure:^(NSError *errToken) {
        
    }];

}

//取消订单
+ (void)hotelCancelOrderWithOrderID:(NSString *)orderID
                       cancelReason:(NSString *)cancelReason
                      cancelContext:(NSString *)cancelContext
                            success:(void (^)(id response))success
                            failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@api/Hotel_CancelOrder",HotelBaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    
    YCAccountModel *model = [YCAccountModel getAccount];
    if (model.memid) {
        [params setObject:model.memid forKey:@"memid"];
//        [params setObject:model.token forKey:@"token"];
    }
    [params setObject:orderID forKey:@"orderId"];
    [params setObject:cancelReason forKey:@"cancelCause"];
    [params setObject:cancelContext forKey:@"cancelContext"];
    
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

//删除订单
+ (void)hotelDeleteOrderWithOrderID:(NSString *)orderID
                            success:(void (^)(id response))success
                            failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@api/Hotel_DelOrder",HotelBaseUrl];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:orderID forKey:@"orderId"];
    YCAccountModel *model = [YCAccountModel getAccount];
    if (model.memid) {
        [params setObject:model.memid forKey:@"memid"];
//        [params setObject:model.token forKey:@"token"];
    }
    
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

//房型预览
+ (void)hotelGetRoomTypeDetailWithHotelID:(NSString *)hotelID
                               roomTypeID:(NSString *)roomTypeID
                                  success:(void (^)(id response))success
                                  failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@api/Hotel_GetRoomTypeDetail",HotelBaseUrl];
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:hotelID forKey:@"HotelInfoID"];
    [params setObject:roomTypeID forKey:@"RoomTypeID"];
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
    }];

}

//发布评价
+ (void)hotelSendCommentWithOrderID:(NSString *)orderID
                            content:(NSString *)content
                              score:(float)score
                       hygieneScore:(float)hygieneScore
                 environmentalScore:(float)environmentalScore
                       serviceScore:(float)serviceScore
               facilitiesProportion:(float)facilitiesProportion
                            hotelID:(NSString *)hotelID
                         imagePaths:(NSArray *)imagePaths
                            success:(void (^)(id response))success
                            failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@api/Hotel_AddRated",HotelBaseUrl];
    NSMutableDictionary *params = @{}.mutableCopy;
    
    YCAccountModel *model = [YCAccountModel getAccount];
    if (model.memid) {
        [params setObject:model.memid forKey:@"memid"];
//        [params setObject:model.token forKey:@"token"];
    }
    [params setObject:orderID forKey:@"orderId"];
    if (content.length > 0) {
        [params setObject:content forKey:@"RatedContext"];
    } else {
        [params setObject:@"" forKey:@"RatedContext"];
    }
    
    [params setObject:@(score) forKey:@"score"];
    [params setObject:@(hygieneScore) forKey:@"HygieneScore"];
    [params setObject:@(environmentalScore) forKey:@"EnvironmentalScore"];
    [params setObject:@(serviceScore) forKey:@"ServiceScore"];
    [params setObject:@(facilitiesProportion) forKey:@"FacilitiesProportion"];
    [params setObject:hotelID forKey:@"HotelInfoID"];
    
    if (imagePaths.count == 0) {
        [params setObject:@"" forKey:@"ImgPath"];
    } else {
        NSMutableString *paths = [[NSMutableString alloc] init];
        for (int i = 0; i < imagePaths.count; i++) {
            if (i == (imagePaths.count - 1)) {
                [paths appendString:imagePaths[i]];
            } else {
                [paths appendString:[NSString stringWithFormat:@"%@,",imagePaths[i]]];
            }
        }
        [params setObject:paths forKey:@"ImgPath"];
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

//上传图片
+ (void)hotelUpLoadImages:(NSArray *)images
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError *err))failure {
//    NSString *url = [NSString stringWithFormat:@"http://hotel.dxbhtm.com:83/07_FileUpload/MultiFileUploader.ashx"];
    NSString *url = [NSString stringWithFormat:@"%@07_FileUpload/MultiFileUploader.ashx",HotelBaseUrl];
//    NSString *url = @"http://222.240.51.146:8488/Common/MultiFileUploader.ashx";
    
    NSMutableDictionary *param = @{}.mutableCopy;
    
    // 基于AFN3.0+ 封装的HTPPSession句柄
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    // 在parameters里存放照片以外的对象
    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
        // 这里的_photoArr是你存放图片的数组
        for (int i = 0; i < images.count; i++) {
            
            UIImage *image = images[i];
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
             3. fileName：要保存在服务器上的文件名
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

//获取酒店评论列表
+ (void)hotelGetCommentListWithHotelID:(NSString *)hotelID
                           optionIndex:(NSInteger)optionIndex
                             pageIndex:(NSInteger)pageIndex
                               success:(void (^)(id response))success
                               failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@api/Hotel_GetRatedList",HotelBaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:hotelID forKey:@"HotelInfoID"];
    [params setObject:@(optionIndex) forKey:@"OpIndex"];
    [params setObject:@(pageIndex) forKey:@"iPageIndex"];
    [params setObject:@(20) forKey:@"iPageSize"];
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:params success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
    }];

}

+ (void)hotelGetRetainTimeListWithArriveTime:(NSString *)arrivieTime
                                     success:(void (^)(id response))success
                                     failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@api/Hotel_GetRetainTimeList",HotelBaseUrl];
    
    NSMutableDictionary *parmas = @{}.mutableCopy;
    [parmas setObject:arrivieTime forKey:@"Arrivetime"];
    
    [[KLRequestManager shareManager] RYRequestWihtMethod2:KLRequestMethodTypePost url:url params:parmas success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *err) {
        NSLog(@"%@",err);
    }];
}

//获取酒店qr开房信息
+ (void)hotelGetQRTextWithRegisterID:(NSString *)registerID
                             hotelID:(NSString *)hotelID
                              roomNo:(NSString *)roomNo
                             success:(void (^)(id response))success
                             failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@api/Hotel_GetQRText",HotelBaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    
    YCAccountModel *model = [YCAccountModel getAccount];
    if (model.memid) {
        [params setObject:model.memid forKey:@"memid"];
//        [params setObject:model.token forKey:@"token"];
    }
//    [params setObject:registerID forKey:@"RegisterID"];
    [params setObject:hotelID forKey:@"HotelID"];
    [params setObject:roomNo forKey:@"RoomNo"];
    
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

//酒店获取退款金额
+ (void)hotelGetRefundMoneyWithOrderID:(NSString *)orderID
                               success:(void (^)(id response))success
                               failure:(void (^)(NSError *err))failure {
    NSString *url = [NSString stringWithFormat:@"%@Api/Hotel_GetCancelMoney",HotelBaseUrl];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    YCAccountModel *model = [YCAccountModel getAccount];
    if (model.memid) {
        [params setObject:model.memid forKey:@"memid"];
//        [params setObject:model.token forKey:@"token"];
    }
    [params setObject:orderID forKey:@"orderId"];
    
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


@end
