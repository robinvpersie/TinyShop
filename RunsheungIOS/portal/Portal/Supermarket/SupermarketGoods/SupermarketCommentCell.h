//
//  SupermarketCommentCell.h
//  Portal
//
//  Created by ifox on 2016/12/17.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupermarketCommentData.h"
#import "SupermarketCommentTableView.h"
#import "SPCommentModel.h"

@interface SupermarketCommentCell : UITableViewCell

@property(nonatomic, strong) SupermarketCommentData *commentData;
@property(nonatomic, strong) SPCommentModel *model;
@property(nonatomic, assign)CommentControllerType commentControllerType;

@end
