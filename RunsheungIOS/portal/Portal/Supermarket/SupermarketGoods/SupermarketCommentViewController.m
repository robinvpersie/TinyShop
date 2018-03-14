//
//  SupermarketCommentViewController.m
//  Portal
//
//  Created by 左梓豪 on 2016/12/8.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketCommentViewController.h"
#import "SupermarketCommentHeaderView.h"
#import "SupermarketCommentTableView.h"
#import "SupermarketCommentData.h"
#import "VirtualData.h"
#import "MJRefresh.h"

@interface SupermarketCommentViewController ()<SupermarketCommentHeaderViewDelegate>

@property(nonatomic, strong) SupermarketCommentHeaderView *header;
@property(nonatomic, strong) SupermarketCommentTableView *tableViewGood;
@property(nonatomic, strong) SupermarketCommentTableView *tableViewMid;
@property(nonatomic, strong) SupermarketCommentTableView *tableViewBad;
@property(nonatomic, strong) SupermarketCommentTableView *tableViewPic;
@property(nonatomic, strong) SupermarketCommentTableView *tableViewAll;
@property(nonatomic, strong) UIScrollView *mainScrollView;

@end

@implementation SupermarketCommentViewController {
    NSMutableArray *_allCommentArray;
    NSMutableArray *_goodCommentArray;
    NSMutableArray *_midCommentArray;
    NSMutableArray *_badCommentArray;
    NSMutableArray *_picsCommentArray;
    
    NSNumber *_allCount;
    NSNumber *_goodCount;
    NSNumber *_midCount;
    NSNumber *_badCount;
    NSNumber *_picsCount;
    
    NSInteger _allPageIndex;
    NSInteger _goodPageIndex;
    NSInteger _midPageIndex;
    NSInteger _badPageIndex;
    NSInteger _picPageIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BGColor;
    
    _allPageIndex = 1;
    _goodPageIndex = 1;
    _midPageIndex = 1;
    _badPageIndex = 1;
    _picPageIndex = 1;
    
    [self createHeader];
    
    [self createScrollView];
    
    [self createTableView];
    
    [self initDataArray];
    
    [self requestAllData];
    [self requestGoodData];
    [self requestMidData];
    [self requestBadData];
    [self requetPicsData];

    // Do any additional setup after loading the view.
}

- (void)createHeader {
    _header = [[SupermarketCommentHeaderView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 40)];
    _header.delegate = self;
    [self.view addSubview:_header];
}

- (void)createScrollView {
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, APPScreenWidth, APPScreenHeight - 150)];
    _mainScrollView.contentSize = CGSizeMake(APPScreenWidth*5, APPScreenHeight - 150);
    _mainScrollView.scrollEnabled = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
//    _mainScrollView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_mainScrollView];
}

- (void)createTableView {
    _tableViewAll = [[SupermarketCommentTableView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, APPScreenHeight - 155) style:UITableViewStyleGrouped];
    _tableViewAll.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _allPageIndex++;
        if (_allCommentArray.count < _allCount.integerValue) {
                [self requestAllData];
        } else {
            [_tableViewAll.mj_footer endRefreshingWithNoMoreData];
        }
        
    }];
    [_mainScrollView addSubview:_tableViewAll];
    
    _tableViewGood = [[SupermarketCommentTableView alloc] initWithFrame:CGRectMake(APPScreenWidth, 0, APPScreenWidth, APPScreenHeight - 155) style:UITableViewStyleGrouped];
    _tableViewGood.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _goodPageIndex++;
        if (_goodCommentArray.count < _goodCount.integerValue) {
           [self requestGoodData];
        } else {
            [_tableViewGood.mj_footer endRefreshingWithNoMoreData];
        }
        
    }];
    [_mainScrollView addSubview:_tableViewGood];
    
    _tableViewMid = [[SupermarketCommentTableView alloc] initWithFrame:CGRectMake(APPScreenWidth*2, 0, APPScreenWidth, APPScreenHeight - 155) style:UITableViewStyleGrouped];
    _tableViewMid.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _midPageIndex++;
        if (_midCommentArray.count < _midCount.integerValue) {
            [self requestMidData];
        } else {
            [_tableViewMid.mj_footer endRefreshingWithNoMoreData];
        }
        
    }];
    [_mainScrollView addSubview:_tableViewMid];
    
    _tableViewBad = [[SupermarketCommentTableView alloc] initWithFrame:CGRectMake(APPScreenWidth*3, 0, APPScreenWidth, APPScreenHeight - 155) style:UITableViewStyleGrouped];
    _tableViewBad.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _badPageIndex++;
        if (_badCommentArray.count < _badCount.integerValue) {
            [self requestBadData];
        } else {
            [_tableViewBad.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    [_mainScrollView addSubview:_tableViewBad];
    
    _tableViewPic = [[SupermarketCommentTableView alloc] initWithFrame:CGRectMake(APPScreenWidth*4, 0, APPScreenWidth, APPScreenHeight - 155) style:UITableViewStyleGrouped];
    _tableViewPic.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _picPageIndex++;
        if (_picsCommentArray.count < _picsCount.integerValue) {
            [self requetPicsData];
        } else {
            [_tableViewPic.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    [_mainScrollView addSubview:_tableViewPic];
}

- (void)initDataArray {
    _allCommentArray = @[].mutableCopy;
    _goodCommentArray = @[].mutableCopy;
    _midCommentArray = @[].mutableCopy;
    _badCommentArray = @[].mutableCopy;
    _picsCommentArray = @[].mutableCopy;
}

- (void)requestAllData {
    [KLHttpTool getSupermarketGoodsCommentWithUrl:nil itemCode:_item_code pageIndex:_allPageIndex pageSize:20 commentStatus:0 hasImage:NO divCode:self.divCode success:^(id response) {
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSDictionary *data = response[@"data"];
            NSArray *comments = data[@"comment_list"];
            if (comments.count > 0) {
                for (NSDictionary *dic in comments) {
                    SupermarketCommentData *data = [NSDictionary getCommentDataWithDic:dic];
                    [_allCommentArray addObject:data];
                }
            }
            _allCount = data[@"all_count"];
            _goodCount = data[@"good_count"];
            _midCount = data[@"middle_count"];
            _badCount = data[@"difference_count"];
            _picsCount = data[@"img_count"];
            
            [_tableViewAll.mj_footer endRefreshing];
            [self reloadUI];
        }
    } failure:^(NSError *err) {
        
    }];
}

- (void)requestGoodData {
    [KLHttpTool getSupermarketGoodsCommentWithUrl:nil itemCode:_item_code pageIndex:_goodPageIndex pageSize:_goodPageIndex commentStatus:1 hasImage:NO divCode:self.divCode success:^(id response) {
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSDictionary *data = response[@"data"];
            NSArray *comments = data[@"comment_list"];
            if (comments.count > 0) {
                for (NSDictionary *dic in comments) {
                    SupermarketCommentData *data = [NSDictionary getCommentDataWithDic:dic];
                    [_goodCommentArray addObject:data];
                }
            }
            [_tableViewGood.mj_footer endRefreshing];
            [self reloadUI];
        }
    } failure:^(NSError *err) {
        
    }];
}

- (void)requestMidData {
    [KLHttpTool getSupermarketGoodsCommentWithUrl:nil itemCode:_item_code pageIndex:_midPageIndex pageSize:20 commentStatus:2 hasImage:NO divCode:self.divCode success:^(id response) {
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSDictionary *data = response[@"data"];
            NSArray *comments = data[@"comment_list"];
            if (comments.count > 0) {
                for (NSDictionary *dic in comments) {
                    SupermarketCommentData *data = [NSDictionary getCommentDataWithDic:dic];
                    [_midCommentArray addObject:data];
                }
            }
            [_tableViewMid.mj_footer endRefreshing];
            [self reloadUI];
        }
    } failure:^(NSError *err) {
        
    }];
}

- (void)requestBadData {
    [KLHttpTool getSupermarketGoodsCommentWithUrl:nil itemCode:_item_code pageIndex:_badPageIndex pageSize:20 commentStatus:3 hasImage:NO divCode:self.divCode success:^(id response) {
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSDictionary *data = response[@"data"];
            NSArray *comments = data[@"comment_list"];
            if (comments.count > 0) {
                for (NSDictionary *dic in comments) {
                    SupermarketCommentData *data = [NSDictionary getCommentDataWithDic:dic];
                    [_badCommentArray addObject:data];
                }
            }
            [_tableViewBad.mj_footer endRefreshing];
            [self reloadUI];
        }
    } failure:^(NSError *err) {
        
    }];
}

- (void)requetPicsData {
    [KLHttpTool getSupermarketGoodsCommentWithUrl:nil itemCode:_item_code pageIndex:_picPageIndex pageSize:20 commentStatus:0 hasImage:YES divCode:self.divCode success:^(id response) {
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSDictionary *data = response[@"data"];
            NSArray *comments = data[@"comment_list"];
            if (comments.count > 0) {
                for (NSDictionary *dic in comments) {
                    SupermarketCommentData *data = [NSDictionary getCommentDataWithDic:dic];
                    [_picsCommentArray addObject:data];
                }
                
            }
            [_tableViewPic.mj_footer endRefreshing];
            [self reloadUI];
        }
    } failure:^(NSError *err) {
        
    }];
}

- (void)reloadUI {
    _tableViewAll.dataArray = _allCommentArray;
    _tableViewGood.dataArray = _goodCommentArray;
    _tableViewMid.dataArray = _midCommentArray;
    _tableViewBad.dataArray = _badCommentArray;
    _tableViewPic.dataArray = _picsCommentArray;
    
    _header.allCommentAmount = _allCount.stringValue;
    _header.goodCommentAmount = _goodCount.stringValue;
    _header.midCommentAmount = _midCount.stringValue;
    _header.badCommentAmount = _badCount.stringValue;
    _header.picCommentAmount = _picsCount.stringValue;
}

- (void)clickHeaderAtIndex:(NSInteger)index {
    NSLog(@"%ld",index);
    if (index == 0) {
        _mainScrollView.contentOffset = CGPointMake(0, 0);
    } else if (index == 1) {
        _mainScrollView.contentOffset = CGPointMake(APPScreenWidth, 0);
    } else if (index == 2) {
        _mainScrollView.contentOffset = CGPointMake(APPScreenWidth * 2, 0);
    } else if (index == 3) {
        _mainScrollView.contentOffset = CGPointMake(APPScreenWidth * 3, 0);
    } else if (index == 4) {
        _mainScrollView.contentOffset = CGPointMake(APPScreenWidth * 4, 0);
    }
}

- (void)setItem_code:(NSString *)item_code {
    _item_code = item_code;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
