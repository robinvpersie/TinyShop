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

- (instancetype)initWithFrame:(CGRect)frame withData:(NSMutableArray*)data;
@end
