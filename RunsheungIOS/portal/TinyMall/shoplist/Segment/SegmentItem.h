//
//  SegmentItem.h
//  GigaProject
//
//  Created by dlwpdlr on 2018/3/14.
//  Copyright © 2018年 GIGA Korea. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SegmentItemDelegate<NSObject>

- (void)clickSegment:(int)index;
@end;
@interface SegmentItem : UIView

@property (nonatomic,retain)NSMutableArray *dataArray;
@property (nonatomic,retain)NSMutableArray *buttonArray;

@property (nonatomic,assign)id<SegmentItemDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame;
@end
