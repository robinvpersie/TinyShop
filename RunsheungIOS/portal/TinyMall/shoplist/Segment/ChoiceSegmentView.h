//
//  ChoiceSegmentView.h
//  GigaProject
//
//  Created by dlwpdlr on 2018/3/8.
//  Copyright © 2018年 GIGA Korea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleSegmentView.h"
#import "SegmentItem.h"



@interface ChoiceSegmentView : UIView<SingleSegmentDelegate>
@property (nonatomic,retain)SingleSegmentView *SingleSegment;

@property (nonatomic,retain)SingleSegmentView *SingleSegmentSecond;

@property (nonatomic,retain)SegmentItem *SegmentItem;

@property (nonatomic,retain)NSMutableArray *dataArray;



- (instancetype)initWithFrame:(CGRect)frame withData:(NSMutableArray*)data;
@end
