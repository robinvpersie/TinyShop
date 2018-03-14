//
//  SupermarketKindPriceController.m
//  Portal
//
//  Created by ifox on 2016/12/22.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketKindPriceController.h"
#import "SupermarketHomeWantBuyCollectionView.h"
#import "MJRefresh.h"

@interface SupermarketKindPriceController ()

@property(nonatomic, strong) SupermarketHomeWantBuyCollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *dataArry;
@property(nonatomic, assign) NSInteger index;

@end

@implementation SupermarketKindPriceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BGColor;
    _dataArry = @[].mutableCopy;
    
    _index = 1;
    
//    [self createView];
    
     [self requestData];
    [self createEmptyView];
    // Do any additional setup after loading the view.
}

- (void)createView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
        layOut.minimumInteritemSpacing = 0;
        layOut.minimumLineSpacing = 0;
        layOut.itemSize = CGSizeMake((APPScreenWidth - 4)/2, (APPScreenWidth - 4)/2+75);
        layOut.sectionInset = UIEdgeInsetsMake(2, 0, 2, 0);
        layOut.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[SupermarketHomeWantBuyCollectionView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, self.view.frame.size.height) collectionViewLayout:layOut];
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [_dataArry removeAllObjects];
            _index = 1;
            [self requestData];
        }];
        _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _index++;
            [self requestData];
        }];
        
        [self.view addSubview:_collectionView];
    }
}

- (void)createEmptyView {
    UIImageView *noData = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    noData.image = [UIImage imageNamed:@"no_search"];
    noData.center = CGPointMake(self.view.center.x, self.view.center.y - 64 - 44);
    [self.view addSubview:noData];
    UILabel *msg = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(noData.frame)+10, APPScreenWidth, 25)];
    msg.text = NSLocalizedString(@"SMSearchNoResult", nil);
    msg.textColor = [UIColor lightGrayColor];
    msg.font = [UIFont systemFontOfSize:15];
    msg.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:msg];
}

- (void)requestData {
    [KLHttpTool getSupermarketKindListWithKindCode:self.category_code level:self.level orderByType:1 sortField:@"price" pageindex:_index pageSize:10 success:^(id response) {
        NSLog(@"%@",response);
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSArray *data = response[@"data"];
            if (data.count > 0) {
                for (NSDictionary *dic in data) {
                    SupermarketHomePeopleLikeData *goodData = [NSDictionary getSupermarketKindsGoodListDataWithDic:dic];
                    [_dataArry addObject:goodData];
                }
                _collectionView.dataArray = _dataArry;
                [_collectionView.mj_footer endRefreshing];
            } else {
                [_collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [_collectionView.mj_header endRefreshing];
        [self chageView];
    } failure:^(NSError *err) {
        
    }];
}

- (void)chageView {
    if (_dataArry.count > 0) {
        [self createView];
        _collectionView.dataArray = _dataArry;
    }
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
