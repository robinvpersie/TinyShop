//
//  KLHttpTool.h
//  Portal
//
//  Created by 左梓豪 on 2016/12/5.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLRequestManager.h"

@interface KLHttpTool : NSObject

+ (void)checkAddressZipcodeWithProviceName:(NSString *)proviceName
                                  cityName:(NSString *)cityName
                                   success:(void (^)(id response))success
                                   failure:(void (^)(NSError *err))failure;

+ (void)checkTokenWithToken:(NSString *)token
                   userName:(NSString *)userName
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError *err))failure;

//狂乐传媒主页数据
+ (void)getHomePageDataWithUrl:(NSString *)url
                       success:(void (^)(id response))success
                       failure:(void (^)(NSError *err))failure;

#pragma mark - Supermarket

/**
 获取token
 
 @param success 返回token
 */
+ (void)getToken:(void (^)(id token))success
         failure:(void (^)(NSError *errToken))failureToken;

//生鲜超市主页数据
+ (void)getSupermarketHomaDataWithUrl:(NSString *)url
                              divCode:(NSString *)divCode
                              success:(void (^)(id response))success
                              failure:(void (^)(NSError *err))failure;
//商品评价
+ (void)getSupermarketGoodsCommentWithUrl:(NSString *)url
                                 itemCode:(NSString *)itemCode
                                pageIndex:(NSInteger)pageIndex
                                 pageSize:(NSInteger)pageSize
                            commentStatus:(NSInteger)commentStatus
                                 hasImage:(BOOL)hasImage
                                  divCode:(NSString *)divCode
                                  success:(void (^)(id response))success
                                  failure:(void (^)(NSError *err))failure;
//给评论点赞
+ (void)sendLikeToSupermarketGoodsCommentsWithCommentsID:(NSString *)commentsID
                                                 success:(void (^)(id response))success
                                                 failure:(void (^)(NSError *err))failure;
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
							saleCustomCode:(NSString *)sale_custom_code
                                   success:(void (^)(id response))success
                                   failure:(void (^)(NSError *err))failure;

+ (void)getSupermarketUserAddressListWithDivCode:(NSString *)divCode
                                         success:(void (^)(id response))success
                                         failure:(void (^)(NSError *err))failure;

+ (void)getSupermarketUserAddressListWithOffset:(NSString *)offset
                                        success:(void (^)(id response))success
                                        failure:(void (^)(NSError *err))failure;

//新增收货地址
+ (void)supermarketAddNewAddressWithName:(NSString *)name
                                location:(NSString *)location
                                 address:(NSString *)address
                                  mobile:(NSString *)mobile
                              longtitude:(NSString *)longtitude
                                latitude:(NSString *)latitude
                                 zipCode:(NSString *)zipCode
                               isDefault:(BOOL)isDefault
                                 success:(void (^)(id response))success
                                 failure:(void (^)(NSError *err))failure;



+(void)superMarketAddNewAddressWithDeliveryName:(NSString *)name
                                        Address:(NSString *)address
                                        zipcode:(NSString *)zipcode
                                        zipName:(NSString *)zipname
                                      mobilepho:(NSString *)mobilepho
                                     defaultAdd:(NSString *)defaultAdd
                                       latitude:(NSString *)latitude
                                      longitude:(NSString *)longitude
                                        success:(void (^)(id response))success
                                        failure:(void (^)(NSError *err))failure;



+(void)supermaketEditAddresswWithRealName:(NSString *)name
                                 location:(NSString *)location
                                  address:(NSString *)address
                                   seqNum:(NSString *)seqNum
                                mobilepho:(NSString *)mobilepho
                                  zipCode:(NSString *)zipcode
                                  zipName:(NSString *)zipname
                               defaultAdd:(NSString *)defaultAdd
                                  success:(void (^)(id response))success
                                  failure:(void (^)(NSError *err))failure;




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
                               failure:(void (^)(NSError *err))failure;

//设置为默认地址
+ (void)setSupermarketDefaultAddressWithAddressID:(NSString *)addressID
                                           success:(void (^)(id response))success
                                           failure:(void (^)(NSError *err))failure;
//删除地址
+ (void)deleteSupermarketAddressWithAddressID:(NSString *)addressID
                                      success:(void (^)(id response))success
                                      failure:(void (^)(NSError *err))failure;


+(void)deleteSuperMarketAddressWithSeqNum:(NSString *)seqNum
                                  success:(void (^)(id response))success
                                  failure:(void (^)(NSError *err))failure;


//获取自提站点
+ (void)getSelfPickAddressListsuccess:(void (^)(id response))success
                              failure:(void (^)(NSError *err))failure;

//增加到我的收藏
+ (void)addGoodsToMyCollection:(NSString *)goodID
                       divCode:(NSString *)divCode
					  shopCode:(NSString *)custom_code
				SaleCustomCode:(NSString *)sale_custom_code
                       success:(void (^)(id response))success
                       failure:(void (^)(NSError *err))failure;

//删除我的收藏
+ (void)deleteCollectionGoods:(NSArray *)goodsArray
                      success:(void (^)(id response))success
                      failure:(void (^)(NSError *err))failure;

//获取我的收藏夹列表
+ (void)getMyCollectionListWithOffSet:(NSInteger)offset
                               success:(void (^)(id response))success
                           failure:(void (^)(NSError *err))failure;


+ (void)getMyCollectionListWithAppType:(NSInteger)appType
                               success:(void (^)(id response))success
                               failure:(void (^)(NSError *err))failure;



//获取购物车列表
+ (void)getSupermarketShoppintCartListWithAppType:(NSInteger)appType
                                          success:(void (^)(id response))success
                                      failure:(void (^)(NSError *err))failure;
//删除我的购物车
+ (void)deleteSupermarketShoppingCartGoodsWithIDs:(NSArray *)IDs
                                         divCodes:(NSArray *)divCodes
								  SaleCustomCodes:(NSArray*)saleCustomCodes
                                          success:(void (^)(id response))success
                                          failure:(void (^)(NSError *err))failure;

//编辑购物车
+ (void)editSupermarketShoppingCartWithDataArray:(NSArray *)dataArray
										 success:(void (^)(id response))success
										 failure:(void (^)(NSError *err))failure ;

//获取搜索列表  0降 1 升 apptype:6生鲜 8百货
+ (void)getSearchResultWithKeyWords:(NSString *)keyWord
                        orderByType:(NSInteger)orderByType
                          sortField:(NSString *)sortField
                          pageIndex:(NSInteger)pageIndex
                            appType:(NSInteger)appType
                            success:(void (^)(id response))success
                            failure:(void (^)(NSError *err))failure;

//分类的商品
+ (void)getSupermarketKindListWithKindCode:(NSString *)kindeCode
                                     level:(NSString *)level
                               orderByType:(NSInteger)orderByType //0降 1升
                                 sortField:(NSString *)sortField
                                 pageindex:(NSInteger)pageIndex
                                  pageSize:(NSInteger)pageSize
                                   success:(void (^)(id response))success
                                   failure:(void (^)(NSError *err))failure;

//添加到购物车
+ (void)addGoodsToShoppingCartWithGoodsID:(NSString *)goodsID
                                   shopID:(NSString *)shopID
                                  applyID:(NSString *)applyID
                                  numbers:(NSInteger)goodsNumber
                                  success:(void (^)(id response))success
                                  failure:(void (^)(NSError *err))failure;

//获取订单列表
+ (void)getOrderListWithStatus:(NSInteger)status
                     pageIndex:(NSInteger)pageIndex
                       appType:(NSInteger)appType
                       success:(void (^)(id response))success
                       failure:(void (^)(NSError *err))failure;

//获取今日特惠商品列表
+ (void)getTodayFreshOfListWithActionID:(NSString *)actionID
                                divCode:(NSString *)divCode
                                success:(void (^)(id response))success
                                failure:(void (^)(NSError *err))failure;

//人气生鲜
+ (void)getSupermarketPopularFreshListWithActionID:(NSString *)actionID
                                           divCode:(NSString *)divCode
                                           success:(void (^)(id response))success
                                           failure:(void (^)(NSError *err))failure;

//最新鲜
+ (void)getSupermarketMostFreshListWithActionID:(NSString *)actionID
                                        divCode:(NSString *)divCode
                                        success:(void (^)(id response))success
                                        failure:(void (^)(NSError *err))failure;
//新品尝鲜列表
+ (void)getSupermarketTasteNewListWithActionID:(NSString *)actionID
                                       divCode:(NSString *)divCode
                                       success:(void (^)(id response))success
                                       failure:(void (^)(NSError *err))failure;

+ (void)testPost;

//获取订单详情
+ (void)getSupermarketOrderDetailWithOrderID:(NSString *)orderID
                                     appType:(NSInteger)appType
                                     success:(void (^)(id response))success
                                     failure:(void (^)(NSError *err))failure;

//发表评论
+ (void)sendGoodsCommentWithPic:(NSArray *)picArray
                       itemCode:(NSString *)itemCode
                           rate:(NSInteger)rate
                          level:(NSInteger)level
                        content:(NSString *)content
                        orderID:(NSString *)orderID
                        divCode:(NSString *)divCode
                        success:(void (^)(id response))success
                        failure:(void (^)(NSError *err))failure;

+(void)getMyCommentWithOffSet:(NSInteger)offset
                      success:(void (^)(id response))success
                      failure:(void (^)(NSError *err))failure;

//获取我的评价列表
+ (void)getMyCommentListWithPageInde:(NSInteger)pageIndex
                             success:(void (^)(id response))success
                             failure:(void (^)(NSError *err))failure;

//个人中心
+ (void)getSupermarketMineDataWithappType:(NSInteger)appType
                               success:(void (^)(id response))success
                              failure:(void (^)(NSError *err))failure;

//物流详情
+ (void)getSupermarketExpressDetailsuccess:(void (^)(id response))success
                                   failure:(void (^)(NSError *err))failure;

//退货详情
+ (void)getSupermarketRefundDetailWithOrderID:(NSString *)orderID
                                      success:(void (^)(id response))success
                                      failure:(void (^)(NSError *err))failure;

//确认收货
+(void)supermarketConfirmReceiveGoodsWithOrderID:(NSString *)orderID
                                      hasConfirm:(BOOL)hasConfirm
                                         success:(void (^)(id response))success
                                         failure:(void (^)(NSError *err))failure;
//创建订单前调用方法
+ (void)supermarketCheckBeforeCreateOrder:(NSDictionary *)params
                           isShoppingCart:(BOOL)isShoppingCart
                                  appType:(NSInteger)appType
                                  success:(void (^)(id response))success
                                  failure:(void (^)(NSError *err))failure;

//提交订单
+ (void)supermarketCreateOrderWithGUID:(NSString *)guid
                                points:(NSString *)points
                               coupons:(NSString *)coupons
                          validateInfo:(NSDictionary *)validateInfo
                               success:(void (^)(id response))success
                               failure:(void (^)(NSError *err))failure;
//提交订单(新)
+ (void)supermarketCreateOrderWithOrderInfo:(NSDictionary *)orderInfo
                             isShoppingCart:(BOOL)isShoppingCart
                                    success:(void (^)(id response))success
                                    failure:(void (^)(NSError *err))failure;

//取消订单
+ (void)supermarketCancelOrderWithOrderID:(NSString *)orderNumber
                                  success:(void (^)(id response))success
                                  failure:(void (^)(NSError *err))failure;

//获取分类列表
+ (void)supermarketGetAllKindWithAppType:(NSInteger)appType
                                 success:(void (^)(id response))success
                             failure:(void (^)(NSError *err))failure;

//支付
+ (void)supermarketPayWithUserID:(NSString *)userID
                     orderNumber:(NSString *)orderNumber
                      orderMoney:(NSString *)orderMoney
                     actualMoney:(NSString *)actualMoney
                           point:(NSString *)point
                      couponCode:(NSString *)couponCode
                        password:(NSString *)passWord
                         success:(void (^)(id response))success
                         failure:(void (^)(NSError *err))failure;

//我的优惠券
+ (void)supermarketGetMyAllCouponspageIndex:(NSInteger)index
                                    success:(void (^)(id response))success
                                    failure:(void (^)(NSError *err))failure;

//获取积分
+ (void)supermarketGetPointWithOption:(NSInteger)option
                            pageIndex:(NSInteger)pageIndex
                              success:(void (^)(id response))success
                              failure:(void (^)(NSError *err))failure;

//申请退款
+ (void)supermarketApplayRefundWithOrderNumber:(NSString *)orderNum
                                      itemCode:(NSString *)itemCode
                                        reason:(NSString *)reason
                                      refundNo:(NSString *)refundNo
                                      isCancel:(BOOL)isCancel
                                       success:(void (^)(id response))success
                                       failure:(void (^)(NSError *err))failure;

//退货详情
+ (void)supermarketgetRefundDetailWithRefundNo:(NSString *)refundNo
                                       success:(void (^)(id response))success
                                       failure:(void (^)(NSError *err))failure;

//获取退货原因
+ (void)supermarketGetRefundReasonListsuccess:(void (^)(id response))success
                                      failure:(void (^)(NSError *err))failure;

//获取退货列表
+ (void)supermarketGetRefundLiestWithPageIndex:(NSInteger)pageIndex
                                       success:(void (^)(id response))success
                                       failure:(void (^)(NSError *err))failure;

//退货物流信息
+ (void)supermarketSubmitRefundExpressInfoWithExpressNumber:(NSString *)expressNum
                                                   itemCode:(NSString *)itemCode
                                                   refundNo:(NSString *)refundNo
                                                    success:(void (^)(id response))success
                                                    failure:(void (^)(NSError *err))failure;
//支付成功后同步数据用
+ (void)supermarketPaymentSuccessWithOrderNum:(NSString *)orderNum
                                      success:(void (^)(id response))success
                                      failure:(void (^)(NSError *err))failure;

//调用支付宝支付
+ (void)supermarketGetAlipayStrWithOrderNum:(NSString *)orderNum
                                  payAmount:(NSString *)orderAmount
                                    success:(void (^)(id response))success
                                    failure:(void (^)(NSError *err))failure;

//调用银联支付
+ (void)supermarketGetUnionPayStrWithOrderNum:(NSString *)orderNum
                                    payAmount:(NSString *)orderAmount
                                      success:(void (^)(id response))success
                                      failure:(void (^)(NSError *err))failure;

+ (void)supermarketDeleteOrderWithOrderID:(NSString *)orderId
                                  success:(void (^)(id response))success
                                  failure:(void (^)(NSError *err))failure;

//获取订单里待评价的商品
+ (void)supermarketGetWaitCommentsGoodsWithOrderID:(NSString *)orderID
                                           success:(void (^)(id response))success
                                           failure:(void (^)(NSError *err))failure;

#pragma mark - 百货
//百货个人中心
+ (void)shopGetMineDatasuccess:(void (^)(id response))success
                           failure:(void (^)(NSError *err))failure;
//百货收藏列表
+ (void)shopGetMyCollectionListsuccess:(void (^)(id response))success
                               failure:(void (^)(NSError *err))failure;
//百货退货列表
+ (void)shopGetRefundLiestWithPageIndex:(NSInteger)pageIndex
                                       success:(void (^)(id response))success
                                       failure:(void (^)(NSError *err))failure;

//百货订单
+ (void)getShopOrderListWithStatus:(NSInteger)status
                         pageIndex:(NSInteger)pageIndex
                           success:(void (^)(id response))success
                           failure:(void (^)(NSError *err))failure;

//百货确认收货
+ (void)shopConfirmReceiveGoodsWithOrderID:(NSString *)orderID
                                   success:(void (^)(id response))success
                                   failure:(void (^)(NSError *err))failure;

//百货取消订单
+ (void)shopCancelOrderWithOrderID:(NSString *)orderNumber
                           success:(void (^)(id response))success
                           failure:(void (^)(NSError *err))failure;

//获取百货购物车列表
+ (void)getShopShoppintCartListsuccess:(void (^)(id response))success
                               failure:(void (^)(NSError *err))failure;

//百货删除购物车
+ (void)deleteShopShoppingCartGoodsWithIDs:(NSArray *)IDs
                                  divCodes:(NSArray *)divCodes
                                   success:(void (^)(id response))success
                                   failure:(void (^)(NSError *err))failure;

//百货编辑购物车
+ (void)editShopShoppingCartWithDataArray:(NSArray *)dataArray
                                  success:(void (^)(id response))success
                                  failure:(void (^)(NSError *err))failure;

//百货增加到我的收藏
+ (void)addShopGoodsToMyCollection:(NSString *)goodID
                           divCode:(NSString *)divCode
                           success:(void (^)(id response))success
                           failure:(void (^)(NSError *err))failure;

//百货创建订单前调用方法
+ (void)shopCheckBeforeCreateOrder:(NSDictionary *)params
                           isShoppingCart:(BOOL)isShoppingCart
                                  success:(void (^)(id response))success
                                  failure:(void (^)(NSError *err))failure;

//提交订单
+ (void)shopCreateOrderWithGUID:(NSString *)guid
                                points:(NSString *)points
                               coupons:(NSString *)coupons
                          validateInfo:(NSDictionary *)validateInfo
                               success:(void (^)(id response))success
                               failure:(void (^)(NSError *err))failure;

//获取订单详情
+ (void)getShopOrderDetailWithOrderID:(NSString *)orderID
                                     success:(void (^)(id response))success
                                     failure:(void (^)(NSError *err))failure;
//百货添加到购物车
+ (void)shopAddGoodsToShoppingCartWithGoodsID:(NSString *)goodsID
                                       shopID:(NSString *)shopID
                                      applyID:(NSString *)applyID
                                      numbers:(NSInteger)goodsNumber
                                      success:(void (^)(id response))success
                                      failure:(void (^)(NSError *err))failure;

//百货的评价
+ (void)sendShopGoodsCommentWithPic:(NSArray *)picArray
                           itemCode:(NSString *)itemCode
                               rate:(NSInteger)rate
                              level:(NSInteger)level
                            content:(NSString *)content
                            orderID:(NSString *)orderID
                            success:(void (^)(id response))success
                            failure:(void (^)(NSError *err))failure;

+ (void)checkVersionsuccess:(void (^)(id response))success
                    failure:(void (^)(NSError *err))failure;


#pragma  mark -- 人生药业的登录注册
//登录
+ (void)LoginMemberWithMemid:(NSString*)memid
                  withMempwd:(NSString*)mempwd
                withDeviceNo:(NSString*)deviceNo
                     success:(void (^)(id response))success
                     failure:(void (^)(NSError *err))failure;
//注册的用户
+ (void)registerwithMemberId:(NSString *)memid
               withMemberPwd:(NSString*)mempwd
                 withAuthNum:(NSString*)AuthNum
                withParentId:(NSString *)parent_ID
                     success:(void (^)(id response))success
                     failure:(void (^)(NSError *err))failure;
//获取验证码
+(void)getVerCodeWithHPnum:(NSString*)HPnum
                   success:(void (^)(id response))success
                   failure:(void (^)(NSError *err))failure;
//学生加入代理
+ (void)joinStudentSellerwithwithParams:(NSMutableDictionary*)param
                                success:(void (^)(id response))success
                                failure:(void (^)(NSError *err))failure;
//医生加入代理
+ (void)joinDoctorSellerwithwithParams:(NSMutableDictionary*)param
                               success:(void (^)(id response))success
                               failure:(void (^)(NSError *err))failure;
//微信加入代理
+ (void)joinWeixinSellerwithwithParams:(NSMutableDictionary*)param
                               success:(void (^)(id response))success
                               failure:(void (^)(NSError *err))failure;


+ (void)rsdrugstoreCreateOrderWithPayorderno:(NSString *)pay_order_no
                          withPayorderamount:(NSString *)pay_order_amount
                             withPaymenttype:(NSString *)payment_type
                            withPayOrderType:(NSString *)pay_order_type
                                     success:(void (^)(id response))success
                                     failure:(void (^)(NSError *err))failure;
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
                                   failure:(void (^)(NSError *err))failure;

+ (void)autoMatching:(void (^)(id response))success
             failure:(void (^)(NSError *err))failure;




//小商工人个人注册
+ (void)TinyResgisterwithPhone:(NSString *)memid
					withmempwd:(NSString *)mempwd
				  withnickname:(NSString*)nickname
					 withemail:(NSString *)email
				  witheAuthNum:(NSString *)AuthNum
			   withcustom_name:(NSString *)custom_name
			  withtop_zip_code:(NSString *)top_zip_code
			 withtop_addr_head:(NSString *)top_addr_head
		   withtop_addr_detail:(NSString *)top_addr_detail
			 withbusiness_type:(NSString*)business_type
				 withlang_type:(NSString*)lang_type

				withcomp_class:(NSString*)comp_class
				 withcomp_type:(NSString*)comp_type
			   withcompany_num:(NSString*)company_num
				  withzip_code:(NSString*)zip_code
				  withkor_addr:(NSString*)kor_addr
		   withkor_addr_detail:(NSString*)kor_addr_detail
				  withtelephon:(NSString*)telephon
					   success:(void (^)(id response))success
					   failure:(void (^)(NSError *err))failure;

//获取商家列表
+ (void)TinyShoprequestStoreCateListwithCustom_code:(NSString *)custom_code
											 withpg:(NSString*)pg
										  withtoken:(NSString*)token
									withcustom_lev1:(NSString*)custom_lev1
									withcustom_lev2:(NSString*)custom_lev2
									withcustom_lev3:(NSString*)custom_lev3
									   withlatitude:(NSString*)latitude
									  withlongitude:(NSString*)longitude
									   withorder_by:(NSString *)order_by
											success:(void (^)(id response))success
											failure:(void (^)(NSError *err))failure;
/*
 *加载商家详情
 */

+(void)TinyRequestStoreItemDetailwithsaleCustomCode:(NSString *)sale_custom_code
									   withLatitude:(NSString *)latitude
									  withLongitude:(NSString *)longitude
									 withCustomCode:(NSString *)custom_code
									   withPagesize:(NSString *)pagesize
											 withPg:(NSString *)pg
											success:(void (^)(id response))success
											failure:(void (^)(NSError *err))failure;

/*
 *加载第一个商家列表更多的数据
 */
+(void)TinyRequestGetCategory1And2ListWithCustom_lev1:(NSString *)custom_lev1
										 WithLangtype:(NSString*)lang_type
											  success:(void (^)(id response))success
											  failure:(void (^)(NSError *err))failure;

/*
 *加载第二个商家列表更多的数据
 */
+(void)TinyRequestGetCategory3ListWithCustom_lev1:(NSString *)custom_lev1
								  WithCustom_lev2:(NSString *)custom_lev2
									 WithLangtype:(NSString*)lang_type
										  success:(void (^)(id response))success
										  failure:(void (^)(NSError *err))failure;

/*
 *购物车的数量，列表，删除
 */
+(void)TinyRequestShoppingCartCountWithShoppCartUrl:(NSString *)urls
										 WithSale_q:(NSString *)sale_q
									WithCurrentPage:(NSString*)pg
									   WithPageSize:(NSString*)pagesize
											success:(void (^)(id response))success
											failure:(void (^)(NSError *err))failure;

/*
 *商家商品详情查询
 */
+(void)TinyRequestGetKFMEGoodsDetailUrl:(NSString *)urls
					 WithSaleCustomCode:(NSString *)sale_custom_code
						   WithItemCode:(NSString*)item_code
								success:(void (^)(id response))success
								failure:(void (^)(NSError *err))failure;

/*
 加载主页数据
 */
+(void)TinyRequestMainDataUrl:(NSString *)urls
					   Withpg:(NSString *)pg
				 WithPagesize:(NSString*)pagesize
			   WithCustomlev1:(NSString*)custom_lev1
			   WithCustomlev2:(NSString*)custom_lev2
			   WithCustomlev3:(NSString*)custom_lev3
				 Withlatitude:(NSString*)latitude
				Withlongitude:(NSString*)longitude
				 Withorder_by:(NSString*)order_by
					  success:(void (^)(id response))success
					  failure:(void (^)(NSError *err))failure;

/*
 主页搜索商家和商品
 */
+(void)TinySearchShopMainDataUrl:(NSString *)urls
					Withlatitude:(NSString*)latitude
				   Withlongitude:(NSString*)longitude
						  Withpg:(NSString *)pg
					WithPagesize:(NSString*)pagesize
				  WithSearchword:(NSString*)searchword
						 success:(void (^)(id response))success
						 failure:(void (^)(NSError *err))failure;
@end
