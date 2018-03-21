//
//  TinyShopDetailedView.h
//  Portal
//
//  Created by dlwpdlr on 2018/3/20.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DetailedDelegate<NSObject>
- (void)clickSegment:(int)index;
@end;

@interface TinyShopDetailedView : UIView

@property (nonatomic,retain)UIView  *backView;

@property (nonatomic,assign)id<DetailedDelegate> delegete;
@property(nonatomic,retain)NSDictionary *dic;
@end

