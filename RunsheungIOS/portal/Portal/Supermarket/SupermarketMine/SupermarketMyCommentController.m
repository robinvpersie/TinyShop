//
//  SupermarketMyCommentController.m
//  Portal
//
//  Created by ifox on 2017/7/20.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "SupermarketMyCommentController.h"
#import "SupermarketCommentTableView.h"
#import "MJRefresh.h"
#import "SupermarketCommentData.h"

@interface SupermarketMyCommentController ()

@property(nonatomic, strong) SupermarketCommentTableView *myCommentTableView;
@property(nonatomic, assign) NSInteger pageIndex;
@property(nonatomic, strong) NSMutableArray *dataArr;;
@property(nonatomic, assign) NSInteger totalCount;

@end

@implementation SupermarketMyCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"SMMineMyComment", nil);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _dataArr = @[].mutableCopy;
    _pageIndex = 1;
    
    [self createView];
    
    [self requetDaata];
    // Do any additional setup after loading the view.
}

- (void)createView {
    _myCommentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _pageIndex++;
        if (_dataArr.count < _totalCount) {
            [self requetDaata];
        } else {
            [_myCommentTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];

    
    [self.view addSubview:self.myCommentTableView];
}

- (void)requetDaata {
    [KLHttpTool getMyCommentListWithPageInde:_pageIndex success:^(id response) {
        NSLog(@"%@",response);
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSArray *data = response[@"data"];
            if (data.count > 0) {
                for (NSDictionary *dic in data) {
                    SupermarketCommentData *data = [NSDictionary getCommentDataWithDic:dic];
                    [_dataArr addObject:data];
                }
                 [_myCommentTableView.mj_footer endRefreshing];
                _myCommentTableView.dataArray = _dataArr;
            }
        }
    } failure:^(NSError *err) {
        
    }];
}

- (SupermarketCommentTableView *)myCommentTableView {
    if (_myCommentTableView == nil) {
        _myCommentTableView = [[SupermarketCommentTableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _myCommentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _myCommentTableView.commentControllerType = CommentControllerTypeMine;
    }
    return _myCommentTableView;
}

@end
