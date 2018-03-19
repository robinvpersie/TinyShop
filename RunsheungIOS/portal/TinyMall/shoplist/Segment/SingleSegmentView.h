//
//  SingleSegmentView.h
//  GigaProject
//
//  Created by dlwpdlr on 2018/3/14.
//  Copyright © 2018年 GIGA Korea. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SingleSegmentDelegate<NSObject>

- (void)clickItem:(NSString*)item;
@end;

@interface SingleSegmentView : UIView
@property (nonatomic,retain)UIScrollView *scrollview;
@property (nonatomic,retain)UILabel *bottomLine;
@property (nonatomic,retain)UIColor *lineColor;
@property (nonatomic,retain)NSMutableArray *datas;

@property (nonatomic,assign)id<SingleSegmentDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame
					  withdata:(NSMutableArray*)alldata
		  withLineBottomColor:(UIColor*)color;


@end
