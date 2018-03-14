//
//  SupermarketCommentTableView.h
//  Portal
//
//  Created by ifox on 2016/12/17.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CommentControllerType) {
    CommentControllerTypeGoods = 0,
    CommentControllerTypeMine,
};

@interface SupermarketCommentTableView : UITableView

@property(nonatomic, strong)NSArray *dataArray;
@property(nonatomic, assign)CommentControllerType commentControllerType;

@end
