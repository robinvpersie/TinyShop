//
//  OutIntergrationController.m
//  Portal
//
//  Created by ifox on 2017/1/9.
//  Copyright © 2017年 linpeng. All rights reserved.
//

#import "OutIntergrationController.h"
#import "IntergrationTableView.h"
#import "SupermarketPointModel.h"
#import "UILabel+CreateLabel.h"
#import <MJRefresh/MJRefresh.h>

@interface OutIntergrationController ()

@property(nonatomic, strong) NSMutableArray *pointsArr;

@end

@implementation OutIntergrationController {
    IntergrationTableView *tableview;
    NSInteger _pageIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _pointsArr = @[].mutableCopy;
    self.view.backgroundColor = [UIColor whiteColor];
    
    tableview = [[IntergrationTableView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, _height) style:UITableViewStylePlain];
    [self.view addSubview:tableview];
    _pageIndex = 1;
    
    tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _pageIndex++;
        [self requestData];
    }];
    
    [self requestData];
    // Do any additional setup after loading the view.
}

- (void)requestData {
    [KLHttpTool supermarketGetPointWithOption:3 pageIndex:_pageIndex success:^(id response) {
        NSLog(@"%@",response);
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSDictionary *data = response[@"data"];
            NSArray *pointList = data[@"PointList"];
            if (pointList.count > 0) {
                for (NSDictionary *dic in pointList) {
                    SupermarketPointModel *point = [NSDictionary getPointModelWithDic:dic];
                    [_pointsArr addObject:point];
                }
                tableview.dataArr = _pointsArr;
                [tableview.mj_footer endRefreshing];
            } else {
                [tableview.mj_footer endRefreshingWithNoMoreData];
            }
            
        }
        else {
            [tableview removeFromSuperview];
            
            UILabel *msg = [UILabel createLabelWithFrame:CGRectMake(0, 80, APPScreenWidth, 50) textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter text:@"没有积分"];
            [self.view addSubview:msg];
            
        }

    } failure:^(NSError *err) {
        
    }];
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
