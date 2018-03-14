//
//  StarView.h
//  WXMovie
//
//  Created by wei.chen on 15/8/7.
//  Copyright (c) 2015年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StarView : UIView
{
    
    //子视图
    UIView *_yelloView;   //金色星星
    UIView *_grayView;    //灰色星星
}

//数据
@property(nonatomic,assign)CGFloat rating;  //评分

@end
