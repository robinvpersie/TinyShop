//
//  HotelSearchChooseLocationView.m
//  Portal
//
//  Created by ifox on 2017/4/7.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelSearchChooseLocationView.h"

#define BottomHeigh 50

@interface HotelSearchChooseLocationView ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *leftTableView;
@property(nonatomic, strong) UITableView *rightTableView;

@end

@implementation HotelSearchChooseLocationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createTableView];
    }
    return self;
}

- (void)createTableView {
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth/3, self.frame.size.height - BottomHeigh) style:UITableViewStylePlain];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    [self addSubview:_leftTableView];
    
    _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(APPScreenWidth/3, 0, APPScreenWidth/3*2, _leftTableView.frame.size.height) style:UITableViewStylePlain];
    _rightTableView.dataSource = self;
    _rightTableView.delegate = self;
    [self addSubview:_rightTableView];
}

@end
