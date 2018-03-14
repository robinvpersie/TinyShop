//
//  YCHotelHttpTool.h
//  Portal
//
//  Created by ifox on 2017/4/10.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLRequestManager.h"

@interface YCHotelHttpTool : NSObject

+ (void)HotelGetHomePageDataWithLocation:(NSString *)location
                                 success:(void (^)(id response))success
                            failure:(void (^)(NSError *err))failure;

//获取酒店相册
+ (void)hotelGetImagesWithHotelID:(NSString *)hotelID
                        imageType:(NSInteger)imageType
                          success:(void (^)(id response))success
                          failure:(void (^)(NSError *err))failure;

//获取地区列表
+ (void)hotelGetCityListsuccess:(void (^)(id response))success
                        failure:(void (^)(NSError *err))failure;

//酒店详情信息,带房型介绍,评分等
+ (void)hotelGetDetailWithHotelID:(NSString *)hotelID
                          success:(void (^)(id response))success
                          failure:(void (^)(NSError *err))failure;

//酒店详情介绍,没有图的那个界面,全是小图标
+ (void)hotelgetDetailIntroWithHotelID:(NSString *)hotelID
                               success:(void (^)(id response))success
                               failure:(void (^)(NSError *err))failure;

//获取实付金额,积分
+ (void)hotelGetActuallyPayWithHotelID:(NSString *)hotelID
                             roomPrice:(NSNumber *)roomPrice
                            arriveTime:(NSString *)arriveTime
                             leaveTime:(NSString *)leaveTime
                             roomCount:(NSNumber *)roomcount
                              usePoint:(NSString *)usePoint
                            roomTypeID:(NSString *)roomTypeID
                               success:(void (^)(id response))success
                               failure:(void (^)(NSError *err))failure;


/**
 提交酒店订单

 @param hotelID 酒店ID
 @param userNames 预定人姓名
 @param phoneNumbers 预订人电话
 @param arriveTime 入住时间
 @param leaveTime 离店时间
 @param payment 支付金额
 @param point 使用积分
 @param tetainTime 到店时间
 @param roomTypeID 房间类型ID
 @param roomCount 房间数量
 @param remark 备注
 */
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
                            failure:(void (^)(NSError *err))failure;

//获取酒店排房信息
+ (void)hotelGetOrderArrangeInfoWithOrderID:(NSString *)orderID
                                    success:(void (^)(id response))success
                                    failure:(void (^)(NSError *err))failure;

//获取订单详情
+ (void)hotelGetOrderDetailWithOrderID:(NSString *)orderID
                               success:(void (^)(id response))success
                               failure:(void (^)(NSError *err))failure;

//获取订单列表
+ (void)hotelGetOrderListWithPageIndex:(NSInteger)pageIndex
                           orderStatus:(NSInteger)orderstatus
                               success:(void (^)(id response))success
                               failure:(void (^)(NSError *err))failure;

//取消订单
+ (void)hotelCancelOrderWithOrderID:(NSString *)orderID
                       cancelReason:(NSString *)cancelReason
                      cancelContext:(NSString *)cancelContext
                            success:(void (^)(id response))success
                            failure:(void (^)(NSError *err))failure;

//删除订单
+ (void)hotelDeleteOrderWithOrderID:(NSString *)orderID
                            success:(void (^)(id response))success
                            failure:(void (^)(NSError *err))failure;

//房型预览
+ (void)hotelGetRoomTypeDetailWithHotelID:(NSString *)hotelID
                               roomTypeID:(NSString *)roomTypeID
                                  success:(void (^)(id response))success
                                  failure:(void (^)(NSError *err))failure;


/**
 发布评价
 @param orderID 订单编号
 @param content 评价内容
 @param score 总评分
 @param hygieneScore 卫生评分
 @param environmentalScore 环境评分
 @param serviceScore 服务评分
 @param facilitiesProportion 设施评分
 @param hotelID 酒店ID
 @param imagePaths 图片地址
 */
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
                            failure:(void (^)(NSError *err))failure;

//上传图片
+ (void)hotelUpLoadImages:(NSArray *)images
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError *err))failure;

//获取酒店评论列表
+ (void)hotelGetCommentListWithHotelID:(NSString *)hotelID
                           optionIndex:(NSInteger)optionIndex
                             pageIndex:(NSInteger)pageIndex
                               success:(void (^)(id response))success
                               failure:(void (^)(NSError *err))failure;

//获取到店时间
+ (void)hotelGetRetainTimeListWithArriveTime:(NSString *)arrivieTime
                                     success:(void (^)(id response))success
                                     failure:(void (^)(NSError *err))failure;

//获取酒店qr开房信息
+ (void)hotelGetQRTextWithRegisterID:(NSString *)registerID
                             hotelID:(NSString *)hotelID
                              roomNo:(NSString *)roomNo
                             success:(void (^)(id response))success
                             failure:(void (^)(NSError *err))failure;

//酒店获取退款金额
+ (void)hotelGetRefundMoneyWithOrderID:(NSString *)orderID
                               success:(void (^)(id response))success
                               failure:(void (^)(NSError *err))failure;
@end
