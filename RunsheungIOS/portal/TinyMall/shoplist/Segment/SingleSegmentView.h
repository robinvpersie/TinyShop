//
//  SingleSegmentView.h
//  GigaProject
//
//  Created by dlwpdlr on 2018/3/14.
//  Copyright © 2018年 GIGA Korea. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SingleSegmentDelegate<NSObject>

- (void)clickUpItem:(NSString *)upitem;

- (void)clickUpSecItem:(NSMutableArray *)upsecitems;

- (void)clickUpThirdItem:(NSMutableArray *)upthirditems;



@end;

@interface SingleSegmentView : UIView
@property (nonatomic,retain)UIScrollView *scrollview;
@property (nonatomic,retain)UILabel *bottomLine;
@property (nonatomic,retain)UIColor *lineColor;
@property (nonatomic,retain)NSMutableArray *datas;
@property (nonatomic,retain)NSMutableArray *alldata;

@property (nonatomic,assign)int flag;
@property (nonatomic,assign)id<SingleSegmentDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame
					  withDic:(NSMutableArray*)alldata
					 withData:(NSMutableArray*)mutableArray
		  withLineBottomColor:(UIColor*)color
					 withflag:(int)flag;


@end
