//
//  SingleSegmentView.h
//  GigaProject
//
//  Created by dlwpdlr on 2018/3/14.
//  Copyright © 2018年 GIGA Korea. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SingleSegmentDelegate<NSObject>

- (void)clickItem:(NSString*)itemIndex;
- (void)clickItemsec:(NSString*)itemIndex;
@end;

@interface SingleSegmentView : UIView
@property (nonatomic,retain)UIScrollView *scrollview;
@property (nonatomic,retain)UILabel *bottomLine;
@property (nonatomic,retain)UIColor *lineColor;
@property (nonatomic,retain)NSDictionary *alldit;
@property (nonatomic,retain)NSArray *showarray;
@property (nonatomic,assign)id<SingleSegmentDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame
					  withdit:(NSDictionary*)alldit
					 withData:(NSArray*)showarray
		  withLineBottomColor:(UIColor*)color;


@end
