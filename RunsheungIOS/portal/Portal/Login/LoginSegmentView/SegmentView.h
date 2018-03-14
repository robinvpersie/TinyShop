//
//  SegmentView.h
//  Portal
//
//  Created by zhengzeyou on 2017/12/27.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SegmentDelegate<NSObject>

- (void)click:(int)tag;

@end
@interface SegmentView : UIView


@property (nonatomic,assign) id<SegmentDelegate>delegate;
@property (nonatomic,assign) float disoffx;

@end
