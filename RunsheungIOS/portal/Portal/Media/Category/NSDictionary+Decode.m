//
//  NSDictionary+Decode.m
//  Portal
//
//  Created by 左梓豪 on 2016/12/5.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "NSDictionary+Decode.h"
#import "SupermarketOrderGoodsData.h"
#import "SupermarketExpInfoData.h"
#import "SupermarketRefundInfoData.h"
#import "CheckOrderGoodsRange.h"
#import "LZShopModel.h"

#define IMAGEBASEURL @"192.168.2.146"

@implementation NSDictionary (Decode)

+ (KLBannerData *)getBannerModelWithDic:(NSDictionary *)dic {
    KLBannerData *bannerData = [[KLBannerData alloc] init];
    if (dic != nil) {
        bannerData.ver = dic[@"ver"];
        bannerData.imgUrl = dic[@"imgUrl"];
        bannerData.url = dic[@"url"];
        bannerData.contentID = dic[@"contentID"];
    }
    return bannerData;
}

+ (MovieData *)getMovieModelWithDic:(NSDictionary *)dic {
    MovieData *movieData = [[MovieData alloc] init];
    if (dic != nil) {
        movieData.ver = dic[@"ver"];
        movieData.imgUrl = dic[@"imgUrl"];
        movieData.uniqueId = dic[@"uniqueId"];
        movieData.url = dic[@"url"];
    }
    return movieData;
}

+ (BroadcastData *)getBroadCastModelWithDic:(NSDictionary *)dic {
    BroadcastData *broadCataData = [[BroadcastData alloc] init];
    if (dic != nil) {
        broadCataData.ver = dic[@"ver"];
        broadCataData.title = dic[@"title"];
        broadCataData.start_time = dic[@"start_time"];
        broadCataData.end_time = dic[@"end_time"];
        broadCataData.imgUrl = dic[@"imgUrl"];
        broadCataData.url = dic[@"url"];
        broadCataData.uniqueId = dic[@"uniqueId"];
    }
    return broadCataData;
}

+ (VoteData *)getVoteModelWithDic:(NSDictionary *)dic {
    VoteData *voteData = [[VoteData alloc] init];
    if (voteData) {
        voteData.ver = dic[@"ver"];
        voteData.imgUrl = dic[@"imgUrl"];
        voteData.url = dic[@"url"];
        voteData.type = dic[@"type"];
        voteData.uniqueId = dic[@"uniqueId"];
    }
    return voteData;
}

#pragma mark - Supermarket
+ (SupermarketHomeBannerData *)getSupermarketBannerWithDic:(NSDictionary *)dic {
    SupermarketHomeBannerData *data = [[SupermarketHomeBannerData alloc] init];
    if (dic != nil) {
        data.ad_id = dic[@"ad_id"];
        data.imageUrl = dic[@"ad_image"];
        data.link_url = dic[@"link_url"];
        data.start_date = dic[@"start_date"];
        data.end_date = dic[@"end_date"];
        data.ver = dic[@"ver"];
        data.item_code = dic[@"item_code"];
    }
    return data;
}

+ (SupermarketHomeADVData *)getSupermarketHomeADDataWithDic:(NSDictionary *)dic {
    SupermarketHomeADVData *data = [[SupermarketHomeADVData alloc] init];
    if (dic != nil) {
        data.seg_no = dic[@"seg_no"];
        data.ad_id = dic[@"ad_id"];
        data.ad_type = dic[@"ad_type"];
        data.link_url = dic[@"link_url"];
        data.work_menid = dic[@"work_memid"];
        data.version = dic[@"ver"];
        data.ad_title = dic[@"ad_title"];
        data.ad_image = dic[@"ad_image"];
        data.start_date = dic[@"start_date"];
        data.sub_title = dic[@"sub_title"];
    }
    return data;
}

+ (SupermarketHomeMostFreshData *)getSupermarketHomeMostFreshDataWithDic:(NSDictionary *)dic {
    SupermarketHomeMostFreshData *freshData = [[SupermarketHomeMostFreshData alloc] init];
    if (dic != nil) {
        freshData.ad_id = dic[@"ad_id"];
        freshData.item_code = dic[@"item_code"];
        freshData.stock_unit = dic[@"stock_unit"];
        freshData.item_price = dic[@"item_price"];
        freshData.imageUrl = dic[@"image_url"];
        freshData.ver = dic[@"ver"];
        freshData.item_name = dic[@"item_name"];
        //以下最新鲜使用
        freshData.item_des = dic[@"item_describe"];
        freshData.good_num = dic[@"good_num"];
    }
    return freshData;
}

+ (SupermarketHomePurchaseData *)getSupermarketHomePurchaseDataWithDic:(NSDictionary *)dic {
    SupermarketHomePurchaseData *purchaseData = [[SupermarketHomePurchaseData alloc] init];
    if (dic != nil) {
       
    }
    return purchaseData;
}

+ (SupermarketHomeTasteFreshBannerData *)getSupermarketHomeTasteDataWithDic:(NSDictionary *)dic {
    SupermarketHomeTasteFreshBannerData *data = [[SupermarketHomeTasteFreshBannerData alloc] init];
    if (dic != nil) {
      
    }
    return data;
}

+ (SupermarketHomePeopleLikeData *)getSupermarketHomePeopleLikeDataWithDic:(NSDictionary *)dic {
    SupermarketHomePeopleLikeData *likeData = [[SupermarketHomePeopleLikeData alloc] init];
    if (dic != nil) {
        likeData.ad_id = dic[@"ad_id"];
        likeData.item_code = dic[@"item_code"];
        likeData.item_name = dic[@"item_name"];
        likeData.stock_unit = dic[@"stock_unit"];
        likeData.item_price = dic[@"item_price"];
        likeData.imageUrl = dic[@"image_url"];
        likeData.ver = dic[@"ver"];
    }
    return likeData;
}

//评论
+ (SupermarketCommentData *)getCommentDataWithDic:(NSDictionary *)dic {
    SupermarketCommentData *data = [[SupermarketCommentData alloc] init];
    if (dic != nil) {
        data.commentID = dic[@"comment_id"];
        data.sendTime = dic[@"commnet_time"];
        data.hasLikes = dic[@"hasLikes"];
        data.avatarUrlString = dic[@"head_url"];
        data.images = dic[@"images"];
        NSNumber *likes = dic[@"likes_count"];
        data.likeAmount = likes.integerValue;
        data.userID = dic[@"nick_name"];
        NSNumber *rate = dic[@"score"];
        data.rating = rate.floatValue * 2 / 10;
        data.content = dic[@"text"];
        
        NSString *itemCode = dic[@"item_code"];
        NSString *itemName = dic[@"item_name"];
        NSString *imageUrl = dic[@"image_url"];
        data.item_code = itemCode;
        data.item_name = itemName;
        data.image_url = imageUrl;
    }
    return data;
}

+ (SupermarketGoodsModel *)getGoodsMsgDataWithDic:(NSDictionary *)dic {
    SupermarketGoodsModel *goods = [[SupermarketGoodsModel alloc] init];
    if (dic != nil) {
        goods.title = dic[@"title"];
        goods.images = dic[@"images"];
        goods.city = dic[@"city"];
        goods.sold = dic[@"sold"];
        goods.unit = dic[@"unit"];
        goods.price = dic[@"price"];
        goods.marketPrice = dic[@"markeyPrice"];
        goods.linkUrl = dic[@"linkUrl"];
        goods.content = dic[@"content"];
        goods.itemCode = dic[@"itemCode"];
        goods.features = dic[@"features"];
        goods.hasChangeBuy = dic[@"hasChangeBuy"];
        goods.changeBuyTitle = dic[@"hasChangeBuyTitle"];
        goods.hasCollection = dic[@"hasFav"];
        goods.storage = dic[@"storage"];
        goods.business_code = dic[@"div_code"];
        goods.supplier_code = dic[@"custom_code"];
        goods.stock = dic[@"stock"];
        goods.expressAmount = dic[@"expressAmount"];
    }
    return goods;
}

//收货地址
+ (SupermarketAddressModel *)getAddressDataWithDic:(NSDictionary *)dic {
    SupermarketAddressModel *data = [[SupermarketAddressModel alloc] init];
    if (dic != nil) {
        data.address = dic[@"address"];
        data.realname = dic[@"name"];
        data.isdefault = dic[@"hasDefault"];
        data.mobile = dic[@"mobile"];
        data.addressID = dic[@"id"];
        data.latitude = dic[@"latitude"];
        data.longtitude = dic[@"longitude"];
        data.location = dic[@"location"];
        data.hasDelivery = dic[@"hasDelivery"];
        data.zipcode = dic[@"zip_code"];
    }
    return data;
}

//收藏
+ (LZCartModel *)getLzCartModelWithDic:(NSDictionary *)dic {
    LZCartModel *model = [[LZCartModel alloc] init];
    if (dic != nil) {
        model.item_code = dic[@"item_code"];
        model.image_url = dic[@"img_path"];
        model.nameStr = dic[@"item_name"];
        model.price = dic[@"price"];
        model.stock_unit = dic[@"stock_unit"];
        model.divCode = dic[@"div_code"];
    }
    return model;
}
//购物车
+ (LZCartModel *)getShoppingCartModelWithDic:(NSDictionary *)dic {
     LZCartModel *model = [[LZCartModel alloc] init];
    if (dic != nil) {
        model.item_code = dic[@"item_code"];
        model.image_url = dic[@"image_url"];
        NSNumber *number = dic[@"item_quantity"];
        model.number = number.floatValue;
        model.price = dic[@"item_price"];
        model.stock_unit = dic[@"stock_unit"];
        model.nameStr = dic[@"item_name"];
//        model.divCode = ((NSNumber *)dic[@"div_code"]).stringValue;
        model.divCode = dic[@"div_code"];
    }
    return model;
}

+ (NSMutableArray *)getShoppingartListShopsWithData:(NSArray *)data {
    NSMutableArray *shops = [NSMutableArray array];
    if (data.count > 0) {
        for (NSDictionary *shopDic in data) {
            LZShopModel *shopModel = [[LZShopModel alloc] init];
            shopModel.shopID = shopDic[@"div_code"];
            shopModel.shopName = shopDic[@"div_name"];
            [shopModel configGoodsArrayWithArray:shopDic[@"items"]];
            [shops addObject:shopModel];
        }
    }
    return shops;
}

+ (SupermarketHomePeopleLikeData *)getSupermarketSearchResultModelWithDic:(NSDictionary *)dic {
    SupermarketHomePeopleLikeData *data = [[SupermarketHomePeopleLikeData alloc] init];
    if (dic != nil) {
        NSNumber *price = dic[@"price"];
        data.item_price = price.stringValue;
        data.item_code = dic[@"item_code"];
        data.item_name = dic[@"item_name"];
        data.stock_unit = dic[@"stock_unit"];
        data.imageUrl = dic[@"image_url"];
        data.ver = dic[@"ver"];
//        data.item_quantity = dic[@"item_quantity"];
    }
    return data;
}

+ (SupermarketOrderData *)getOrderDataWithDic:(NSDictionary *)dic {
    SupermarketOrderData *data = [[SupermarketOrderData alloc] init];
    if (dic != nil) {
        data.time = dic[@"orderDate"];
        data.invalid_date = dic[@"invalid_date"];
        data.order_code = dic[@"order_code"];
        data.createTime = dic[@"create_date"];
        NSNumber *price = dic[@"order_price"];
        data.totalPrice = price.floatValue;
        data.goodsCount = ((NSNumber *)dic[@"total_num"]).integerValue;
        NSNumber *orderStatus = dic[@"ONLINE_ORDER_STATUS"];
        data.status = orderStatus.integerValue;
        data.expressStatus = ((NSNumber *)dic[@"express_status"]).integerValue;
        data.paymentStatus = ((NSNumber *)dic[@"payment_status"]).integerValue;
        data.assessStatus = ((NSNumber *)dic[@"assess_status"]).integerValue;
        data.actualMoney = dic[@"real_amount"];
        data.point = dic[@"pointAmount"];
        data.syncPaymentStatus = dic[@"syncPaymentStatus"];
        data.canDeleteOrder = dic[@"deletable"];
        data.divCode = dic[@"div_code"];
        data.canBuyAgain = dic[@"buyAgain"];
        
        NSArray *list = dic[@"gourpGoodList"];
        if (list.count > 0) {
            NSMutableArray *listArray = @[].mutableCopy;
            for (NSDictionary *goodsDic in list) {
                SupermarketOrderGoodsData *data = [[SupermarketOrderGoodsData alloc] init];
                data.item_code = goodsDic[@"item_code"];
//                data.need_assess = goodsDic[@"need_assess"];
                data.amount = goodsDic[@"item_quantity"];
                data.price = goodsDic[@"item_price"];
                data.image_url = goodsDic[@"image_url"];
                data.title = goodsDic[@"item_name"];
                data.stockUnit = goodsDic[@"stock_unit"];
                data.refundStatus = ((NSNumber *)goodsDic[@"refund_status"]).integerValue;
                [listArray addObject:data];
            }
            data.goodList = listArray;
        }
        
    }
    return data;
}

+ (SupermarketOnSaleModel *)getOnsaleModelWithDic:(NSDictionary *)dic {
    SupermarketOnSaleModel *model = [[SupermarketOnSaleModel alloc] init];
    if (dic != nil) {
        model.item_code = dic[@"item_code"];
        model.item_name = dic[@"item_name"];
        model.stock_unit = dic[@"stock_unit"];
        model.price = dic[@"item_price"];
        model.iamge_url = dic[@"image_url"];
        model.ver = dic[@"ver"];
    }
    return model;
}

//订单详情
+ (OrderDetailModel *)getOrderDetailModelWithDic:(NSDictionary *)dic {
    OrderDetailModel *model = [[OrderDetailModel alloc] init];
    if (dic != nil) {
        model.orderDate = dic[@"orderDate"];
        model.order_price = dic[@"order_price"];
        model.realPrice = dic[@"real_price"];
        NSDictionary *expStatus = dic[@"expStatus"];
        model.expDate = expStatus[@"expDate"];
        model.expLocation = expStatus[@"expLocation"];
        model.payment = dic[@"payment"];
        NSDictionary *address = dic[@"address"];
        model.user_name = address[@"user_name"];
        model.address = address[@"text"];
        model.mobile = address[@"mobile"];
        model.freight = dic[@"freight"];
        model.distribution = dic[@"distribution"];
        model.order_code = dic[@"order_code"];
        model.point = dic[@"point"];
        model.couponAmout = dic[@"coupons_amount"];
        model.candeleteOrder = dic[@"deletable"];
        
        NSArray *goodsList = dic[@"goods_list"];
        if (goodsList.count > 0) {
            NSMutableArray *goodListArr = @[].mutableCopy;
            for (NSDictionary *goods in goodsList) {
                SupermarketOrderGoodsData *data = [[SupermarketOrderGoodsData alloc] init];
                data.item_code = goods[@"item_code"];
                data.amount = goods[@"item_quantity"];
                data.price = goods[@"item_price"];
                data.image_url = goods[@"image_url"];
                data.title = goods[@"item_name"];
                data.stockUnit = goods[@"stock_unit"];
                data.refundStatus = ((NSNumber *)goods[@"refund_status"]).integerValue;
                [goodListArr addObject:data];
            }
            model.goodList = goodListArr;
        }
    }
    return model;
}

+ (SupermarketMineData *)getMineDataWithDic:(NSDictionary *)dic {
    SupermarketMineData *data = [[SupermarketMineData alloc] init];
    if (dic != nil) {
        data.header_url = dic[@"head_url"];
        data.mobile = dic[@"mobile"];
        data.coupons_count = dic[@"coupons_count"];
        data.point = dic[@"point"];
        data.collection_count = dic[@"collection_count"];
        
        NSArray *orders = dic[@"orders"];
        if (orders.count > 0) {
            for (NSDictionary *order in orders) {
                NSNumber *status = order[@"ONLINE_ORDER_STATUS"];
                if (status.integerValue == 1) {
                    data.waitPayCount = order[@"order_count"];
                }
                if (status.integerValue == 3) {
                    data.waitReceiveCount = order[@"order_count"];
                }
                if (status.integerValue == 5) {
                    data.waitCommentCount = order[@"order_count"];
                }
//                if (status.integerValue == 4) {
//                    data.waitReceiveCount = order[@"order_count"];
//                }
//                if (status.integerValue == 5) {
//                    data.waitPickCount = order[@"order_count"];
//                }
//                if (status.integerValue == 6) {
//                    data.waitCommentCount = order[@"order_count"];
//                }
            }
        }
    }
    return data;
}

//物流详情
+ (SupermarketExpressData *)getExpDataWithDic:(NSDictionary *)dic {
    SupermarketExpressData *data = [[SupermarketExpressData alloc] init];
    if (dic != nil) {
        data.bill = dic[@"bill"];
        data.count = dic[@"count"];
        data.mobile = dic[@"expMobile"];
        data.status = dic[@"status"];
        data.item_url = dic[@"item_url"];
        
        NSArray *expFollow = dic[@"expFollow"];
        if (expFollow.count > 0) {
            NSMutableArray *expressArray = @[].mutableCopy;
            for (NSDictionary *expressDic in expFollow) {
                SupermarketExpInfoData *info = [[SupermarketExpInfoData alloc] init];
                info.expDate = expressDic[@"expDate"];
                info.expLocation = expressDic[@"expLocation"];
                info.hasCurrent = expressDic[@"hasCurrent"];
                [expressArray addObject:info];
            }
            data.expFollow = expressArray;
        }
    }
    return data;
}

//退货详情
+ (SupermarketRefundData *)getRefundDataWithDic:(NSDictionary *)dic {
    SupermarketRefundData *data = [[SupermarketRefundData alloc] init];
    if (dic != nil) {
        data.refundBill = dic[@"refundBill"];
        data.refundPrice = dic[@"refundPrice"];
        data.refundType = dic[@"refundType"];
        data.status = dic[@"status"];
        data.submitDate = dic[@"submitDate"];
        
        NSArray *refundFollow = dic[@"refFollow"];
        if (refundFollow.count > 0) {
            NSMutableArray *progressArray = @[].mutableCopy;
            for (NSDictionary *refundInfo in refundFollow) {
                SupermarketRefundInfoData *infoData = [[SupermarketRefundInfoData alloc] init];
                infoData.hasCurrent = refundInfo[@"hasCurrent"];
                infoData.refundDate = refundInfo[@"refDate"];
                infoData.refundLocation = refundInfo[@"refLocation"];
                
                [progressArray addObject:infoData];
            }
            data.refundFollow = progressArray;
        }
    }
    return data;
}

+ (SupermarketKindModel *)getKindsModelWithDic:(NSDictionary *)dic {
    SupermarketKindModel *model = [[SupermarketKindModel alloc] init];
    if (dic != nil) {
        model.category_code = dic[@"category_code"];
        model.category_name = dic[@"category_name"];
        model.category_name_en = dic[@"category_name_en"];
        model.icon_url = dic[@"icon_url"];
        model.level = dic[@"level"];
    }
    return model;
}

//分类
+ (SupermarketHomePeopleLikeData *)getSupermarketKindsGoodListDataWithDic:(NSDictionary *)dic {
    SupermarketHomePeopleLikeData *data = [[SupermarketHomePeopleLikeData alloc] init];
    if (dic != nil) {
        data.item_code = dic[@"item_code"];
        data.item_quantity = dic[@"item_quantity"];
        data.item_price = dic[@"item_price"];
        data.imageUrl = dic[@"image_url"];
        data.item_name = dic[@"item_name"];
        data.stock_unit = dic[@"stock_unit"];
    }
    return data;
}

//检查订单
+ (CheckOrderModel *)getSupermarketCheckOrderModelWithDic:(NSDictionary *)dic {
    CheckOrderModel *model = [[CheckOrderModel alloc] init];
    if (dic != nil) {
        NSNumber *canUseCoupon = dic[@"canCoupons"];
        model.canUseCoupons = canUseCoupon.boolValue;
        
        NSNumber *canUsePoint = dic[@"canPoint"];
        model.canUsePoint = canUsePoint.boolValue;
        model.coupons = dic[@"coupons"];
        model.expressPrice = dic[@"expressAmount"];
        model.guid = dic[@"guid"];
        
        model.divCode = dic[@"divCode"];
        
        NSDictionary *pointOption = dic[@"pointOption"];
        NSArray *allKeys = pointOption.allKeys;
        if (allKeys.count > 0) {
            model.canMaxUsePoint = pointOption[@"canMaxPointAmount"];
            model.totalPoint = pointOption[@"totalPoint"];
        }
        model.price = dic[@"price"];
        model.totalPrice = dic[@"totalprice"];
     
        NSMutableArray *coupons = @[].mutableCopy;
        
        NSDictionary *couponsData = dic[@"coupons"];
        NSArray *canUseData = couponsData[@"mergeUsedCoupons"];
        if (canUseData.count > 0) {
            for (NSDictionary *couponDic in canUseData) {
                CouponModel *coupon = [NSDictionary getCouponModelWithDic:couponDic];
                coupon.couponID = couponDic[@"id"];
                [coupons addObject:coupon];
            }
        }
        
        NSArray *cantUseData = couponsData[@"mergeNotUsedCoupons"];
        NSMutableArray *cantUseCoupons = @[].mutableCopy;
        if (cantUseData.count > 0) {
            for (NSDictionary *couponDic in cantUseData) {
                CouponModel *coupon = [NSDictionary getCouponModelWithDic:couponDic];
                coupon.couponID = couponDic[@"id"];
                [cantUseCoupons addObject:coupon];
            }
        }
        model.coupons = coupons;
        model.cantUseCoupons = cantUseCoupons;
        
        NSArray *goodsRangeData = dic[@"goodsCategoryList"];
        NSMutableArray *ranges = @[].mutableCopy;
        if (goodsRangeData.count > 0) {
            for (NSDictionary *goodsRangeDic in goodsRangeData) {
                CheckOrderGoodsRange *range = [[CheckOrderGoodsRange alloc] init];
                range.range = goodsRangeDic[@"GoodsCategoryId"];
                range.totalPrice = goodsRangeDic[@"GoodsCategoryTotalAmount"];
                [ranges addObject:range];
            }
            model.goodsRanges = ranges;
        }
    }
    return model;
}

//option规格选择
+ (GoodsOptionModel *)getGoodsOptionModelWithDic:(NSDictionary *)dic {
    GoodsOptionModel *model = [[GoodsOptionModel alloc] init];
    if (dic != nil) {
        model.ID = dic[@"id"];
        model.good_code = dic[@"parent_item_code"];
        model.item_code = dic[@"sub_item_code"];
        model.item_name = dic[@"sub_item_name"];
        model.stock_unit = dic[@"sub_item_stock_unit"];
        model.optionType = dic[@"sub_item_option"];
        model.item_price = dic[@"sub_item_price"];
    }
    return model;
}

//优惠券
+ (CouponModel *)getCouponModelWithDic:(NSDictionary *)dic {
    CouponModel *model = [[CouponModel alloc] init];
    if (dic != nil) {
        model.couponType = ((NSNumber *)dic[@"coupon_type"]).integerValue;
        model.couponNumber = dic[@"coupon_no"];
        model.couponRange = dic[@"coupon_range"];
        model.couponRangeMsg = dic[@"coupon_range_remark"];
        model.couponName = dic[@"coupon_name"];
        model.createDate = dic[@"create_date"];
        model.startDate = dic[@"start_date"];
        model.endDate = dic[@"end_date"];
        model.receiveDate = dic[@"receive_date"];
        model.overMsg = dic[@"over_amount_remark"];
        model.overMoney = dic[@"over_amount"];
        model.upLimitMoney = dic[@"upper_limit_amount"];
        model.decent = dic[@"dc_amount"];
        model.platform = dic[@"platform"];
    }
    return model;
}

//积分
+ (SupermarketPointModel *)getPointModelWithDic:(NSDictionary *)dic {
    SupermarketPointModel *model = [[SupermarketPointModel alloc] init];
    if (dic != nil) {
        model.card_no = dic[@"card_no"];
        model.store_code = dic[@"store_code"];
        model.store_name = dic[@"store_name"];
        model.trade_date = dic[@"trade_date"];
        model.trade_money = dic[@"trade_money"];
        model.trade_type = dic[@"trade_type"];
    }
    return model;
}

//退款详情
+ (RefundDetailModel *)getRefundDetailModelWithDic:(NSDictionary *)dic {
    RefundDetailModel *model = [[RefundDetailModel alloc] init];
    if (dic != nil) {
        model.content = dic[@"OperateContent"];
        model.finished = dic[@"finished"];
        model.time = dic[@"OperateTime"];
        model.status = dic[@"Status"];
        model.stepStatus = dic[@"StatusMsg"];
        model.operateType = ((NSNumber *)dic[@"OperateType"]).integerValue;
    }
    return model;
}

//退款列表
+(RefundListData *)getRefundListDataWithDic:(NSDictionary *)dic {
    RefundListData *data = [[RefundListData alloc] init];
    if (dic != nil) {
        data.applyTime = dic[@"applyTime"];
        data.imageURl = dic[@"imageUrl"];
        data.item_name = dic[@"itemName"];
        data.refundNo = dic[@"refundNo"];
        data.itemCode = dic[@"itemCode"];
        data.orderNum = dic[@"orderNum"];
        data.status = ((NSNumber *)dic[@"status"]).integerValue;
    }
    return data;
}

+ (SupermarketRefundResaonModel *)getRefundReasonWithDic:(NSDictionary *)dic {
    SupermarketRefundResaonModel *model = [[SupermarketRefundResaonModel alloc] init];
    if (dic) {
        model.codeName = dic[@"code_name"];
        model.mainCode = dic[@"main_code"];
        model.subCode = dic[@"sub_code"];
    }
    return model;
}

+ (SupermarketOrderGoodsData *)getWaitCommentGoodsDataWithDic:(NSDictionary *)dic {
    SupermarketOrderGoodsData *data = [[SupermarketOrderGoodsData alloc] init];
    if (dic) {
        data.assess_stauts = dic[@"assess_status"];
        data.divCode = dic[@"div_code"];
        data.image_url = dic[@"image_url"];
        data.title = dic[@"item_name"];
        data.item_code = dic[@"item_code"];
        data.amount = dic[@"item_quantity"];
        data.stockUnit = dic[@"stock_unit"];
        data.price = dic[@"item_price"];
    }
    return data;
}

@end
