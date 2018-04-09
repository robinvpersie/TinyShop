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
#import "SPCommentModel.h"

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
    
  
    [self createView];
    [self requetDaata];
    // Do any additional setup after loading the view.
}

-(void)commonInit {
    self.dataArr = [NSMutableArray array];
    self.pageIndex = 1;
}

- (void)createView {
  

    self.myCommentTableView = [[SupermarketCommentTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.myCommentTableView.commentControllerType = CommentControllerTypeMine;
    __weak typeof(self) weakself = self;
    self.myCommentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakself.pageIndex++;
        if (weakself.dataArr.count < weakself.totalCount) {
            [weakself requetDaata];
        } else {
            [weakself.myCommentTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    [self.view addSubview:self.myCommentTableView];
    [self.myCommentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}



- (void)requetDaata {
    [KLHttpTool getMyCommentWithOffSet:self.pageIndex success:^(id response) {
        NSString *status = response[@"status"];
        if ([status isEqualToString:@"1"]) {
            NSArray *data = response[@"MyinfoAssesses"];
            for (NSDictionary *dic in data) {
                SPCommentModel *model = [[SPCommentModel alloc]initWithDic:dic];
                [self.dataArr addObject:model];
            }
            [_myCommentTableView.mj_footer endRefreshing];
            _myCommentTableView.dataArray = _dataArr;
        }
        
    } failure:^(NSError *err) {
        
    }];
    

}



@end
