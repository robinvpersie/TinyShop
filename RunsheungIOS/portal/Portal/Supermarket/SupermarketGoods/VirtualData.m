//
//  VirtualData.m
//  Portal
//
//  Created by ifox on 2016/12/17.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "VirtualData.h"
#import "SupermarketCommentData.h"

@implementation VirtualData

+ (NSArray *)getVirtualData {
    SupermarketCommentData *data_0 = [[SupermarketCommentData alloc] init];
    data_0.rating = 0.2;
    data_0.type = ContentOnly;
    data_0.content = @"在比赛进行的时候，阿根廷全国几乎陷入了停顿状态。";
    
    SupermarketCommentData *data_1 = [[SupermarketCommentData alloc] init];
    data_1.rating = 0.6;
    data_1.type = ContentWithImages;
    data_1.content = @"小鸟游六花日本轻小说改编的动画《中二病也要谈恋爱》系列中的女主角[1-2]  。富樫勇太的同班同学兼女朋友。父亲的突然离世，令她至今无法接受这个事实。正在她最痛苦无助的时候，遇上了中二的富樫勇太。她相信父亲在“不可视境界线”另端的平行世界，为寻找“不可视境界线”而患上中二病";
    
    SupermarketCommentData *data_2 = [[SupermarketCommentData alloc] init];
    data_2.rating = 0.8;
    data_2.content = @"顽皮狗（Naughty Dog）是一家全球知名的电子游戏开发工作室，创建于1984年，前身为果酱软件，现为索尼公司旗下全资子公司，隶属于索尼全球工作室。";
    
    SupermarketCommentData *data_3 = [[SupermarketCommentData alloc] init];
    data_3.rating = 1.0;
    data_3.type = ContentWithImages;
    data_3.content = @"阿万音铃羽（あまね すずは，Amane Suzuha）日本ACG作品《命运石之门》的主要角色之一。2017年9月27日出生，O型血。在α世界线中是一名在未来道具研究所楼下的“映像管工房”打零工的元气少女，热爱山地车与映像管。";
    
    SupermarketCommentData *data_4 = [[SupermarketCommentData alloc] init];
    data_4.rating = 0.4;
    data_4.type = ContentOnly;
    data_4.content = @"《斩·赤红之瞳！》是由タカヒロ原作、田代哲也作画的漫画，于《月刊GANGAN JOKER》2010年4月号开始连载。2014年1月在《月刊GANGAN JOKER》杂志封面上公布了TV动画化的消息。电视动画由WHITE FOX制作，于2014年7月6日开始放送。";
    
    return @[data_0, data_1, data_2, data_3, data_4];
}

+ (NSArray *)getGoodVirtualData {
    SupermarketCommentData *data_0 = [[SupermarketCommentData alloc] init];
    data_0.rating = 0.8;
    data_0.type = ContentOnly;
    data_0.content = @"在比赛进行的时候，阿根廷全国几乎陷入了停顿状态。";
    
    SupermarketCommentData *data_1 = [[SupermarketCommentData alloc] init];
    data_1.rating = 1.0;
    data_1.type = ContentWithImages;
    data_1.content = @"小鸟游六花日本轻小说改编的动画《中二病也要谈恋爱》系列中的女主角[1-2]  。富樫勇太的同班同学兼女朋友。父亲的突然离世，令她至今无法接受这个事实。正在她最痛苦无助的时候，遇上了中二的富樫勇太。她相信父亲在“不可视境界线”另端的平行世界，为寻找“不可视境界线”而患上中二病";
    
    SupermarketCommentData *data_2 = [[SupermarketCommentData alloc] init];
    data_2.rating = 0.8;
    data_2.content = @"顽皮狗（Naughty Dog）是一家全球知名的电子游戏开发工作室，创建于1984年，前身为果酱软件，现为索尼公司旗下全资子公司，隶属于索尼全球工作室。";
    
    SupermarketCommentData *data_3 = [[SupermarketCommentData alloc] init];
    data_3.rating = 1.0;
    data_3.type = ContentWithImages;
    data_3.content = @"阿万音铃羽（あまね すずは，Amane Suzuha）日本ACG作品《命运石之门》的主要角色之一。2017年9月27日出生，O型血。在α世界线中是一名在未来道具研究所楼下的“映像管工房”打零工的元气少女，热爱山地车与映像管。";
    
    SupermarketCommentData *data_4 = [[SupermarketCommentData alloc] init];
    data_4.rating = 1.0;
    data_4.type = ContentOnly;
    data_4.content = @"《斩·赤红之瞳！》是由タカヒロ原作、田代哲也作画的漫画，于《月刊GANGAN JOKER》2010年4月号开始连载。2014年1月在《月刊GANGAN JOKER》杂志封面上公布了TV动画化的消息。电视动画由WHITE FOX制作，于2014年7月6日开始放送。";
    
    return @[data_4, data_3, data_2, data_3, data_4];

}

+ (NSArray *)getMidData {
    SupermarketCommentData *data_0 = [[SupermarketCommentData alloc] init];
    data_0.rating = 0.6;
    data_0.type = ContentOnly;
    data_0.content = @"在比赛进行的时候，阿根廷全国几乎陷入了停顿状态。";
    
    SupermarketCommentData *data_1 = [[SupermarketCommentData alloc] init];
    data_1.rating = 0.6;
    data_1.type = ContentWithImages;
    data_1.content = @"小鸟游六花日本轻小说改编的动画《中二病也要谈恋爱》系列中的女主角[1-2]  。富樫勇太的同班同学兼女朋友。父亲的突然离世，令她至今无法接受这个事实。正在她最痛苦无助的时候，遇上了中二的富樫勇太。她相信父亲在“不可视境界线”另端的平行世界，为寻找“不可视境界线”而患上中二病";
    
    SupermarketCommentData *data_2 = [[SupermarketCommentData alloc] init];
    data_2.rating = 0.6;
    data_2.content = @"顽皮狗（Naughty Dog）是一家全球知名的电子游戏开发工作室，创建于1984年，前身为果酱软件，现为索尼公司旗下全资子公司，隶属于索尼全球工作室。";
    
    SupermarketCommentData *data_3 = [[SupermarketCommentData alloc] init];
    data_3.rating = 0.6;
    data_3.type = ContentWithImages;
    data_3.content = @"阿万音铃羽（あまね すずは，Amane Suzuha）日本ACG作品《命运石之门》的主要角色之一。2017年9月27日出生，O型血。在α世界线中是一名在未来道具研究所楼下的“映像管工房”打零工的元气少女，热爱山地车与映像管。";
    
    SupermarketCommentData *data_4 = [[SupermarketCommentData alloc] init];
    data_4.rating = 0.6;
    data_4.type = ContentOnly;
    data_4.content = @"《斩·赤红之瞳！》是由タカヒロ原作、田代哲也作画的漫画，于《月刊GANGAN JOKER》2010年4月号开始连载。2014年1月在《月刊GANGAN JOKER》杂志封面上公布了TV动画化的消息。电视动画由WHITE FOX制作，于2014年7月6日开始放送。";
    
    return @[data_3,data_0,data_4, data_3, data_2, data_3, data_4];
}

+ (NSArray *)getBadData {
    SupermarketCommentData *data_0 = [[SupermarketCommentData alloc] init];
    data_0.rating = 0.2;
    data_0.type = ContentOnly;
    data_0.content = @"在比赛进行的时候，阿根廷全国几乎陷入了停顿状态。";
    
    SupermarketCommentData *data_1 = [[SupermarketCommentData alloc] init];
    data_1.rating = 0.2;
    data_1.type = ContentWithImages;
    data_1.content = @"小鸟游六花日本轻小说改编的动画《中二病也要谈恋爱》系列中的女主角[1-2]  。富樫勇太的同班同学兼女朋友。父亲的突然离世，令她至今无法接受这个事实。正在她最痛苦无助的时候，遇上了中二的富樫勇太。她相信父亲在“不可视境界线”另端的平行世界，为寻找“不可视境界线”而患上中二病";
    
    SupermarketCommentData *data_2 = [[SupermarketCommentData alloc] init];
    data_2.rating = 0.4;
    data_2.content = @"顽皮狗（Naughty Dog）是一家全球知名的电子游戏开发工作室，创建于1984年，前身为果酱软件，现为索尼公司旗下全资子公司，隶属于索尼全球工作室。";
    
    SupermarketCommentData *data_3 = [[SupermarketCommentData alloc] init];
    data_3.rating = 0.2;
    data_3.type = ContentWithImages;
    data_3.content = @"阿万音铃羽（あまね すずは，Amane Suzuha）日本ACG作品《命运石之门》的主要角色之一。2017年9月27日出生，O型血。在α世界线中是一名在未来道具研究所楼下的“映像管工房”打零工的元气少女，热爱山地车与映像管。";
    
    SupermarketCommentData *data_4 = [[SupermarketCommentData alloc] init];
    data_4.rating = 0.4;
    data_4.type = ContentOnly;
    data_4.content = @"《斩·赤红之瞳！》是由タカヒロ原作、田代哲也作画的漫画，于《月刊GANGAN JOKER》2010年4月号开始连载。2014年1月在《月刊GANGAN JOKER》杂志封面上公布了TV动画化的消息。电视动画由WHITE FOX制作，于2014年7月6日开始放送。";
    
    return @[data_0,data_2,data_4, data_3, data_2, data_3, data_4];

}

@end
