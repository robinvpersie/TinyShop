//
//  SupermarketSearchResultViewController.m
//  Portal
//
//  Created by ifox on 2016/12/20.
//  Copyright © 2016年 linpeng. All rights reserved.
//

#import "SupermarketSearchResultViewController.h"
#import "JSDropDownMenu.h"
#import "SupermarketHomeWantBuyCollectionView.h"
#import "CFDropDownMenuView.h"
#import "SupermarketHomePeopleLikeData.h"
#import "MJRefresh.h"

@interface SupermarketSearchResultViewController ()<CFDropDownMenuViewDelegate>

@property(nonatomic, strong)JSDropDownMenu *menu;
@property(nonatomic, strong)SupermarketHomeWantBuyCollectionView *wantBuyCollectionView;
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, assign)NSInteger pageIndex;
@property(nonatomic, copy) NSString *sortFiled;

@end

@implementation SupermarketSearchResultViewController {
    CFDropDownMenuView *dropDownMenuView;
    UIButton *saleSort;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = @[].mutableCopy;
    _pageIndex = 1;
    
    self.view.backgroundColor = BGColor;
    
    _sortFiled = @"item_code";
    
    [self createView];
    
    [self requestData];
    // Do any additional setup after loading the view.
}

- (void)createView {
    
    dropDownMenuView = [[CFDropDownMenuView alloc] initWithFrame:CGRectMake(0, 64, APPScreenWidth/2, 45)];
    dropDownMenuView.stateConfigDict = @{
                                         @"selected" : @[GreenColor, @"绿箭头"],  // 选中状态
                                         @"normal" : @[GreenColor, @"绿箭头"]  // 未选中状态
                                         };
    dropDownMenuView.dataSourceArr = @[
                                       @[NSLocalizedString(@"SMSearchSortDefault", nil),NSLocalizedString(@"SMSearchSortTime", nil),NSLocalizedString(@"SMSearchSortPrice", nil)],
                                       
                                       ].mutableCopy;
    dropDownMenuView.defaulTitleArray = @[NSLocalizedString(@"SMSearchSortDefault", nil)];
    dropDownMenuView.startY = CGRectGetMaxY(dropDownMenuView.frame);
    dropDownMenuView.delegate = self;
    
    [self.view addSubview:dropDownMenuView];

    
    saleSort = [UIButton buttonWithType:UIButtonTypeCustom];
    saleSort.frame = CGRectMake(APPScreenWidth/2, CGRectGetMaxY(dropDownMenuView.frame) - 45, APPScreenWidth/2, 45);
    [saleSort setTitle:NSLocalizedString(@"SMSearchSortSales", nil) forState:UIControlStateNormal];
    saleSort.titleLabel.font = [UIFont systemFontOfSize:15];
    saleSort.backgroundColor = [UIColor whiteColor];
    [saleSort setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [saleSort setTitleColor:GreenColor forState:UIControlStateSelected];
    [saleSort addTarget:self action:@selector(sortGoodsBySaleAmount:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:saleSort aboveSubview:dropDownMenuView];
    
    
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    layOut.minimumInteritemSpacing = 0;
    layOut.minimumLineSpacing = 0;
    layOut.itemSize = CGSizeMake((APPScreenWidth - 4)/2, (APPScreenWidth - 4)/2+75);
    layOut.sectionInset = UIEdgeInsetsMake(2, 0, 2, 0);
    layOut.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _wantBuyCollectionView = [[SupermarketHomeWantBuyCollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(saleSort.frame) +1.0f, APPScreenWidth, self.view.frame.size.height-64-45) collectionViewLayout:layOut];
    [self.view addSubview:_wantBuyCollectionView];
    
    _wantBuyCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataArray removeAllObjects];
        _pageIndex = 1;
        [self requestData];
    }];
    
    _wantBuyCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _pageIndex++;
        [self requestData];
    }];
    
    self.navigationItem.hidesBackButton = YES;
    
    UILabel *searchFeild = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth - 80, 30)];
    searchFeild.layer.cornerRadius = 2.0f;
    searchFeild.userInteractionEnabled = YES;
    searchFeild.text = self.searchKeyWord;
    searchFeild.font = [UIFont systemFontOfSize:14];
    searchFeild.textColor = [UIColor grayColor];
    searchFeild.backgroundColor = RGB(226, 230, 231);
    self.navigationItem.titleView = searchFeild;
    
    UITapGestureRecognizer *gosearch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchSearch)];
    [searchFeild addGestureRecognizer:gosearch];
    
    UIBarButtonItem *cancle = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"SMAlertCancelTitle", nil) style:UIBarButtonItemStylePlain target:self action:@selector(dismissController)];
    self.navigationItem.rightBarButtonItem = cancle;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
}

- (void)requestData {
//    NSMutableArray *dataArray = @[].mutableCopy;
    [KLHttpTool getSearchResultWithKeyWords:self.searchKeyWord orderByType:0 sortField:_sortFiled pageIndex:_pageIndex appType:6 success:^(id response) {
        NSLog(@"%@",response);
        NSNumber *status = response[@"status"];
        if (status.integerValue == 1) {
            NSArray *data = response[@"data"];
            if (data.count > 0) {
                for (NSDictionary *dic in data) {
                 SupermarketHomePeopleLikeData *data = [NSDictionary getSupermarketSearchResultModelWithDic:dic];
                    [self.dataArray addObject:data];
                }
                _wantBuyCollectionView.dataArray = _dataArray;
                [_wantBuyCollectionView.mj_header endRefreshing];
                [_wantBuyCollectionView.mj_footer endRefreshing];
            } else {
                [_wantBuyCollectionView.mj_footer endRefreshingWithNoMoreData];
            }
            if (self.dataArray.count == 0) {
                _wantBuyCollectionView.hidden = YES;
                UIImageView *noData = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
                noData.image = [UIImage imageNamed:@"no_search"];
                noData.center = self.view.center;
                [self.view addSubview:noData];
                UILabel *msg = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(noData.frame)+10, APPScreenWidth, 25)];
                msg.text = NSLocalizedString(@"SMSearchNoResult", nil);
                msg.textColor = [UIColor lightGrayColor];
                msg.font = [UIFont systemFontOfSize:15];
                msg.textAlignment = NSTextAlignmentCenter;
                [self.view addSubview:msg];
            }
        }
    } failure:^(NSError *err) {
        
    }];
}

//回到主页
- (void)dismissController {
    [self dismissViewControllerAnimated:NO completion:nil];
//    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}

//弹回到搜索页
- (void)touchSearch {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)sortGoodsBySaleAmount:(UIButton *)button {
    button.selected = YES;
    for (UIButton *titleButton in dropDownMenuView.titleBtnArr) {
        [titleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [titleButton setImage:[UIImage imageNamed:@"灰箭头"] forState:UIControlStateNormal];
    }
    _sortFiled = @"sold";
    [self.dataArray removeAllObjects];
    [self requestData];
}

- (void)dropDownMenuView:(CFDropDownMenuView *)dropDownMenuView clickOnCurrentButtonWithTitle:(NSString *)currentTitle andCurrentTitleArray:(NSArray *)currentTitleArray {
      saleSort.selected = NO;
    NSLog(@"%@",currentTitle);
    if ([currentTitle isEqualToString:NSLocalizedString(@"SMSearchSortDefault", nil)]) {
        _sortFiled = @"item_code";
    }
    if ([currentTitle isEqualToString:NSLocalizedString(@"SMSearchSortTime", nil)]) {
        _sortFiled = @"public_date";
    }
    if ([currentTitle isEqualToString:NSLocalizedString(@"SMSearchSortPrice", nil)]) {
        _sortFiled = @"price";
    }
    [self.dataArray removeAllObjects];
    
    [self requestData];
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
