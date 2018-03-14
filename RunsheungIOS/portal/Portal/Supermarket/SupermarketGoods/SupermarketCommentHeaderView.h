//
//  SupermarketCommentHeaderView.h
//  Portal
//
//  Created by ifox on 2016/12/17.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SupermarketCommentHeaderViewDelegate <NSObject>

- (void)clickHeaderAtIndex:(NSInteger)index;

@end

@interface SupermarketCommentHeaderView : UIView

@property(nonatomic, weak) id<SupermarketCommentHeaderViewDelegate> delegate;

@property(nonatomic, copy) NSString *allCommentAmount;
@property(nonatomic, copy) NSString *goodCommentAmount;
@property(nonatomic, copy) NSString *midCommentAmount;
@property(nonatomic, copy) NSString *badCommentAmount;
@property(nonatomic, copy) NSString *picCommentAmount;

@end
