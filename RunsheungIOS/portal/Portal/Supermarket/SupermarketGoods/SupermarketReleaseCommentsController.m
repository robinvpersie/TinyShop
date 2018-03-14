//
//  SupermarketReleaseCommentsController.m
//  Portal
//
//  Created by ifox on 2017/2/24.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "SupermarketReleaseCommentsController.h"
#import "SupermarketMyOrderGoodListView.h"
#import "SupermarketReleaseCommentController.h"
#import "SupermarketOrderGoodsData.h"

@interface SupermarketReleaseCommentsController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong) UITableView *goodsTableView;

@end

@implementation SupermarketReleaseCommentsController {
    NSMutableArray *_dataArr;
}

- (UITableView *)goodsTableView {
    if (_goodsTableView == nil) {
        _goodsTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _goodsTableView.dataSource = self;
        _goodsTableView.delegate = self;
    }
    return _goodsTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"SMCommentGoodsTitle", nil);
    self.view.backgroundColor = BGColor;
    [self.view addSubview:self.goodsTableView];
    
    _dataArr = @[].mutableCopy;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:ReloadWaitCommentGoodsNotification object:nil];
    
    [self requestData];
}


- (void)requestData {
    [_dataArr removeAllObjects];
    [KLHttpTool supermarketGetWaitCommentsGoodsWithOrderID:self.data.order_code success:^(id response) {
        NSLog(@"%@",response);
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSArray *data = response[@"data"];
            if (data.count > 0) {
                for (NSDictionary *dic in data) {
                    SupermarketOrderGoodsData *data = [NSDictionary getWaitCommentGoodsDataWithDic:dic];
                    [_dataArr addObject:data];
                }
                _waitCommentGoodsArr = _dataArr;
                [_goodsTableView reloadData];
            }
        }
    } failure:^(NSError *err) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if (_data != nil) {
//        return _data.goodList.count;
//    }
    if (_waitCommentGoodsArr != nil) {
        return _waitCommentGoodsArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.backgroundColor = [UIColor whiteColor];
    SupermarketMyOrderGoodListView *goodListView = [[SupermarketMyOrderGoodListView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 110)];
//    goodListView.goodsListArray = @[_data.goodList[indexPath.section]];
    goodListView.goodsListArray = @[_waitCommentGoodsArr[indexPath.section]];
    [cell.contentView addSubview:goodListView];
    
    UIButton *comment = [UIButton buttonWithType:UIButtonTypeCustom];
    comment.frame = CGRectMake(APPScreenWidth - 80 - 15, CGRectGetMaxY(goodListView.frame)+10, 80, 25);
    [comment setTitle:NSLocalizedString(@"SMCommentButtonTitle", nil) forState:UIControlStateNormal];
    comment.layer.cornerRadius = 2.0f;
    comment.titleLabel.font = [UIFont systemFontOfSize:15];
    [comment setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    comment.layer.borderColor = [UIColor redColor].CGColor;
    comment.layer.borderWidth = 1.0f;
    [comment addTarget:self action:@selector(goReleaseComment:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:comment];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110 + 10+10+25;
}

- (void)goReleaseComment:(UIButton *)button {
    UIView *view = button.superview.superview;
    if ([view isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell *cell = (UITableViewCell *)view;
        NSIndexPath *indexPath = [_goodsTableView indexPathForCell:cell];
        NSInteger section = indexPath.section;
        SupermarketReleaseCommentController *releaseComment = [[SupermarketReleaseCommentController alloc] init];
//        releaseComment.index = section;
        releaseComment.orderData = _data;
        releaseComment.goodsData = _dataArr[section];
        if (_dataArr.count == 1) {
            releaseComment.isLastOne = YES;
        }
        [self.navigationController pushViewController:releaseComment animated:YES];
    }
}


@end
