//
//  FirstMoreViewController.h
//  Portal
//
//  Created by dlwpdlr on 2018/3/17.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import "TSBaseViewController.h"

typedef void(^choiceOkBlock)(NSString *selectItem);

@interface TSFirstMoreViewController : TSBaseViewController

@property(nonatomic,copy)choiceOkBlock choiceBlock;

@property(nonatomic,copy)NSString *level1;
@end
