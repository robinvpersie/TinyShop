//
//  NSDictionary+Decode.h
//  Portal
//
//  Created by 左梓豪 on 2016/12/5.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLBannerData.h"
#import "MovieData.h"
#import "BroadcastData.h"
#import "VoteData.h"
#import "SupermarketHomeBannerData.h"
#import "SupermarketHomeMostFreshData.h"
#import "SupermarketHomePurchaseData.h"
#import "SupermarketHomeTasteFreshBannerData.h"
#import "SupermarketHomePeopleLikeData.h"
#import "SupermarketHomeADVData.h"
#import "SupermarketCommentData.h"
#import "SupermarketGoodsModel.h"
#import "SupermarketAddressModel.h"
#import "LZCartModel.h"
#import "SupermarketOrderData.h"
#import "SupermarketOnSaleModel.h"
#import "OrderDetailModel.h"
#import "SupermarketMineData.h"
#import "SupermarketExpressData.h"
#import "SupermarketRefundData.h"
#import "SupermarketKindModel.h"
#import "CheckOrderModel.h"
#import "GoodsOptionModel.h"
#import "CouponModel.h"
#import "SupermarketPointModel.h"
#import "RefundDetailModel.h"
#import "RefundListData.h"
#import "SupermarketRefundResaonModel.h"


@class SupermarketOrderGoodsData;

@interface NSDictionary (Decode)

//狂乐传媒
+ (KLBannerData *)getBannerModelWithDic:(NSDictionary *)dic;

+ (MovieData *)getMovieModelWithDic:(NSDictionary *)dic;

+ (BroadcastData *)getBroadCastModelWithDic:(NSDictionary *)dic;

+ (VoteData *)getVoteModelWithDic:(NSDictionary *)dic;


//生鲜超市
+ (SupermarketHomeBannerData *)getSupermarketBannerWithDic:(NSDictionary *)dic;

+ (SupermarketHomeADVData *)getSupermarketHomeADDataWithDic:(NSDictionary *)dic;

+ (SupermarketHomeMostFreshData *)getSupermarketHomeMostFreshDataWithDic:(NSDictionary *)dic;

+ (SupermarketHomePurchaseData *)getSupermarketHomePurchaseDataWithDic:(NSDictionary *)dic;

+ (SupermarketHomeTasteFreshBannerData *)getSupermarketHomeTasteDataWithDic:(NSDictionary *)dic;

+ (SupermarketHomePeopleLikeData *)getSupermarketHomePeopleLikeDataWithDic:(NSDictionary *)dic;

+ (SupermarketCommentData *)getCommentDataWithDic:(NSDictionary *)dic;

+ (SupermarketGoodsModel *)getGoodsMsgDataWithDic:(NSDictionary *)dic;

+ (SupermarketAddressModel *)getAddressDataWithDic:(NSDictionary *)dic;

+ (LZCartModel *)getLzCartModelWithDic:(NSDictionary *)dic;

+ (LZCartModel *)getShoppingCartModelWithDic:(NSDictionary *)dic;

+ (NSMutableArray *)getShoppingartListShopsWithData:(NSArray *)data;

+ (SupermarketHomePeopleLikeData *)getSupermarketSearchResultModelWithDic:(NSDictionary *)dic;

+ (SupermarketOrderData *)getOrderDataWithDic:(NSDictionary *)dic;

//今日特惠
+ (SupermarketOnSaleModel *)getOnsaleModelWithDic:(NSDictionary *)dic;

//订单详情
+ (OrderDetailModel *)getOrderDetailModelWithDic:(NSDictionary *)dic;

//个人中心
+ (SupermarketMineData *)getMineDataWithDic:(NSDictionary *)dic;

//物流详情
+ (SupermarketExpressData *)getExpDataWithDic:(NSDictionary *)dic;

//退货详情
+ (SupermarketRefundData *)getRefundDataWithDic:(NSDictionary *)dic;

//分类列表
+ (SupermarketKindModel *)getKindsModelWithDic:(NSDictionary *)dic;

//分类结果
+ (SupermarketHomePeopleLikeData *)getSupermarketKindsGoodListDataWithDic:(NSDictionary *)dic;

//检查订单
+ (CheckOrderModel *)getSupermarketCheckOrderModelWithDic:(NSDictionary *)dic;

//option规格选择
+ (GoodsOptionModel *)getGoodsOptionModelWithDic:(NSDictionary *)dic;

//优惠券
+ (CouponModel *)getCouponModelWithDic:(NSDictionary *)dic;

//积分
+ (SupermarketPointModel *)getPointModelWithDic:(NSDictionary *)dic;

//退款详情
+ (RefundDetailModel *)getRefundDetailModelWithDic:(NSDictionary *)dic;

//退款列表
+(RefundListData *)getRefundListDataWithDic:(NSDictionary *)dic;

//退货原因
+ (SupermarketRefundResaonModel *)getRefundReasonWithDic:(NSDictionary *)dic;

//带评价商品
+ (SupermarketOrderGoodsData *)getWaitCommentGoodsDataWithDic:(NSDictionary *)dic;

@end
