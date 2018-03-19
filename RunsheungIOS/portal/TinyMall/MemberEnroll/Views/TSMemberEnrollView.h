//
//  TSMemberEnrollView.h
//  Portal
//
//  Created by dlwpdlr on 2018/3/17.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TSMemberDelegate<NSObject>
- (void)ClickTSMemberDelegate:(int)index;
@end;

@interface TSMemberEnrollView : UIView
@property(nonatomic,retain)NSArray *Sourcedata;

@property (nonatomic,assign)id<TSMemberDelegate> delegate;
@end
