//
//  WJItemView.h
//  WJIM_DOME
//
//  Created by 王五 on 2017/9/16.
//  Copyright © 2017年 王五. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WJClickItemsDelegate<NSObject>
@optional
//点击单个的项目响应
- (void)wjClickItems:(NSString*)item;

@end


@interface TSItemView : UIView
- (instancetype)initWithFrame:(CGRect)frame withData:(NSArray*)data;
//ItemsArr传过来的数据数组
@property (nonatomic,retain)NSArray*ItemsArr;

//rowWidth 记录行的总长度
@property (nonatomic,assign)float rowWidth;

//行数
@property (nonatomic,assign)NSInteger rows;

//item代理
@property (nonatomic,assign)id<WJClickItemsDelegate> wjitemdelegate;

@end
