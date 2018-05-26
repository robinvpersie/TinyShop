//
//  arrowBtn.h
//  Portal
//
//  Created by dlwpdlr on 2018/5/26.
//  Copyright © 2018年 linpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface arrowBtn : UIButton<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain)NSArray *data;
@property (nonatomic,retain)UITableView *popTableView;
@property (nonatomic,retain)UIView *cover;
@property (nonatomic,retain)UILabel *value;

- (instancetype)initWithFrame:(CGRect)frame ;
@end
