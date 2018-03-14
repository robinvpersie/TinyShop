//
//  IntergrationTableView.m
//  Portal
//
//  Created by ifox on 2017/1/9.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "IntergrationTableView.h"
#import "IntergrationTableViewCell.h"

@interface IntergrationTableView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation IntergrationTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        UINib *nib = [UINib nibWithNibName:@"IntergrationTableViewCell" bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:@"IntergrationTableViewCell"];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return self;
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    [self reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataArr.count > 0) {
        return _dataArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IntergrationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IntergrationTableViewCell"];
    if (_dataArr.count > 0) {
    cell.pointModel = _dataArr[indexPath.row];    
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

@end
