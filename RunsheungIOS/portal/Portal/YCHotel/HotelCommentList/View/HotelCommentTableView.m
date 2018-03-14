//
//  HotelCommentTableView.m
//  Portal
//
//  Created by ifox on 2017/5/3.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "HotelCommentTableView.h"
#import "HotelCommentTableViewCell.h"
#import "HotelCommentModel.h"

@interface HotelCommentTableView ()<UITableViewDelegate, UITableViewDataSource, HotelCommentTableViewCellDeletage>

@property(nonatomic, strong) NSMutableArray *mutableDataArr;

@end

@implementation HotelCommentTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        _mutableDataArr = @[].mutableCopy;
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_mutableDataArr.count > 0) {
        HotelCommentModel *comment = _mutableDataArr[indexPath.row];
        if (comment.isExpanding) {
            return comment.height + 12;
        }
        return comment.height;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_mutableDataArr.count > 0) {
        return _mutableDataArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HotelCommentTableViewCell *cell = [[HotelCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.delegate = self;
    if (_mutableDataArr.count > 0) {
        HotelCommentModel *commentModel = _mutableDataArr[indexPath.row];
        cell.commentModel = commentModel;
    }
    return cell;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [_mutableDataArr removeAllObjects];
    [_mutableDataArr addObjectsFromArray:dataArray];
    [self reloadData];
}

- (void)hotelCommentReplyExpandingWithCell:(HotelCommentTableViewCell *)cell commentData:(HotelCommentModel *)commentData {
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    [_mutableDataArr replaceObjectAtIndex:indexPath.row withObject:commentData];
    [self reloadData];
}

@end
