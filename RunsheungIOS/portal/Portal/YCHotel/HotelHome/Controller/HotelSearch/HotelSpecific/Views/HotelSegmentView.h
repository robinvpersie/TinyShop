//
//  HotelSegmentView.h
//  Portal
//
//  Created by 王五 on 2017/4/10.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SegmentDelegate <NSObject>
@optional
- (void)scrollToPage:(int)page;
@end

@interface HotelSegmentView : UIView {
    id <SegmentDelegate> delegate;
}

@property (nonatomic,retain) id <SegmentDelegate> delegate;

@property(nonatomic, assign) CGFloat maxWidth;
@property(nonatomic,strong)NSMutableArray *titleList;
@property(nonatomic,strong)NSMutableArray *buttonList;
@property(nonatomic,weak)CALayer *LGLayer;
@property(nonatomic,assign)CGFloat bannerNowX;

+ (instancetype)initWithTitleList:(NSMutableArray *)titleList;
-(id)initWithTitleList:(NSMutableArray*)titleList;
-(void)moveToOffsetX:(CGFloat)X;

@end
