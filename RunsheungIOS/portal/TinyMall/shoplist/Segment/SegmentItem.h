//
//  SegmentItem.h
//  GigaProject
//
//  Created by dlwpdlr on 2018/3/14.
//  Copyright © 2018年 GIGA Korea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentItem : UIView

@property (nonatomic,retain)NSMutableArray *dataArray;
@property (nonatomic,retain)NSMutableArray *buttonArray;
- (instancetype)initWithFrame:(CGRect)frame;
@end
