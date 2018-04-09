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
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "SPCommentModel.h"
#import "UILabel+WidthAndHeight.h"

#define LabelWidth APPScreenWidth - 15 - 10


@interface SupermarketCommentTableView ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource>

@end

@implementation SupermarketCommentTableView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self registerClass:[SupermarketCommentCell class] forCellReuseIdentifier:@"Comment_Cell"];
        self.dataSource = self;
        self.delegate = self;
        self.emptyDataSetSource = self;
        self.tableFooterView = [[UIView alloc] init];
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
    cell.model = self.dataArray[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SPCommentModel *data = self.dataArray[indexPath.section];
    CGFloat contentHeight = [UILabel getHeightByWidth:LabelWidth title:data.saleContent font:[UIFont systemFontOfSize:14]];
    return  contentHeight + 105;
    

    
}

-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return  [[NSAttributedString alloc] initWithString:@"현재 평가가 없습니다"];
}

@end
