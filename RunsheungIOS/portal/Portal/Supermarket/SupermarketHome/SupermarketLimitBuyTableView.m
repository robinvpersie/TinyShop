//
//  SupermarketLimitBuyTableView.m
//  Portal
//
//  Created by ifox on 2016/12/29.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketLimitBuyTableView.h"
#import "SupermarketLimitBuyCell.h"
#import "ProgressView.h"

@interface SupermarketLimitBuyTableView ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation SupermarketLimitBuyTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        UINib *nib = [UINib nibWithNibName:@"SupermarketLimitBuyCell" bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:@"SupermarketLimitBuyCell"];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SupermarketLimitBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SupermarketLimitBuyCell"];
    cell.progressView.progress = 0.5;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}


@end
