//
//  SupermarketCommentTableView.m
//  Portal
//
//  Created by ifox on 2016/12/17.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketCommentTableView.h"
#import "SupermarketCommentCell.h"
#import "SupermarketCommentData.h"

@interface SupermarketCommentTableView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation SupermarketCommentTableView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self registerClass:[SupermarketCommentCell class] forCellReuseIdentifier:@"Comment_Cell"];
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return 1;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SupermarketCommentCell *cell = [[SupermarketCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Comment_Cell"];
    cell.commentControllerType = self.commentControllerType;
    cell.commentData = self.dataArray[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SupermarketCommentData *data = self.dataArray[indexPath.section];
    
    if (self.commentControllerType == 0) {
        return data.height;
    } else {
        return data.height + 80;
    }
    
}

@end
