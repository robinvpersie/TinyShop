//
//  ChoiceHeadView.h
//  GigaProject
//
//  Created by dlwpdlr on 2018/3/8.
//  Copyright © 2018年 GIGA Korea. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ShowActionBlock)();

@interface ChoiceHeadView : UIView

@property (nonatomic, copy) ShowActionBlock showAction;

@end
