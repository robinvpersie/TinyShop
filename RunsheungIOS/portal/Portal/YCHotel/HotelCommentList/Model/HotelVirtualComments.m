//
//  HotelVirtualComments.m
//  Portal
//
//  Created by ifox on 2017/5/3.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelVirtualComments.h"
#import "HotelCommentModel.h"

@implementation HotelVirtualComments

+ (NSArray *)getHotelComments {
    
    HotelCommentModel *comment0 = [[HotelCommentModel alloc] init];
    comment0.userName = @"Jakkeee";
    comment0.score = 4.2;
    comment0.commentTime = @"2017-03-04";
    comment0.content = @"我国的人民币背面的私章并不是某个行长私人的名章,而是行长这个职位的章,也就是说谁在行长的位置上谁就对持有人民币的人负责.";
    comment0.roomTypeName = @"高级大床房";
    comment0.hotelReply = @"感谢您的光临,欢迎下次再来,傻逼.涉谷崩坏之后的一年，秋叶原RADIO会馆的大厦楼顶上坠落了人工卫星的新闻闹得沸沸扬扬.";
    comment0.isExpanding = NO;
    comment0.images = @[];
    
    HotelCommentModel *comment1 = [[HotelCommentModel alloc] init];
    comment1.userName = @"董大哥";
    comment1.score = 5.0;
    comment1.commentTime = @"2017-03-02";
    comment1.content = @"和女朋友在酒店啪啪啪很开心,还提供了免费的TT.下面上一些和女朋友的福利.";
    comment1.roomTypeName = @"总统套房";
    comment1.hotelReply = @"感谢您的光临,欢迎下次再来.";
    comment1.isExpanding = NO;
    comment1.images = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1493800348763&di=5b9e5c68914e0042152ea6a35b772e8c&imgtype=0&src=http%3A%2F%2Fn.sinaimg.cn%2Fgames%2Ftransform%2F20161012%2FYzBU-fxwrhpn9758439.jpg",
                        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1493800386885&di=25090f4cf84a3fd30d8de1d29f5adbb7&imgtype=0&src=http%3A%2F%2Fr3.ykimg.com%2F05410408538E9B3C6A0A4C046A2BD4B0",
                        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1493800413953&di=c8bba263ed2351a26c60c070cc2495b0&imgtype=0&src=http%3A%2F%2Fimg1.gtimg.com%2Fcomic%2Fpics%2Fhv1%2F108%2F43%2F2168%2F140985273.jpg",
                        @"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1493863408&di=df5cb7feb8690e50a208e5516a44d187&src=http://n.sinaimg.cn/games/transform/20160809/yXXs-fxutfpc4886475.jpg"];
    
    HotelCommentModel *comment2 = [[HotelCommentModel alloc] init];
    comment2.userName = @"狗腹肌";
    comment2.score = 3.2;
    comment2.commentTime = @"2017-03-04";
    comment2.content = @"不知道为什么看着有点爽周日给力更新,依然有小编带来的内涵搞笑福利动态图,不知道为什么看着有点爽!喜欢就收藏本站";
    comment2.roomTypeName = @"惊喜水床房";
    comment2.hotelReply = @"";
    comment2.isExpanding = NO;
    comment2.images = @[];
    

    return @[comment0,comment1,comment2,comment1,comment2,comment0];
}

@end
