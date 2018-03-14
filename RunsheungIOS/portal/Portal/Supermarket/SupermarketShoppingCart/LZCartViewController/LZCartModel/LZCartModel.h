//
//  LZCartModel.h
//  LZCartViewController
//
//  Created by LQQ on 16/5/18.
//  Copyright © 2016年 LQQ. All rights reserved.
//  https://github.com/LQQZYY/CartDemo
//  http://blog.csdn.net/lqq200912408
//  QQ交流: 302934443

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LZCartModel : NSObject
//自定义模型时,这三个属性必须有
@property (nonatomic,assign) BOOL select;
@property (nonatomic,assign) BOOL isEditing;

@property (nonatomic,assign) NSInteger number;
@property (nonatomic,copy) NSString *price;
//下面的属性可根据自己的需求修改
@property (nonatomic,copy) NSString *sizeStr;
@property (nonatomic,copy) NSString *nameStr;
@property (nonatomic,copy) NSString *dateStr;
@property (nonatomic,retain)UIImage *image;
@property (nonatomic, copy) NSString *divCode;
@property (nonatomic, copy) NSString *divName;

@property (nonatomic, copy) NSString *ID;

@property(nonatomic, copy) NSString *item_code;
@property(nonatomic, copy) NSString *image_url;
@property(nonatomic, copy) NSString *stock_unit;
@property(nonatomic, copy) NSString *ver;

@end
