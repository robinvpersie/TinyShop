//
//  ShowLocationView.h
//  Portal
//
//  Created by 이정구 on 2018/3/19.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowLocationView : UIView

@property (nonatomic, copy) void(^location)();
@property (nonatomic, copy) void(^map)();

@end
