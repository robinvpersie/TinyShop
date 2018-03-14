//
//  KLTabOnlineVideoView.h
//  Portal
//
//  Created by PENG LIN on 2017/1/16.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLTabOnlineVideoView : UIView

@property (nonatomic,copy) void (^afterHideAction)(int);

-(void)showInView:(UIView *)view;

@end
