//
//  ChoiceSegmentView.h
//  GigaProject
//
//  Created by dlwpdlr on 2018/3/8.
//  Copyright © 2018年 GIGA Korea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleSegmentView.h"

@protocol ChoiceDelegate<NSObject>

- (void)ChoiceDelegateaction:(NSString *)lev2;
@end;

@interface ChoiceSegmentView : UIView<SingleSegmentDelegate>

@property (nonatomic,retain)SingleSegmentView *SingleSegment;

@property (nonatomic,retain)SingleSegmentView *SingleSegmentSecond;

@property (nonatomic,retain)NSMutableDictionary *dataDic;

@property (nonatomic,retain)NSMutableDictionary *responseDic;

@property (nonatomic,assign)id<ChoiceDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame
					 withData:(NSMutableDictionary*)dict
				 withresponse:(NSDictionary*)response ;
@end
